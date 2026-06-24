import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '/backend/supabase/supabase.dart';
import '/app_state.dart';
import '/floter/nav/nav.dart';
import '/pages/matches_page/matches_page_widget.dart';
import '/services/i18n/app_labels.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }

    _initialized = true;
  }

  Future<void> checkUnseenMatches() async {
    final userId = SupaFlow.client.auth.currentUser?.id;
    if (userId == null) return;

    final lastChecked = FTAppState().lastCheckedMatchAt;
    final now = DateTime.now().toUtc();

    try {
      final baseQuery = SupaFlow.client
          .from('conversations')
          .select('id, user1, user2, match_created_at')
          .or('user1.eq.$userId,user2.eq.$userId');

      final List<dynamic> rows;
      if (lastChecked != null) {
        rows = await baseQuery.gt(
          'match_created_at',
          lastChecked.toUtc().toIso8601String(),
        ) as List<dynamic>;
      } else {
        rows = await baseQuery as List<dynamic>;
      }

      for (final row in rows) {
        final convId = row['id'] as int;
        final user1 = row['user1'] as String? ?? '';
        final user2 = row['user2'] as String? ?? '';
        final otherId = user1 == userId ? user2 : user1;
        final matchCreatedAt = row['match_created_at'] as String?;

        final matchTime = matchCreatedAt != null
            ? DateTime.tryParse(matchCreatedAt)
            : null;

        if (lastChecked != null && matchTime != null && !matchTime.isAfter(lastChecked)) {
          continue;
        }

        final profileResp = await SupaFlow.client
            .from('profiles')
            .select('display_name, avatar_url')
            .eq('user_id', otherId)
            .maybeSingle();

        final name = profileResp?['display_name'] as String? ?? 'Someone';
        final avatarPath = profileResp?['avatar_url'] as String?;
        final avatarUrl = SupaFlow.safePhotoUrl(avatarPath);

        await showMatchNotification(
          convId,
          otherId,
          name,
          avatarUrl,
        );
      }
    } catch (_) {}

    await FTAppState().updateLastCheckedMatchAt(now);
  }

  Future<void> showMatchNotification(
    int conversationId,
    String otherUserId,
    String name,
    String? avatarUrl,
  ) async {
    final androidDetails = AndroidNotificationDetails(
      'match_channel',
      'New Matches',
      channelDescription: 'Notifications for new matches',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    final payload = jsonEncode({
      'conversationId': conversationId,
      'otherUserId': otherUserId,
    });

    await _plugin.show(
      otherUserId.hashCode,
      AppLabels.t('notification.match_title'),
      AppLabels.t('notification.match_body').replaceAll('%s', name),
      details,
      payload: payload,
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    final context = appNavigatorKey.currentContext;
    if (context == null) return;

    GoRouter.of(context).goNamed(MatchesPageWidget.routeName);
  }
}
