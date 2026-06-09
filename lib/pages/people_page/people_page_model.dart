import '/components/lookaround_bottom_nav_widget.dart';
import '/floter/floter_util.dart';
import '/backend/supabase/supabase.dart';
import 'people_page_widget.dart' show PeoplePageWidget;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class DiscoveryProfile {
  DiscoveryProfile({
    required this.profileId,
    required this.userId,
    required this.displayName,
    required this.photos,
    this.age,
    this.gender,
    this.catchphrase,
    this.description,
    this.avatarUrl,
    this.distanceKm,
    this.locationLabel,
    this.work,
    this.education,
    this.kids,
    this.relationshipType,
    this.religion,
    this.bodyType,
    this.exercise,
    this.drinking,
    this.smoking,
    this.height,
    this.languages,
  });

  final int profileId;
  final String userId;
  final String displayName;
  final int? age;
  final String? gender;
  final String? catchphrase;
  final String? description;
  final String? avatarUrl;
  final double? distanceKm;
  final String? locationLabel;
  final String? work;
  final String? education;
  final String? kids;
  final String? relationshipType;
  final String? religion;
  final String? bodyType;
  final String? exercise;
  final String? drinking;
  final String? smoking;
  final String? height;
  final String? languages;
  final List<String> photos;
}

class PeoplePageModel extends FloterModel<PeoplePageWidget> {
  VoidCallback? onStateChanged;

  bool isLoadingProfiles = true;
  String loadError = '';
  List<DiscoveryProfile> profiles = [];
  int currentProfileIndex = 0;
  List<String> swipedUserIds = [];

  late CardSwiperController candidateSwipeableStackController;
  late LookaroundBottomNavModel lookaroundBottomNavModel;

  @override
  void initState(BuildContext context) {
    candidateSwipeableStackController = CardSwiperController();
    lookaroundBottomNavModel =
        createModel(context, () => LookaroundBottomNavModel());
    _loadProfiles();
  }

  @override
  void dispose() {
    candidateSwipeableStackController.dispose();
    lookaroundBottomNavModel.dispose();
  }

  void refreshProfiles() {
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    isLoadingProfiles = true;
    loadError = '';
    onStateChanged?.call();

    try {
      final response = await SupaFlow.client
          .rpc('get_discovery_feed_v2', params: {'p_limit': 20, 'p_offset': 0});

      final rows = response as List<dynamic>? ?? [];
      profiles = rows.map((r) => _parseProfile(r as Map<String, dynamic>)).toList();
      currentProfileIndex = 0;
      swipedUserIds.clear();
      isLoadingProfiles = false;
    } catch (e) {
      loadError = e.toString();
      isLoadingProfiles = false;
    }
    onStateChanged?.call();
  }

  DiscoveryProfile _parseProfile(Map<String, dynamic> row) {
    final rawPhotos =
        row['photos'] is String ? jsonDecode(row['photos'] as String) : row['photos'];
    final photoList = _resolvePhotos(rawPhotos);
    final avatarUrl = SupaFlow.resolvePhotoUrl(row['avatar_url']);
    if (avatarUrl != null && avatarUrl.isNotEmpty && !photoList.contains(avatarUrl)) {
      photoList.insert(0, avatarUrl);
    }

    return DiscoveryProfile(
      profileId: row['profile_id'] as int? ?? 0,
      userId: row['user_id'] as String? ?? '',
      displayName: row['display_name'] as String? ?? '',
      age: row['age'] as int?,
      gender: row['gender'] as String?,
      catchphrase: row['catchphrase'] as String?,
      description: row['description'] as String?,
      avatarUrl: avatarUrl,
      distanceKm: (row['distance_km'] as num?)?.toDouble(),
      locationLabel: row['location_label'] as String?,
      work: row['work'] as String?,
      education: row['education'] as String?,
      kids: row['kids'] as String?,
      relationshipType: row['relationship_type'] as String?,
      religion: row['religion'] as String?,
      bodyType: row['body_type'] as String?,
      exercise: row['exercise'] as String?,
      drinking: row['drinking'] as String?,
      smoking: row['smoking'] as String?,
      height: row['height'] as String?,
      languages: row['languages'] as String?,
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

  Future<void> persistSwipe(String targetUserId, String action) async {
    final userId = SupaFlow.client.auth.currentUser?.id;
    if (userId == null || targetUserId.isEmpty) return;

    await SupaFlow.client.from('swipe_events').upsert(
      {
        'user_id': userId,
        'target_user_id': targetUserId,
        'action': action,
      },
      onConflict: 'user_id, target_user_id',
    );
  }

  void _afterSwipe(String targetUserId) {
    swipedUserIds.add(targetUserId);
    currentProfileIndex++;
    onStateChanged?.call();
  }

  void swipeLeft() {
    final profile = currentProfile;
    if (profile == null) return;
    persistSwipe(profile.userId, 'pass');
    _afterSwipe(profile.userId);
  }

  void swipeRight() {
    final profile = currentProfile;
    if (profile == null) return;
    persistSwipe(profile.userId, 'like');
    _afterSwipe(profile.userId);
  }

  void undoSwipe() {
    if (swipedUserIds.isEmpty) return;
    final lastUserId = swipedUserIds.removeLast();
    if (currentProfileIndex > 0) {
      currentProfileIndex--;
    }
    unawaited(
      SupaFlow.client
          .from('swipe_events')
          .delete()
          .eq('user_id', SupaFlow.client.auth.currentUser?.id ?? '')
          .eq('target_user_id', lastUserId),
    );
    onStateChanged?.call();
  }

  void superLike() {
    final profile = currentProfile;
    if (profile == null) return;
    candidateSwipeableStackController.swipeRight();
    persistSwipe(profile.userId, 'like');
    _afterSwipe(profile.userId);
  }

  void boostProfile() {}

  DiscoveryProfile? get currentProfile {
    if (profiles.isEmpty) return null;
    if (currentProfileIndex < 0 || currentProfileIndex >= profiles.length) {
      return null;
    }
    return profiles[currentProfileIndex];
  }
}
