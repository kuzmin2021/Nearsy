import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'nearby_search_preferences_page_model.dart';
export 'nearby_search_preferences_page_model.dart';

/// Figma visibility mode preferences for nearby discovery.
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
    _model = createModel(context, () => NearbySearchPreferencesPageModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FloterTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24.0, 44.0, 24.0, 28.0),
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
                        fillColor: FloterTheme.of(context).primaryBackground,
                        icon: Icon(
                          Icons.arrow_back,
                          color: FloterTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          context.pop();
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          AppLabels.of(context).get(
                            'nearby_search_preferences.title' /* Nearby Search Preferences */,
                          ),
                          maxLines: 2,
                          style: FloterTheme.of(context).titleLarge.override(
                                font: GoogleFonts.interTight(
                                  fontWeight: FloterTheme.of(context)
                                      .titleLarge
                                      .fontWeight,
                                  fontStyle: FloterTheme.of(context)
                                      .titleLarge
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FloterTheme.of(context)
                                    .titleLarge
                                    .fontWeight,
                                fontStyle: FloterTheme.of(context)
                                    .titleLarge
                                    .fontStyle,
                              ),
                        ),
                      ),
                    ].divide(SizedBox(width: 12.0)),
                  ),
                  Text(
                    AppLabels.of(context).get(
                      'nearby_search_preferences.choose_how_visible_your_location_is_you_can_change_this_anytime' /* Choose how visible your locati... */,
                    ),
                    style: FloterTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight:
                                FloterTheme.of(context).bodyMedium.fontWeight,
                            fontStyle:
                                FloterTheme.of(context).bodyMedium.fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight:
                              FloterTheme.of(context).bodyMedium.fontWeight,
                          fontStyle:
                              FloterTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  Text(
                    AppLabels.of(context).get(
                      'nearby_search_preferences.visibility_modes' /* Visibility modes: */,
                    ),
                    style: FloterTheme.of(context).titleSmall.override(
                          font: GoogleFonts.interTight(
                            fontWeight:
                                FloterTheme.of(context).titleSmall.fontWeight,
                            fontStyle:
                                FloterTheme.of(context).titleSmall.fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight:
                              FloterTheme.of(context).titleSmall.fontWeight,
                          fontStyle:
                              FloterTheme.of(context).titleSmall.fontStyle,
                        ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
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
                                  color: FloterTheme.of(context).primary,
                                  width: 4.0,
                                ),
                              ),
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Icon(
                                Icons.location_off,
                                color: FloterTheme.of(context).secondary,
                                size: 24.0,
                              ),
                            ),
                            Text(
                              AppLabels.of(context).get(
                                'nearby_search_preferences.invisible' /* Invisible */,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              style: FloterTheme.of(context).bodySmall.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FloterTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FloterTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FloterTheme.of(context)
                                        .bodySmall
                                        .fontWeight,
                                    fontStyle: FloterTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ].divide(SizedBox(height: 6.0)),
                        ),
                      ),
                      Expanded(
                        flex: 1,
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
                                  color: FloterTheme.of(context).alternate,
                                  width: 4.0,
                                ),
                              ),
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Icon(
                                Icons.near_me,
                                color: FloterTheme.of(context).secondaryText,
                                size: 24.0,
                              ),
                            ),
                            Text(
                              AppLabels.of(context).get(
                                'nearby_search_preferences.visible_while_using_the_app' /* Visible while using the app */,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              style: FloterTheme.of(context).bodySmall.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FloterTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FloterTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FloterTheme.of(context)
                                        .bodySmall
                                        .fontWeight,
                                    fontStyle: FloterTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ].divide(SizedBox(height: 6.0)),
                        ),
                      ),
                      Expanded(
                        flex: 1,
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
                                  color: FloterTheme.of(context).alternate,
                                  width: 4.0,
                                ),
                              ),
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Icon(
                                Icons.my_location,
                                color: FloterTheme.of(context).secondaryText,
                                size: 24.0,
                              ),
                            ),
                            Text(
                              AppLabels.of(context).get(
                                'nearby_search_preferences.your_last_location' /* Your last location */,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              style: FloterTheme.of(context).bodySmall.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FloterTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FloterTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FloterTheme.of(context)
                                        .bodySmall
                                        .fontWeight,
                                    fontStyle: FloterTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ].divide(SizedBox(height: 6.0)),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    AppLabels.of(context).get(
                      'nearby_search_preferences.you_appear_as_local_guboshlyopsk_zabuldogovo' /* You appear as: Local Guboshlyo... */,
                    ),
                    style: TextStyle(),
                  ),
                  Text(
                    AppLabels.of(context).get(
                      'nearby_search_preferences.to_update_your_status_go_to_profile_settings_location' /* To update your status, go to P... */,
                    ),
                    style: FloterTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight:
                                FloterTheme.of(context).bodyMedium.fontWeight,
                            fontStyle:
                                FloterTheme.of(context).bodyMedium.fontStyle,
                          ),
                          color: FloterTheme.of(context).primary,
                          letterSpacing: 0.0,
                          fontWeight:
                              FloterTheme.of(context).bodyMedium.fontWeight,
                          fontStyle:
                              FloterTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  FTButtonWidget(
                    onPressed: () async {
                      context.pop();
                    },
                    text: AppLabels.of(context).get(
                      'nearby_search_preferences.save_visibility' /* Save visibility */,
                    ),
                    options: FTButtonOptions(
                      width: double.infinity,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FloterTheme.of(context).primary,
                      textStyle: TextStyle(
                        color: FloterTheme.of(context).primaryBackground,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ].divide(SizedBox(height: 16.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
