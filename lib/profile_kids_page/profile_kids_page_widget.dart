import '/backend/supabase/supabase.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import 'dart:ui';
import '/floter/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'profile_kids_page_model.dart';
export 'profile_kids_page_model.dart';

/// Edits the user kids attribute.
class ProfileKidsPageWidget extends StatefulWidget {
  const ProfileKidsPageWidget({super.key});

  static String routeName = 'ProfileKidsPage';
  static String routePath = '/profile-kids';

  @override
  State<ProfileKidsPageWidget> createState() => _ProfileKidsPageWidgetState();
}

class _ProfileKidsPageWidgetState extends State<ProfileKidsPageWidget> {
  late ProfileKidsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileKidsPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final userId = SupaFlow.client.auth.currentUser?.id;
      if (userId == null || userId.isEmpty) {
        _model.kids = '';
        safeSetState(() {});
        return;
      }

      final profiles = await SupaFlow.client
          .from('profiles')
          .select('kids')
          .eq('user_id', userId)
          .limit(1);
      final profile = profiles.isNotEmpty ? profiles.first : null;
      const options = <String>['i_have_kids', 'i_dont_have_kids'];
      String normalizeChoice(dynamic rawValue) {
        final rawText = (rawValue?.toString() ?? '').trim();
        if (rawText.isEmpty) {
          return '';
        }
        final normalizedRaw = rawText
            .toLowerCase()
            .replaceAll("'", '')
            .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
            .replaceAll(RegExp(r'_+'), '_')
            .replaceAll(RegExp(r'^_|_$'), '');
        const aliases = {
          'female': 'woman',
          'male': 'man',
          'nonbinary': 'non_binary',
          'bachelor_degree': 'bachelors_degree',
          'master_degree': 'masters_degree',
        };
        final normalized = aliases[normalizedRaw] ?? normalizedRaw;
        for (final option in options) {
          if (option.toLowerCase() == normalized) {
            return option;
          }
        }
        if (normalized == 'true') {
          for (final option in options) {
            if (option.toLowerCase() == 'i_have_kids') {
              return option;
            }
          }
        }
        if (normalized == 'false') {
          for (final option in options) {
            if (option.toLowerCase() == 'i_dont_have_kids') {
              return option;
            }
          }
        }
        return rawText;
      }

      final rawValue = profile?['kids'];
      if (rawValue is bool) {
        _model.kids = rawValue ? 'i_have_kids' : 'i_dont_have_kids';
      } else {
        final rawText = (rawValue as String?)?.trim() ?? '';
        _model.kids = normalizeChoice(rawText);
      }

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
                        fillColor:
                            FloterTheme.of(context).primaryBackground,
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
                            const aliases = {
                              'female': 'woman',
                              'male': 'man',
                              'nonbinary': 'non_binary',
                              'bachelor_degree': 'bachelors_degree',
                              'master_degree': 'masters_degree',
                            };
                            return aliases[normalized] ?? normalized;
                          }

                          final value =
                              canonicalAttributeValue(_model.kids ?? '');
                          final updateValue = value == 'i_have_kids';

                          try {
                            await SupaFlow.client.from('profiles').upsert({
                              'user_id': userId,
                              'kids': updateValue,
                            }, onConflict: 'user_id');
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
                            final navigationValue = value.isEmpty
                                ? '__cleared_profile_attribute__'
                                : value;
                            context.goNamed(
                              'ProfilePage',
                              queryParameters: {
                                'kidsOverride': serializeParam(
                                  navigationValue,
                                  ParamType.String,
                                ),
                              }.withoutNulls,
                            );
                          }
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          AppLabels.of(context).get(
                            'profile_kids.kids' /* Kids: */,
                          ),
                          maxLines: 2,
                          style:
                              FloterTheme.of(context).titleLarge.override(
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
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  _model.kids = 'i_have_kids';
                                  safeSetState(() {});
                                },
                                child: Container(
                                  height: 48.0,
                                  decoration: BoxDecoration(
                                    color: FloterTheme.of(context)
                                        .primaryBackground,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 42.0,
                                        height: 42.0,
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Stack(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          children: [
                                            if (_model.kids == 'i_have_kids')
                                              Container(
                                                child: Icon(
                                                  Icons.radio_button_checked,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 28.0,
                                                ),
                                              ),
                                            if (!(_model.kids == 'i_have_kids'))
                                              Container(
                                                child: Icon(
                                                  Icons.radio_button_unchecked,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  size: 28.0,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          functions.effectiveProfileAttribute(
                                              'kids', '', 'i_have_kids')!,
                                          maxLines: 1,
                                          style: FloterTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FloterTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FloterTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FloterTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FloterTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 8.0)),
                                  ),
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  _model.kids = 'i_dont_have_kids';
                                  safeSetState(() {});
                                },
                                child: Container(
                                  height: 48.0,
                                  decoration: BoxDecoration(
                                    color: FloterTheme.of(context)
                                        .primaryBackground,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 42.0,
                                        height: 42.0,
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Stack(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          children: [
                                            if (_model.kids ==
                                                'i_dont_have_kids')
                                              Container(
                                                child: Icon(
                                                  Icons.radio_button_checked,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 28.0,
                                                ),
                                              ),
                                            if (!(_model.kids ==
                                                'i_dont_have_kids'))
                                              Container(
                                                child: Icon(
                                                  Icons.radio_button_unchecked,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  size: 28.0,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          functions.effectiveProfileAttribute(
                                              'kids', '', 'i_dont_have_kids')!,
                                          maxLines: 1,
                                          style: FloterTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FloterTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FloterTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FloterTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FloterTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 8.0)),
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(height: 0.0)),
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
