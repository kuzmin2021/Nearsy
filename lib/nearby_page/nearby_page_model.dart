import '/components/nearsy_bottom_nav_widget.dart';
import '/floter/floter_util.dart' hide LatLng;
import '/backend/supabase/supabase.dart' hide LatLng;
import '/pages/people_page/people_page_model.dart' show DiscoveryProfile;
import '/index.dart';
import 'nearby_page_widget.dart' show NearbyPageWidget;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class NearbyPageModel extends FloterModel<NearbyPageWidget> {
  VoidCallback? onStateChanged;

  bool isLoadingProfiles = true;
  String loadError = '';
  List<DiscoveryProfile> profiles = [];
  String locationLabel = '';
  bool isVisible = true;
  int searchRadiusKm = 25;
  int searchLimit = 50;

  LatLng? currentLocation;
  final Set<Circle> circles = {};
  final Set<Marker> markers = {};
  GoogleMapController? mapController;

  late NearsyBottomNavModel nearsyBottomNavModel;

  @override
  void initState(BuildContext context) {
    nearsyBottomNavModel = createModel(context, () => NearsyBottomNavModel());
    _loadAll();
  }

  @override
  void dispose() {
    nearsyBottomNavModel.dispose();
    mapController?.dispose();
  }

  void refreshAll() {
    _loadAll();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> centerOnUser() async {
    if (mapController == null || currentLocation == null) return;
    await mapController!.animateCamera(
      CameraUpdate.newLatLng(currentLocation!),
    );
  }

  Future<void> _loadAll() async {
    await _loadCurrentLocation();
    await _updateNearbyPresence();
    await Future.wait([
      _loadVisibilityStatus(),
      _loadNearbyProfiles(),
    ]);
  }

  Future<void> _loadCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        loadError = 'location_disabled';
        isLoadingProfiles = false;
        onStateChanged?.call();
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          loadError = 'location_denied';
          isLoadingProfiles = false;
          onStateChanged?.call();
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        loadError = 'location_denied_forever';
        isLoadingProfiles = false;
        onStateChanged?.call();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );
      currentLocation = LatLng(position.latitude, position.longitude);
      loadError = '';
      onStateChanged?.call();
    } catch (e) {
      loadError = e.toString();
      currentLocation = null;
      isLoadingProfiles = false;
      onStateChanged?.call();
    }
  }

  Future<void> _loadVisibilityStatus() async {
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
        isVisible = data['location_mode'] != 'invisible';
        locationLabel = data['location_label'] as String? ?? '';
        searchRadiusKm = (data['nearby_radius_km'] as int?) ?? 25;
        searchLimit = (data['nearby_limit'] as int?) ?? 50;
        onStateChanged?.call();
      }
    } catch (_) {}
  }

  Future<void> _loadNearbyProfiles() async {
    isLoadingProfiles = true;
    loadError = '';
    onStateChanged?.call();

    final loc = currentLocation;
    if (loc == null) {
      isLoadingProfiles = false;
      onStateChanged?.call();
      return;
    }

    try {
      final response =
          await SupaFlow.client.rpc('get_nearby_profiles_v3', params: {
        'p_lat': loc.latitude,
        'p_lng': loc.longitude,
        'p_radius_km': searchRadiusKm,
        'p_limit': searchLimit,
      });

      final rows = response as List<dynamic>? ?? [];
      profiles =
          rows.map((r) => DiscoveryProfile.fromRow(r as Map<String, dynamic>)).toList();
      _buildCircles();
      await _addCurrentUserPresenceCircle();
      isLoadingProfiles = false;
    } catch (e) {
      loadError = e.toString();
      isLoadingProfiles = false;
    }
    onStateChanged?.call();
  }

  Future<void> _updateNearbyPresence() async {
    final loc = currentLocation;
    if (loc == null) return;

    try {
      await SupaFlow.client.rpc('update_nearby_presence', params: {
        'p_lat': loc.latitude,
        'p_lng': loc.longitude,
      });
    } catch (_) {}
  }

  void _buildCircles() {
    circles.clear();
    markers.clear();

    for (final profile in profiles) {
      if (profile.latitude == null || profile.longitude == null) continue;

      final isFrozen = profile.presenceType == 'frozen';
      final position = LatLng(profile.latitude!, profile.longitude!);
      final markerColor = isFrozen ? Colors.purple : Colors.blue;

      circles.add(
        Circle(
          circleId: CircleId('area_${profile.userId}'),
          center: position,
          radius: 1000,
          fillColor: markerColor.withValues(alpha: 0.08),
          strokeColor: markerColor.withValues(alpha: 0.25),
          strokeWidth: isFrozen ? 2 : 1,
        ),
      );

      markers.add(
        Marker(
          markerId: MarkerId('marker_${profile.userId}'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isFrozen ? BitmapDescriptor.hueViolet : BitmapDescriptor.hueAzure,
          ),
          infoWindow: InfoWindow(
            title: profile.displayName,
            snippet: profile.locationLabel ?? '',
          ),
        ),
      );
    }
  }

  Future<void> _addCurrentUserPresenceCircle() async {
    final userId = SupaFlow.client.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) return;

    final userAlreadyIncluded = profiles.any(
      (profile) =>
          profile.userId == userId &&
          profile.latitude != null &&
          profile.longitude != null,
    );
    if (userAlreadyIncluded) return;

    try {
      final response = await SupaFlow.client.rpc('get_my_nearby_presence');
      final rows = response as List<dynamic>? ?? [];
      if (rows.isEmpty) return;

      final row = rows.first as Map<String, dynamic>;
      final latitude = (row['latitude'] as num?)?.toDouble();
      final longitude = (row['longitude'] as num?)?.toDouble();
      if (latitude == null || longitude == null) return;

      final presenceType = row['presence_type'] as String?;
      final isFrozen = presenceType == 'frozen';
      final position = LatLng(latitude, longitude);
      final markerColor = isFrozen ? Colors.purple : Colors.green;

      circles.add(
        Circle(
          circleId: CircleId('area_$userId'),
          center: position,
          radius: 1000,
          fillColor: markerColor.withValues(alpha: 0.08),
          strokeColor: markerColor.withValues(alpha: 0.25),
          strokeWidth: isFrozen ? 2 : 1,
        ),
      );

      markers.add(
        Marker(
          markerId: MarkerId('marker_$userId'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isFrozen ? BitmapDescriptor.hueViolet : BitmapDescriptor.hueGreen,
          ),
          infoWindow: const InfoWindow(title: 'You'),
        ),
      );
    } catch (_) {}
  }
}
