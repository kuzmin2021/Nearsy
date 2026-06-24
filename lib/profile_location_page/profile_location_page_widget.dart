import '/backend/supabase/supabase.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_location_page_model.dart';
export 'profile_location_page_model.dart';

/// Edits the public profile location label.
class ProfileLocationPageWidget extends StatefulWidget {
  const ProfileLocationPageWidget({super.key});

  static String routeName = 'ProfileLocationPage';
  static String routePath = '/profile-location';

  @override
  State<ProfileLocationPageWidget> createState() =>
      _ProfileLocationPageWidgetState();
}

class _ProfileLocationPageWidgetState extends State<ProfileLocationPageWidget> {
  late ProfileLocationPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileLocationPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final userId = SupaFlow.client.auth.currentUser?.id;
      if (userId == null || userId.isEmpty) {
        _model.location = '';
        safeSetState(() {});
        return;
      }

      final profiles = await SupaFlow.client
          .from('profiles')
          .select('location_label')
          .eq('user_id', userId)
          .limit(1);
      final profile = profiles.isNotEmpty ? profiles.first : null;
      String cleanValue(dynamic value) {
        if (value == null) {
          return '';
        }
        if (value is String) {
          return value.trim();
        }
        if (value is List) {
          return value
              .map((item) => cleanValue(item))
              .where((item) => item.isNotEmpty)
              .join(', ');
        }
        return value.toString().trim();
      }

      final value = cleanValue(profile?['location_label']);
    _model.location = value;
      safeSetState(() {});
    });
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
            padding: EdgeInsetsDirectional.fromSTEB(43.0, 29.0, 18.0, 34.0),
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
                        buttonSize: 64.0,
                        fillColor: FloterTheme.of(context).primaryBackground,
                        icon: Icon(
                          Icons.arrow_back,
                          color: FloterTheme.of(context).primaryText,
                          size: 48.0,
                        ),
                        onPressed: () async {
                          if (context.mounted) {
                            context.goNamed('ProfilePage');
                          }
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          AppLabels.of(context).get(
                            'profile_location.my_location' /* My location: */,
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
                    ].divide(SizedBox(width: 8.0)),
                  ),
                  Container(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 42.0,
                                height: 42.0,
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Icon(
                                  Icons.check_box,
                                  color: FloterTheme.of(context).primary,
                                  size: 28.0,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  AppLabels.of(context).get(
                                    'profile_location.automatically_detect_my_location_recommended' /* Automatically detect my locati... */,
                                  ),
                                  maxLines: 2,
                                  style: FloterTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FloterTheme.of(context)
                                              .bodyMedium
                                              .fontWeight,
                                          fontStyle: FloterTheme.of(context)
                                              .bodyMedium
                                              .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FloterTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FloterTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ].divide(SizedBox(width: 8.0)),
                          ),
                          Text(
                            AppLabels.of(context).get(
                              'profile_location.detected_location_guboshlyopsk_zabuldygovo' /* Detected location: Guboshlyops... */,
                            ),
                            maxLines: 2,
                            style: FloterTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FloterTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FloterTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FloterTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FloterTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                          Text(
                            AppLabels.of(context).get(
                              'profile_location.status_in_nearby_local' /* Status in Nearby: Local */,
                            ),
                            style: FloterTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FloterTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FloterTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: FloterTheme.of(context).secondaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FloterTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FloterTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),


                        ].divide(SizedBox(height: 18.0)),
                      ),
                    ),
                  ),
                ].divide(SizedBox(height: 22.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
