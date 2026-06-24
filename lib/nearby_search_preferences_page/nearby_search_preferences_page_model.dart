import '/floter/floter_util.dart';
import '/backend/supabase/supabase.dart';
import 'nearby_search_preferences_page_widget.dart'
    show NearbySearchPreferencesPageWidget;
import 'package:flutter/material.dart';

class NearbySearchPreferencesPageModel
    extends FloterModel<NearbySearchPreferencesPageWidget> {
  static const visibleValue = 'visible';
  static const invisibleValue = 'invisible';
  static const frozenValue = 'frozen';

  VoidCallback? onStateChanged;

  String selectedMode = invisibleValue;
  String locationLabel = '';

  @override
  void initState(BuildContext context) {
    _loadCurrentSettings();
  }

  @override
  void dispose() {}

  Future<void> _loadCurrentSettings() async {
    final userId = SupaFlow.client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final response = await SupaFlow.client
          .from('profiles')
          .select(
              'location_mode, location_label, nearby_radius_km, nearby_limit')
          .eq('user_id', userId)
          .maybeSingle();

      if (response != null) {
        final data = response;
        final mode = data['location_mode'] as String?;
        if (mode == invisibleValue) {
          selectedMode = invisibleValue;
        } else if (mode == frozenValue) {
          selectedMode = frozenValue;
        } else {
          selectedMode = visibleValue;
        }
        locationLabel = data['location_label'] as String? ?? '';
        onStateChanged?.call();
      }
    } catch (_) {}
  }

  Future<void> saveSettings() async {
    final userId = SupaFlow.client.auth.currentUser?.id;
    if (userId == null) return;

    if (selectedMode == invisibleValue) {
      await SupaFlow.client
          .from('profiles')
          .update({
            'location_mode': invisibleValue,
            'public_location': null,
            'public_location_updated_at': null,
            'public_location_expires_at': null,
          })
          .eq('user_id', userId);
    } else {
      await SupaFlow.client
          .from('profiles')
          .upsert({
            'user_id': userId,
            'location_mode': selectedMode,
          }, onConflict: 'user_id', defaultToNull: false);
    }
  }
}
