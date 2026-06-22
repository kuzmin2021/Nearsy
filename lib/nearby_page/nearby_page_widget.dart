import '/components/nearsy_bottom_nav_widget.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import '/pages/people_page/people_page_model.dart' show DiscoveryProfile;
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final visibleLabel = _model.locationLabel.isNotEmpty
        ? _model.locationLabel
        : AppLabels.of(context).get('nearby.unknown_location');

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
              Expanded(
                flex: 1,
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(23.0, 36.0, 23.0, 24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(context, theme),
                        const SizedBox(height: 18),
                        _buildStatusCard(context, theme, visibleLabel),
                        const SizedBox(height: 18),
                        _buildNearbyGrid(context, theme),
                      ],
                    ),
                  ),
                ),
              ),
              wrapWithModel(
                model: _model.nearsyBottomNavModel,
                updateCallback: () => safeSetState(() {}),
                child: NearsyBottomNavWidget(
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
              style: theme.titleLarge.override(
                font: GoogleFonts.interTight(
                  fontWeight: theme.titleLarge.fontWeight,
                  fontStyle: theme.titleLarge.fontStyle,
                ),
                color: theme.primary,
                letterSpacing: 0.0,
                fontWeight: theme.titleLarge.fontWeight,
                fontStyle: theme.titleLarge.fontStyle,
              ),
            ),
          ].divide(const SizedBox(width: 4.0)),
        ),
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
            await context.pushNamed(SearchPreferencesPageWidget.routeName);
            _model.refreshAll();
          },
        ),
      ],
    );
  }

  Widget _buildStatusCard(
      BuildContext context, FloterTheme theme, String visibleLabel) {
    final visibilityText = _model.isVisible
        ? AppLabels.of(context)
            .get('nearby.visible_near')
            .replaceAll('{location}', visibleLabel)
        : AppLabels.of(context).get('nearby.hidden');

    final descriptionText = _model.isVisible
        ? AppLabels.of(context).get('nearby.discoverable_description')
        : AppLabels.of(context).get('nearby.hidden_description');

    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              visibilityText,
              style: theme.titleSmall.override(
                font: GoogleFonts.interTight(
                  fontWeight: theme.titleSmall.fontWeight,
                  fontStyle: theme.titleSmall.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: theme.titleSmall.fontWeight,
                fontStyle: theme.titleSmall.fontStyle,
              ),
            ),
            Text(
              descriptionText,
              maxLines: 3,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(
                  fontWeight: theme.bodyMedium.fontWeight,
                  fontStyle: theme.bodyMedium.fontStyle,
                ),
                color: theme.secondaryText,
                letterSpacing: 0.0,
                fontWeight: theme.bodyMedium.fontWeight,
                fontStyle: theme.bodyMedium.fontStyle,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: FTButtonWidget(
                    onPressed: () async {
                      await context
                          .pushNamed(SearchPreferencesPageWidget.routeName);
                      _model.refreshAll();
                    },
                    text: AppLabels.of(context).get('nearby.filters'),
                    options: FTButtonOptions(
                      width: double.infinity,
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: Colors.transparent,
                      textStyle: TextStyle(color: theme.primary),
                      borderSide: BorderSide(
                        color: theme.primary,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: FTButtonWidget(
                    onPressed: () async {
                      await context.pushNamed(
                          NearbySearchPreferencesPageWidget.routeName);
                      _model.refreshAll();
                    },
                    text: AppLabels.of(context).get('nearby.visibility'),
                    options: FTButtonOptions(
                      width: double.infinity,
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: theme.primary,
                      textStyle: TextStyle(color: theme.primaryBackground),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyGrid(BuildContext context, FloterTheme theme) {
    if (_model.isLoadingProfiles) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_model.loadError.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.error),
            const SizedBox(height: 12),
            Text(
              _model.loadError,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: theme.error,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            FTButtonWidget(
              onPressed: () => _model.refreshAll(),
              text: AppLabels.of(context)
                  .get('nearby.retry'),
              options: FTButtonOptions(
                color: theme.primary,
                textStyle: TextStyle(color: theme.primaryBackground),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ],
        ),
      );
    }

    if (_model.profiles.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48.0),
        child: Center(
          child: Text(
            AppLabels.of(context)
                .get('nearby.no_one_nearby'),
            style: GoogleFonts.interTight(
              color: theme.secondaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 20.0,
        childAspectRatio: 0.62,
      ),
      itemCount: _model.profiles.length,
      itemBuilder: (context, index) {
        return _buildProfileCard(context, theme, _model.profiles[index]);
      },
    );
  }

  Widget _buildProfileCard(
      BuildContext context, FloterTheme theme, DiscoveryProfile profile) {
    final nameAge = () {
      final name = profile.displayName;
      final display = name.trim().isNotEmpty ? name.trim() : '...';
      final age = profile.age;
      return age != null ? '$display, $age' : display;
    }();

    final distanceText = profile.distanceKm != null
        ? '${profile.distanceKm!.toStringAsFixed(1)} km'
        : '';

    final hasPhotos = profile.photos.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: hasPhotos
                ? CachedNetworkImage(
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                    imageUrl: profile.photos.first,
                    width: double.infinity,
                    height: 230.0,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: theme.secondaryBackground),
                    errorWidget: (_, __, ___) => Container(
                      color: theme.secondaryBackground,
                      child: Icon(Icons.person,
                          size: 60, color: theme.alternate),
                    ),
                  )
                : Container(
                    height: 230.0,
                    color: theme.secondaryBackground,
                    child: Icon(Icons.person,
                        size: 60, color: theme.alternate),
                  ),
          ),
          const SizedBox(height: 6.0),
          Text(
            nameAge,
            maxLines: 1,
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(
                fontWeight: theme.bodyMedium.fontWeight,
                fontStyle: theme.bodyMedium.fontStyle,
              ),
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          if (distanceText.isNotEmpty)
            Text(
              distanceText,
              maxLines: 1,
              style: theme.bodySmall.override(
                font: GoogleFonts.inter(
                  fontWeight: theme.bodySmall.fontWeight,
                  fontStyle: theme.bodySmall.fontStyle,
                ),
                color: theme.secondaryText,
              ),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
