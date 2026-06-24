import '/components/nearsy_bottom_nav_widget.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'nearby_page_model.dart';

export 'nearby_page_model.dart';

class NearbyPageWidget extends StatefulWidget {
  const NearbyPageWidget({super.key});

  static String routeName = 'NearbyPage';
  static String routePath = '/nearby';

  @override
  State<NearbyPageWidget> createState() => _NearbyPageWidgetState();
}

class _NearbyPageWidgetState extends State<NearbyPageWidget> {
  late NearbyPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NearbyPageModel());
    _model.onStateChanged = () => safeSetState(() {});
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FloterTheme.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 8.0),
                child: _buildHeader(context, theme),
              ),
              Expanded(
                flex: 1,
                child: _buildMap(context, theme),
              ),
              wrapWithModel(
                model: _model.nearsyBottomNavModel,
                updateCallback: () => safeSetState(() {}),
                child: const NearsyBottomNavWidget(
                  activeTab: 'Nearby',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, FloterTheme theme) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLabels.of(context).get('nearby.title'),
              style: GoogleFonts.inter(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: theme.primary,
              ),
            ),
          ].divide(const SizedBox(width: 4.0)),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FloterIconButton(
              borderRadius: 8.0,
              buttonSize: 40.0,
              fillColor: theme.primaryBackground,
              icon: Icon(
                Icons.tune,
                color: theme.primaryText,
                size: 22.0,
              ),
              onPressed: () async {
                await context
                    .pushNamed(NearbySearchPreferencesPageWidget.routeName);
                _model.refreshAll();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMap(BuildContext context, FloterTheme theme) {
    if (_model.currentLocation == null) {
      return Center(
        child: _model.isLoadingProfiles
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_off,
                      size: 48, color: theme.secondaryText),
                  const SizedBox(height: 12),
                  Text(
                    AppLabels.of(context).get('nearby.unknown_location'),
                    style: GoogleFonts.inter(
                      color: theme.secondaryText,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
      );
    }

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _model.currentLocation!,
                  zoom: 12.0,
                ),
                circles: _model.circles,
                markers: _model.markers,
                onMapCreated: _model.onMapCreated,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
              ),
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: FloterIconButton(
                  borderRadius: 16.0,
                  buttonSize: 44.0,
                  fillColor: Colors.white,
                  icon: Icon(
                    Icons.my_location,
                    color: theme.primaryText,
                    size: 24.0,
                  ),
                  onPressed: () => _model.centerOnUser(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
