import '/backend/supabase/supabase.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import 'dart:ui';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'profile_height_page_model.dart';
export 'profile_height_page_model.dart';

/// Edits the user height with metric preference.
class ProfileHeightPageWidget extends StatefulWidget {
  const ProfileHeightPageWidget({super.key});

  static String routeName = 'ProfileHeightPage';
  static String routePath = '/profile-height';

  @override
  State<ProfileHeightPageWidget> createState() =>
      _ProfileHeightPageWidgetState();
}

class _ProfileHeightPageWidgetState extends State<ProfileHeightPageWidget> {
  late ProfileHeightPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileHeightPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final userId = SupaFlow.client.auth.currentUser?.id;
      if (userId == null || userId.isEmpty) {
        _model.heightCm = null;
        _model.isMetric = true;
        _model.height = '';
        _model.profileHeightFieldTextController?.text = '';
        safeSetState(() {});
        return;
      }

      final profiles = await SupaFlow.client
          .from('profiles')
          .select('height_cm, height, is_metric')
          .eq('user_id', userId)
          .limit(1);
      final profile = profiles.isNotEmpty ? profiles.first : null;

      int? parseHeightCm(dynamic value) {
        if (value == null) {
          return null;
        }
        if (value is int) {
          return value;
        }
        if (value is double) {
          return value.round();
        }
        final text = value.toString().trim();
        if (text.isEmpty) {
          return null;
        }
        return int.tryParse(text.replaceAll(RegExp(r'[^0-9.-]'), ''));
      }

      String formatHeightInput(int? heightCm, bool isMetric) {
        if (heightCm == null || heightCm <= 0) {
          return '';
        }
        if (isMetric) {
          return heightCm.toString();
        }
        final feet = heightCm / 30.48;
        final text = feet.toStringAsFixed(1);
        return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
      }

      final loadedHeightCm =
          parseHeightCm(profile?['height_cm'] ?? profile?['height']);
      _model.heightCm = loadedHeightCm;
      final loadedIsMetric = profile?['is_metric'];
      _model.isMetric = loadedIsMetric is bool ? loadedIsMetric : true;
      final inputValue =
          formatHeightInput(loadedHeightCm, _model.isMetric ?? true);
      _model.height = inputValue;
      _model.profileHeightFieldTextController ??= TextEditingController();
      _model.profileHeightFieldTextController?.text = inputValue;
      safeSetState(() {});
    });

    _model.profileHeightFieldTextController ??= TextEditingController();
    _model.profileHeightFieldFocusNode ??= FocusNode();
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
          child: Container(
            width: double.infinity,
            height: 926.0,
            decoration: BoxDecoration(
              color: FloterTheme.of(context).primaryBackground,
            ),
            child: Container(
              width: double.infinity,
              height: 926.0,
              child: Stack(
                alignment: AlignmentDirectional(0.0, 0.0),
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: AlignmentDirectional(-1.0, -1.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(36.0, 24.0, 0.0, 0.0),
                      child: Container(
                        child: Container(
                          child: FloterIconButton(
                            borderRadius: 8.0,
                            buttonSize: 64.0,
                            fillColor:
                                FloterTheme.of(context).primaryBackground,
                            icon: Icon(
                              Icons.arrow_back,
                              color: FloterTheme.of(context).primaryText,
                              size: 48.0,
                            ),
                            onPressed: () async {
                              final userId =
                                  SupaFlow.client.auth.currentUser?.id;
                              if (userId == null || userId.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('User is not authenticated')),
                                );
                                return;
                              }

                              int? parseHeightCm(String? text, bool isMetric) {
                                final cleanText = (text ?? '').trim();
                                if (cleanText.isEmpty) {
                                  return null;
                                }
                                final parsed = double.tryParse(
                                    cleanText.replaceAll(',', '.'));
                                if (parsed == null || parsed <= 0) {
                                  return null;
                                }
                                final cm = isMetric ? parsed : parsed * 30.48;
                                return cm.round();
                              }

                              final currentIsMetric = _model.isMetric ?? true;
                              final currentHeightCm = parseHeightCm(
                                _model.profileHeightFieldTextController?.text,
                                currentIsMetric,
                              );
                              final updateValue = currentHeightCm;
                              final displayValue = updateValue == null
                                  ? ''
                                  : updateValue.toString();

                              String formatHeightDisplay(
                                  int? heightCm, bool isMetric) {
                                if (heightCm == null || heightCm <= 0) {
                                  return '';
                                }
                                final languageCode = PlatformDispatcher
                                    .instance.locale.languageCode
                                    .toLowerCase();
                                const labelsByLanguage =
                                    <String, Map<String, String>>{
                                  'en': {'cm': 'cm', 'ft': 'ft'},
                                  'ru': {
                                    'cm': '\u0441\u043c',
                                    'ft': '\u0444\u0442'
                                  },
                                };
                                final labels = labelsByLanguage[languageCode] ??
                                    labelsByLanguage['en']!;
                                final unit = labels[isMetric ? 'cm' : 'ft']!;
                                if (!isMetric) {
                                  final feet = heightCm / 30.48;
                                  final text = feet.toStringAsFixed(1);
                                  final feetText = text.endsWith('.0')
                                      ? text.substring(0, text.length - 2)
                                      : text;
                                  return '$feetText $unit';
                                }
                                return '$heightCm $unit';
                              }

                              try {
                                await SupaFlow.client.from('profiles').upsert({
                                  'user_id': userId,
                                  'height_cm': updateValue,
                                  'height': displayValue,
                                  'is_metric': currentIsMetric,
                                }, onConflict: 'user_id');
                              } catch (error) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Failed to save profile: $error')),
                                  );
                                }
                                return;
                              }
                              if (context.mounted) {
                                final navigationValue = updateValue == null
                                    ? '__cleared_profile_attribute__'
                                    : formatHeightDisplay(
                                        updateValue, currentIsMetric);
                                context.goNamed(
                                  'ProfilePage',
                                  queryParameters: {
                                    'heightOverride': serializeParam(
                                      navigationValue,
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: AlignmentDirectional(-1.0, -1.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(99.0, 36.0, 0.0, 0.0),
                      child: Container(
                        child: Container(
                          child: Text(
                            FTLocalizations.of(context).getText(
                              '6vhy5m18' /* My height: */,
                            ),
                            maxLines: 1,
                            style: FloterTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FloterTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FloterTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FloterTheme.of(context)
                                      .titleMedium
                                      .fontWeight,
                                  fontStyle: FloterTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: AlignmentDirectional(-1.0, -1.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(60.0, 84.0, 0.0, 0.0),
                      child: Container(
                        child: Container(
                          child: Text(
                            FTLocalizations.of(context).getText(
                              'zn6hzdig' /* Enter your height */,
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
                                  color:
                                      FloterTheme.of(context).primaryText,
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
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: AlignmentDirectional(-1.0, -1.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(60.0, 111.0, 0.0, 0.0),
                      child: Container(
                        child: Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                FTLocalizations.of(context).getText(
                                  'qo1m3zvr' /* ft */,
                                ),
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
                                      color: FloterTheme.of(context)
                                          .primaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FloterTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FloterTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  int? parseHeightCm(
                                      String? text, bool isMetric) {
                                    final cleanText = (text ?? '').trim();
                                    if (cleanText.isEmpty) {
                                      return null;
                                    }
                                    final parsed = double.tryParse(
                                        cleanText.replaceAll(',', '.'));
                                    if (parsed == null || parsed <= 0) {
                                      return null;
                                    }
                                    final cm =
                                        isMetric ? parsed : parsed * 30.48;
                                    return cm.round();
                                  }

                                  String formatHeightInput(
                                      int? heightCm, bool isMetric) {
                                    if (heightCm == null || heightCm <= 0) {
                                      return '';
                                    }
                                    if (isMetric) {
                                      return heightCm.toString();
                                    }
                                    final feet = heightCm / 30.48;
                                    final text = feet.toStringAsFixed(1);
                                    return text.endsWith('.0')
                                        ? text.substring(0, text.length - 2)
                                        : text;
                                  }

                                  final currentIsMetric =
                                      _model.isMetric ?? true;
                                  final currentHeightCm = parseHeightCm(
                                    _model
                                        .profileHeightFieldTextController?.text,
                                    currentIsMetric,
                                  );
                                  final nextIsMetric = !currentIsMetric;
                                  if (currentHeightCm == null) {
                                    _model.isMetric = nextIsMetric;
                                    safeSetState(() {});
                                    return;
                                  }
                                  _model.heightCm = currentHeightCm;
                                  _model.isMetric = nextIsMetric;
                                  final nextHeightCm =
                                      currentHeightCm ?? _model.heightCm;
                                  final nextInput = formatHeightInput(
                                      nextHeightCm, nextIsMetric);
                                  _model.height = nextInput;
                                  _model.profileHeightFieldTextController
                                      ?.text = nextInput;
                                  safeSetState(() {});
                                },
                                child: Container(
                                  width: 56.0,
                                  height: 56.0,
                                  decoration: BoxDecoration(
                                    color: FloterTheme.of(context)
                                        .primaryBackground,
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Stack(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    children: [
                                      if (_model.isMetric ?? true)
                                        Container(
                                          width: 36.0,
                                          height: 18.0,
                                          decoration: BoxDecoration(
                                            color: FloterTheme.of(context)
                                                .secondary,
                                            borderRadius:
                                                BorderRadius.circular(9.0),
                                            border: Border.all(
                                              color:
                                                  FloterTheme.of(context)
                                                      .primaryText,
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                      if (!_model.isMetric!)
                                        Container(
                                          width: 36.0,
                                          height: 18.0,
                                          decoration: BoxDecoration(
                                            color: FloterTheme.of(context)
                                                .primaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(9.0),
                                            border: Border.all(
                                              color:
                                                  FloterTheme.of(context)
                                                      .primaryText,
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                      if (_model.isMetric ?? true)
                                        Container(
                                          width: 36.0,
                                          height: 18.0,
                                          alignment:
                                              AlignmentDirectional(-1.0, 0.0),
                                          child: Container(
                                            width: 16.0,
                                            height: 16.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FloterTheme.of(context)
                                                      .primaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                color:
                                                    FloterTheme.of(context)
                                                        .primaryText,
                                                width: 1.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      if (!_model.isMetric!)
                                        Container(
                                          width: 36.0,
                                          height: 18.0,
                                          alignment:
                                              AlignmentDirectional(1.0, 0.0),
                                          child: Container(
                                            width: 16.0,
                                            height: 16.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FloterTheme.of(context)
                                                      .primaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                color:
                                                    FloterTheme.of(context)
                                                        .primaryText,
                                                width: 1.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                FTLocalizations.of(context).getText(
                                  'p6i9afuo' /* cm */,
                                ),
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
                                      color: FloterTheme.of(context)
                                          .primaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FloterTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FloterTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ].divide(SizedBox(width: 8.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: AlignmentDirectional(-1.0, -1.0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          134.0, 183.0, 0.0, 0.0),
                      child: Container(
                        child: Container(
                          child: Container(
                            width: 166.0,
                            height: 56.0,
                            decoration: BoxDecoration(
                              color: FloterTheme.of(context)
                                  .primaryBackground,
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                color: FloterTheme.of(context).primaryText,
                                width: 1.0,
                              ),
                            ),
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: TextFormField(
                              controller:
                                  _model.profileHeightFieldTextController,
                              focusNode: _model.profileHeightFieldFocusNode,
                              onChanged: (_) => EasyDebounce.debounce(
                                '_model.profileHeightFieldTextController',
                                Duration(milliseconds: 2000),
                                () async {
                                  _model.height = _model
                                      .profileHeightFieldTextController.text;
                                  safeSetState(() {});
                                },
                              ),
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: true,
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
                              style: TextStyle(
                                color: FloterTheme.of(context).primaryText,
                                fontSize: 30.0,
                              ),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              validator: _model
                                  .profileHeightFieldTextControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                      ),
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
}
