import '/backend/supabase/supabase.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import 'dart:ui';
import 'package:easy_debounce/easy_debounce.dart';
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
        _model.profileLocationFieldTextController?.text = '';
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
      _model.profileLocationFieldTextController?.text = value;
      safeSetState(() {});
    });

    _model.profileLocationFieldTextController ??= TextEditingController();
    _model.profileLocationFieldFocusNode ??= FocusNode();
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
                          final userId = SupaFlow.client.auth.currentUser?.id;
                          if (userId == null || userId.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('User is not authenticated')),
                            );
                            return;
                          }

                          String canonicalAttributeValue(dynamic rawValue) {
                            final text = (rawValue?.toString() ?? '')
                                .trim()
                                .toLowerCase();
                            if (text.isEmpty) {
                              return '';
                            }
                            final normalized = text
                                .replaceAll("'", '')
                                .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
                                .replaceAll(RegExp(r'_+'), '_')
                                .replaceAll(RegExp(r'^_|_$'), '');
                            
                            return normalized;
                          }

                          final value =
                              (_model.profileLocationFieldTextController.text)
                                  .trim();
                          final updateValue = value;

                          try {
                            await SupaFlow.client.from('profiles').upsert({
                              'user_id': userId,
                              'location_label': updateValue,
                            }, onConflict: 'user_id', defaultToNull: false);
                          } catch (error) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Failed to save profile: $error')),
                              );
                            }
                            return;
                          }
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
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 42.0,
                                height: 42.0,
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Icon(
                                  Icons.check_box_outline_blank,
                                  color: FloterTheme.of(context).secondaryText,
                                  size: 28.0,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  AppLabels.of(context).get(
                                    'profile_location.i_will_set_my_location_manually' /* I will set my location manuall... */,
                                  ),
                                  maxLines: 1,
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
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ].divide(SizedBox(width: 8.0)),
                          ),
                          Container(
                            height: 48.0,
                            decoration: BoxDecoration(
                              color:
                                  FloterTheme.of(context).secondaryBackground,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 8.0, 12.0, 8.0),
                              child: TextFormField(
                                controller:
                                    _model.profileLocationFieldTextController,
                                focusNode: _model.profileLocationFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.profileLocationFieldTextController',
                                  Duration(milliseconds: 2000),
                                  () async {
                                    _model.location = _model
                                        .profileLocationFieldTextController
                                        .text;
                                    safeSetState(() {});
                                  },
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: AppLabels.of(context).get(
                                    'profile_location.select_location' /* Select location... */,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                  filled: true,
                                ),
                                style: TextStyle(),
                                maxLines: null,
                                validator: _model
                                    .profileLocationFieldTextControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                          ),
                          Text(
                            AppLabels.of(context).get(
                              'profile_location.label_1' /* In the Nearby section, others ... */,
                            ),
                            maxLines: 5,
                            style: FloterTheme.of(context).bodySmall.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FloterTheme.of(context)
                                        .bodySmall
                                        .fontWeight,
                                    fontStyle: FloterTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                                  color: FloterTheme.of(context).secondaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FloterTheme.of(context)
                                      .bodySmall
                                      .fontWeight,
                                  fontStyle: FloterTheme.of(context)
                                      .bodySmall
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
