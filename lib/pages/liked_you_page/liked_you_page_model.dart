import '/components/lookaround_bottom_nav_widget.dart';
import '/floter/floter_util.dart';
import '/backend/supabase/supabase.dart';
import '/app_state.dart';
import 'liked_you_page_widget.dart' show LikedYouPageWidget;
import 'dart:convert';
import 'package:flutter/material.dart';

class InboundLikeProfile {
  InboundLikeProfile({
    required this.profileId,
    required this.userId,
    required this.displayName,
    required this.photos,
    this.age,
    this.gender,
    this.avatarUrl,
    this.distanceKm,
    this.locationLabel,
    this.likedAt,
  });

  final int profileId;
  final String userId;
  final String displayName;
  final int? age;
  final String? gender;
  final String? avatarUrl;
  final double? distanceKm;
  final String? locationLabel;
  final DateTime? likedAt;
  final List<String> photos;
}

class LikedYouPageModel extends FloterModel<LikedYouPageWidget> {
  List<InboundLikeProfile> profiles = [];
  bool isLoading = false;
  String loadError = '';
  String activeFilter = 'all';
  bool hasMore = true;
  int allCount = 0;
  int matchesCount = 0;
  int outsideCount = 0;

  VoidCallback? onStateChanged;
  void Function(String userId, String matchName, String matchPhoto)? onMatchFound;

  static const _pageSize = 20;

  late LookaroundBottomNavModel lookaroundBottomNavModel;

  @override
  void initState(BuildContext context) {
    lookaroundBottomNavModel =
        createModel(context, () => LookaroundBottomNavModel());
    loadLikes();
    loadCounts();
  }

  @override
  void dispose() {
    lookaroundBottomNavModel.dispose();
  }

  Future<void> loadLikes({bool append = false}) async {
    if (isLoading) return;
    if (append && !hasMore) return;

    isLoading = true;
    loadError = '';
    notify();

    try {
      final response = await SupaFlow.client.rpc('get_inbound_likes_v2', params: {
        'p_filter': activeFilter,
        'p_limit': _pageSize,
        'p_offset': append ? profiles.length : 0,
      });

      final rows = response as List<dynamic>? ?? [];
      final parsed = rows.map((r) => _parseProfile(r as Map<String, dynamic>)).toList();

      if (append) {
        profiles.addAll(parsed);
      } else {
        profiles = parsed;
      }
      hasMore = parsed.length >= _pageSize;
      isLoading = false;
    } catch (e) {
      loadError = e.toString();
      isLoading = false;
    }
    notify();
  }

  InboundLikeProfile _parseProfile(Map<String, dynamic> row) {
    final rawPhotos = row['photos'];
    final List<String> photoList;
    if (rawPhotos is String) {
      final decoded = jsonDecode(rawPhotos);
      photoList = _resolvePhotos(decoded);
    } else {
      photoList = _resolvePhotos(rawPhotos);
    }

    final avatarUrl = SupaFlow.resolvePhotoUrl(row['avatar_url']);
    if (avatarUrl != null && avatarUrl.isNotEmpty && !photoList.contains(avatarUrl)) {
      photoList.insert(0, avatarUrl);
    }

    return InboundLikeProfile(
      profileId: row['profile_id'] as int? ?? 0,
      userId: row['user_id'] as String? ?? '',
      displayName: row['display_name'] as String? ?? '',
      age: row['age'] as int?,
      gender: row['gender'] as String?,
      avatarUrl: avatarUrl,
      distanceKm: (row['distance_km'] as num?)?.toDouble(),
      locationLabel: row['location_label'] as String?,
      likedAt: row['liked_at'] != null ? DateTime.tryParse(row['liked_at'] as String) : null,
      photos: photoList,
    );
  }

  List<String> _resolvePhotos(dynamic photosData) {
    if (photosData == null) return [];
    final List<dynamic> items = photosData is List ? photosData : [];
    return items
        .map((item) {
          if (item is String) return item;
          if (item is Map<String, dynamic>) {
            final path = item['path'] as String?;
            if (path == null || path.isEmpty) return null;
            return SupaFlow.publicPhotoUrl(path);
          }
          return null;
        })
        .whereType<String>()
        .toList();
  }

  void setFilter(String filter) {
    if (activeFilter == filter) return;
    activeFilter = filter;
    profiles.clear();
    hasMore = true;
    loadLikes();
  }

  Future<void> loadCounts() async {
    try {
      final results = await Future.wait([
        SupaFlow.client.rpc('get_inbound_likes_v2', params: {'p_filter': 'all', 'p_limit': 100, 'p_offset': 0}),
        SupaFlow.client.rpc('get_inbound_likes_v2', params: {'p_filter': 'matches', 'p_limit': 100, 'p_offset': 0}),
        SupaFlow.client.rpc('get_inbound_likes_v2', params: {'p_filter': 'outside', 'p_limit': 100, 'p_offset': 0}),
      ]);
      allCount = (results[0] as List<dynamic>?)?.length ?? 0;
      matchesCount = (results[1] as List<dynamic>?)?.length ?? 0;
      outsideCount = (results[2] as List<dynamic>?)?.length ?? 0;
      notify();
    } catch (_) {}
  }

  Future<void> passUser(String targetUserId) async {
    final userId = SupaFlow.client.auth.currentUser?.id;
    if (userId == null || targetUserId.isEmpty) return;

    await SupaFlow.client.from('swipe_events').upsert({
      'user_id': userId,
      'target_user_id': targetUserId,
      'action': 'pass',
    }, onConflict: 'user_id, target_user_id', defaultToNull: false);

    profiles.removeWhere((p) => p.userId == targetUserId);
    notify();
  }

  Future<void> likeUser(String targetUserId) async {
    final userId = SupaFlow.client.auth.currentUser?.id;
    if (userId == null || targetUserId.isEmpty) return;

    await SupaFlow.client.from('swipe_events').upsert({
      'user_id': userId,
      'target_user_id': targetUserId,
      'action': 'like',
    }, onConflict: 'user_id, target_user_id', defaultToNull: false);

    final profile = profiles.cast<InboundLikeProfile?>().firstWhere(
      (p) => p?.userId == targetUserId,
      orElse: () => null,
    );

    final isMutual = await _checkMutualLike(targetUserId);
    if (isMutual) {
      await _createConversation(targetUserId);
      FTAppState().updateLastCheckedMatchAt(DateTime.now().toUtc());
      onMatchFound?.call(
        targetUserId,
        profile?.displayName ?? '',
        profile?.avatarUrl ?? '',
      );
    }

    profiles.removeWhere((p) => p.userId == targetUserId);
    notify();
  }

  Future<bool> _checkMutualLike(String otherUserId) async {
    final userId = SupaFlow.client.auth.currentUser?.id;
    if (userId == null || otherUserId.isEmpty) return false;

    try {
      final response = await SupaFlow.client
          .from('swipe_events')
          .select('id')
          .eq('user_id', otherUserId)
          .eq('target_user_id', userId)
          .eq('action', 'like')
          .limit(1);
      final rows = response as List<dynamic>? ?? [];
      return rows.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> _createConversation(String otherUserId) async {
    final userId = SupaFlow.client.auth.currentUser?.id;
    if (userId == null) return;

    final users = [userId, otherUserId]..sort();
    try {
      await SupaFlow.client.from('conversations').insert({
        'user1': users[0],
        'user2': users[1],
      });
    } catch (_) {}
  }

  void notify() {
    if (onStateChanged != null) {
      onStateChanged!();
    }
  }
}
