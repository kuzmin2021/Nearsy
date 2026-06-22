import '/floter/floter_util.dart';
import '/backend/supabase/supabase.dart';
import 'nearby_search_preferences_page_widget.dart'
    show NearbySearchPreferencesPageWidget;
import 'package:flutter/material.dart';

class NearbySearchPreferencesPageModel
    extends FloterModel<NearbySearchPreferencesPageWidget> {
  static const visibleValue = 'visible';
  static const invisibleValue = 'invisible';

  VoidCallback? onStateChanged;

  String selectedMode = visibleValue;
  String locationLabel = '';

  @override
  void initState(BuildContext context) {
    _loadCurrentMode();
  }

  @override
  void dispose() {}

  Future<void> _loadCurrentMode() async {
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
        final mode = data['location_mode'] as String?;
        if (mode == invisibleValue) {
          selectedMode = invisibleValue;
        } else {
          selectedMode = visibleValue;
        }
        locationLabel = data['location_label'] as String? ?? '';
        onStateChanged?.call();
      }
    } catch (_) {}
  }

  Future<void> saveVisibilityMode() async {
    final userId = SupaFlow.client.auth.currentUser?.id;
    if (userId == null) return;

    await SupaFlow.client.from('profiles').upsert({
      'user_id': userId,
      'location_mode': selectedMode,
    }, onConflict: 'user_id', defaultToNull: false);
  }
}
