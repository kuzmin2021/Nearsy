import '/components/nearsy_bottom_nav_widget.dart';
import '/floter/floter_util.dart';
import '/backend/supabase/supabase.dart';
import '/pages/people_page/people_page_model.dart' show DiscoveryProfile;
import '/index.dart';
import 'nearby_page_widget.dart' show NearbyPageWidget;
import 'package:flutter/material.dart';

class NearbyPageModel extends FloterModel<NearbyPageWidget> {
  VoidCallback? onStateChanged;

  bool isLoadingProfiles = true;
  String loadError = '';
  List<DiscoveryProfile> profiles = [];
  String locationLabel = '';
  bool isVisible = true;

  late NearsyBottomNavModel nearsyBottomNavModel;

  @override
  void initState(BuildContext context) {
    nearsyBottomNavModel =
        createModel(context, () => NearsyBottomNavModel());
    _loadAll();
  }

  @override
  void dispose() {
    nearsyBottomNavModel.dispose();
  }

  void refreshAll() {
    _loadAll();
  }

  Future<void> _loadAll() async {
    await Future.wait([
      _loadVisibilityStatus(),
      _loadNearbyProfiles(),
    ]);
  }

  Future<void> _loadVisibilityStatus() async {
    final userId = SupaFlow.client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final response = await SupaFlow.client
          .from('profiles')
          .select('location_mode, location_label')
          .eq('user_id', userId)
          .maybeSingle();

      if (response != null) {
        final data = response;
        isVisible = data['location_mode'] != 'invisible';
        locationLabel = data['location_label'] as String? ?? '';
        onStateChanged?.call();
      }
    } catch (_) {}
  }

  Future<void> _loadNearbyProfiles() async {
    isLoadingProfiles = true;
    loadError = '';
    onStateChanged?.call();

    try {
      final response = await SupaFlow.client
          .rpc('get_nearby_profiles_v2', params: {
        'p_radius_km': 25,
        'p_limit': 50,
      });

      final rows = response as List<dynamic>? ?? [];
      profiles = rows.map((r) => _parseProfile(r as Map<String, dynamic>)).toList();
      isLoadingProfiles = false;
    } catch (e) {
      loadError = e.toString();
      isLoadingProfiles = false;
    }
    onStateChanged?.call();
  }

  DiscoveryProfile _parseProfile(Map<String, dynamic> row) {
    final avatarUrl = SupaFlow.resolvePhotoUrl(row['avatar_url']);

    return DiscoveryProfile(
      profileId: row['profile_id'] as int? ?? 0,
      userId: row['user_id'] as String? ?? '',
      displayName: row['display_name'] as String? ?? '',
      age: row['age'] as int?,
      gender: row['gender'] as String?,
      avatarUrl: avatarUrl,
      distanceKm: (row['distance_km'] as num?)?.toDouble(),
      locationLabel: row['location_label'] as String?,
      photos: avatarUrl != null && avatarUrl.isNotEmpty ? [avatarUrl] : [],
    );
  }
}
