import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'nearby_search_preferences_page_model.dart';
export 'nearby_search_preferences_page_model.dart';

class NearbySearchPreferencesPageWidget extends StatefulWidget {
  const NearbySearchPreferencesPageWidget({super.key});

  static String routeName = 'NearbySearchPreferencesPage';
  static String routePath = '/nearby-search-preferences';

  @override
  State<NearbySearchPreferencesPageWidget> createState() =>
      _NearbySearchPreferencesPageWidgetState();
}

class _NearbySearchPreferencesPageWidgetState
    extends State<NearbySearchPreferencesPageWidget> {
  late NearbySearchPreferencesPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model =
        createModel(context, () => NearbySearchPreferencesPageModel());
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
    final labels = AppLabels.of(context);

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
          child: Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(24.0, 44.0, 24.0, 28.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FloterIconButton(
                        borderRadius: 8.0,
                        buttonSize: 40.0,
                        fillColor: theme.primaryBackground,
                        icon: Icon(
                          Icons.close,
                          color: theme.primaryText,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          context.pop();
                        },
                      ),
                      const SizedBox(width: 12.0),
                      Text(
                        labels.get('nearby_search_preferences.title'),
                        style: theme.titleLarge.override(
                          font: GoogleFonts.interTight(
                            fontWeight: theme.titleLarge.fontWeight,
                            fontStyle: theme.titleLarge.fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: theme.titleLarge.fontWeight,
                          fontStyle: theme.titleLarge.fontStyle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    labels.get(
                      'nearby_search_preferences.choose_how_visible_your_location_is_you_can_change_this_anytime',
                    ),
                    style: theme.bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: theme.bodyMedium.fontWeight,
                        fontStyle: theme.bodyMedium.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: theme.bodyMedium.fontWeight,
                      fontStyle: theme.bodyMedium.fontStyle,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    labels.get(
                      'nearby_search_preferences.visibility_modes',
                    ),
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
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildModeOption(
                        context,
                        icon: Icons.location_off,
                        label: labels.get(
                            'nearby_search_preferences.invisible'),
                        isSelected: _model.selectedMode ==
                            NearbySearchPreferencesPageModel.invisibleValue,
                        onTap: () {
                          setState(() {
                            _model.selectedMode =
                                NearbySearchPreferencesPageModel
                                    .invisibleValue;
                          });
                        },
                      ),
                      _buildModeOption(
                        context,
                        icon: Icons.near_me,
                        label: labels.get(
                          'nearby_search_preferences.visible_while_using_the_app',
                        ),
                        isSelected: _model.selectedMode ==
                            NearbySearchPreferencesPageModel.visibleValue,
                        onTap: () {
                          setState(() {
                            _model.selectedMode =
                                NearbySearchPreferencesPageModel.visibleValue;
                          });
                        },
                      ),
                      _buildModeOption(
                        context,
                        icon: Icons.my_location,
                        label: labels.get(
                          'nearby_search_preferences.your_last_location',
                        ),
                        isSelected: _model.selectedMode ==
                            NearbySearchPreferencesPageModel.visibleValue,
                        onTap: () {
                          setState(() {
                            _model.selectedMode =
                                NearbySearchPreferencesPageModel.visibleValue;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    () {
                      final loc = _model.locationLabel;
                      if (loc.isNotEmpty) {
                        return labels.get(
                      'nearby_search_preferences.you_appear_as_local',
                    ).replaceAll('{location}', _model.locationLabel);
                      }
                      return labels.get(
                        'nearby_search_preferences.you_appear_as_local_guboshlyopsk_zabuldogovo',
                      );
                    }(),
                    style: const TextStyle(),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    labels.get(
                      'nearby_search_preferences.to_update_your_status_go_to_profile_settings_location',
                    ),
                    style: theme.bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: theme.bodyMedium.fontWeight,
                        fontStyle: theme.bodyMedium.fontStyle,
                      ),
                      color: theme.primary,
                      letterSpacing: 0.0,
                      fontWeight: theme.bodyMedium.fontWeight,
                      fontStyle: theme.bodyMedium.fontStyle,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  FTButtonWidget(
                    onPressed: () async {
                      await _model.saveVisibilityMode();
                      context.pop();
                    },
                    text: labels.get(
                      'nearby_search_preferences.save_visibility',
                    ),
                    options: FTButtonOptions(
                      width: double.infinity,
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 0.0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 0.0),
                      color: theme.primary,
                      textStyle: TextStyle(color: theme.primaryBackground),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = FloterTheme.of(context);
    final borderColor = isSelected ? theme.primary : theme.alternate;
    final iconColor = isSelected ? theme.primary : theme.secondaryText;

    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 54.0,
              height: 54.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27.0),
                border: Border.all(
                  color: borderColor,
                  width: 4.0,
                ),
              ),
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: Icon(
                icon,
                color: iconColor,
                size: 24.0,
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 3,
              style: theme.bodySmall.override(
                font: GoogleFonts.inter(
                  fontWeight: theme.bodySmall.fontWeight,
                  fontStyle: theme.bodySmall.fontStyle,
                ),
                letterSpacing: 0.0,
                fontWeight: theme.bodySmall.fontWeight,
                fontStyle: theme.bodySmall.fontStyle,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
