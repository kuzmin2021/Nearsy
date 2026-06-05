import '/backend/supabase/supabase.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_languages_page_model.dart';
export 'profile_languages_page_model.dart';

/// Edits languages the user knows.
class ProfileLanguagesPageWidget extends StatefulWidget {
  const ProfileLanguagesPageWidget({super.key});

  static String routeName = 'ProfileLanguagesPage';
  static String routePath = '/profile-languages';

  @override
  State<ProfileLanguagesPageWidget> createState() =>
      _ProfileLanguagesPageWidgetState();
}

class _ProfileLanguagesPageWidgetState
    extends State<ProfileLanguagesPageWidget> {
  late ProfileLanguagesPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileLanguagesPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final userId = SupaFlow.client.auth.currentUser?.id;
      if (userId == null || userId.isEmpty) {
        _model.languages = [];
        safeSetState(() {});
        return;
      }

      final profiles = await SupaFlow.client
          .from('profiles')
          .select('languages')
          .eq('user_id', userId)
          .limit(1);
      final profile = profiles.isNotEmpty ? profiles.first : null;
      String cleanValue(dynamic value) {
        return (value?.toString() ?? '').trim();
      }

      List<String> cleanStringList(dynamic value) {
        if (value == null) {
          return <String>[];
        }
        final rawItems = value is List ? value : [value];
        final output = <String>[];
        for (final item in rawItems) {
          final normalized = cleanValue(item)
              .replaceAll(RegExp(r'^[\[\{]+|[\]\}]+$'), '')
              .replaceAll('"', '')
              .replaceAll("'", '');
          output.addAll(
            normalized
                .split(RegExp(r'[,;]'))
                .map((part) => cleanValue(part))
                .where((part) => part.isNotEmpty),
          );
        }
        String canonicalLanguage(dynamic rawValue) {
          final text = cleanValue(rawValue).toLowerCase();
          if (text.isEmpty) {
            return '';
          }
          final normalized = text
              .replaceAll("'", '')
              .replaceAll(RegExp(r'[^a-z0-9\u0400-\u04FF]+'), '_')
              .replaceAll(RegExp(r'_+'), '_')
              .replaceAll(RegExp(r'^_|_$'), '');
          const aliases = {
            'mandarin': 'chinese',
            'zh': 'chinese',
            'cn': 'chinese',
            'ua': 'ukrainian',
            'deutsch': 'german',
            'espanol': 'spanish',
            'espa\u00f1ol': 'spanish',
            '\u0430\u043d\u0433\u043b\u0438\u0439\u0441\u043a\u0438\u0439':
                'english',
            '\u0440\u0443\u0441\u0441\u043a\u0438\u0439': 'russian',
            '\u0438\u0441\u043f\u0430\u043d\u0441\u043a\u0438\u0439': 'spanish',
            '\u0444\u0440\u0430\u043d\u0446\u0443\u0437\u0441\u043a\u0438\u0439':
                'french',
            '\u043d\u0435\u043c\u0435\u0446\u043a\u0438\u0439': 'german',
            '\u0438\u0442\u0430\u043b\u044c\u044f\u043d\u0441\u043a\u0438\u0439':
                'italian',
            '\u043f\u043e\u0440\u0442\u0443\u0433\u0430\u043b\u044c\u0441\u043a\u0438\u0439':
                'portuguese',
            '\u043a\u0438\u0442\u0430\u0439\u0441\u043a\u0438\u0439': 'chinese',
            '\u044f\u043f\u043e\u043d\u0441\u043a\u0438\u0439': 'japanese',
            '\u043a\u043e\u0440\u0435\u0439\u0441\u043a\u0438\u0439': 'korean',
            '\u0430\u0440\u0430\u0431\u0441\u043a\u0438\u0439': 'arabic',
            '\u0442\u0443\u0440\u0435\u0446\u043a\u0438\u0439': 'turkish',
            '\u0443\u043a\u0440\u0430\u0438\u043d\u0441\u043a\u0438\u0439':
                'ukrainian',
            '\u043f\u043e\u043b\u044c\u0441\u043a\u0438\u0439': 'polish',
            '\u043d\u0438\u0434\u0435\u0440\u043b\u0430\u043d\u0434\u0441\u043a\u0438\u0439':
                'dutch',
            '\u0445\u0438\u043d\u0434\u0438': 'hindi',
            '\u0438\u0432\u0440\u0438\u0442': 'hebrew',
            '\u0448\u0432\u0435\u0434\u0441\u043a\u0438\u0439': 'swedish',
            '\u043d\u043e\u0440\u0432\u0435\u0436\u0441\u043a\u0438\u0439':
                'norwegian',
            '\u0444\u0438\u043d\u0441\u043a\u0438\u0439': 'finnish',
          };
          return aliases[normalized] ?? normalized;
        }

        return output
            .map(canonicalLanguage)
            .where((item) => item.isNotEmpty)
            .toSet()
            .toList();
      }

      _model.languages = cleanStringList(profile?['languages']);
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

                          String canonicalLanguage(dynamic rawValue) {
                            final text = (rawValue?.toString() ?? '')
                                .trim()
                                .toLowerCase();
                            if (text.isEmpty) {
                              return '';
                            }
                            final normalized = text
                                .replaceAll("'", '')
                                .replaceAll(
                                    RegExp(r'[^a-z0-9\u0400-\u04FF]+'), '_')
                                .replaceAll(RegExp(r'_+'), '_')
                                .replaceAll(RegExp(r'^_|_$'), '');
                            const aliases = {
                              'mandarin': 'chinese',
                              'zh': 'chinese',
                              'cn': 'chinese',
                              'ua': 'ukrainian',
                              'deutsch': 'german',
                              'espanol': 'spanish',
                              'espa\u00f1ol': 'spanish',
                              '\u0430\u043d\u0433\u043b\u0438\u0439\u0441\u043a\u0438\u0439':
                                  'english',
                              '\u0440\u0443\u0441\u0441\u043a\u0438\u0439':
                                  'russian',
                              '\u0438\u0441\u043f\u0430\u043d\u0441\u043a\u0438\u0439':
                                  'spanish',
                              '\u0444\u0440\u0430\u043d\u0446\u0443\u0437\u0441\u043a\u0438\u0439':
                                  'french',
                              '\u043d\u0435\u043c\u0435\u0446\u043a\u0438\u0439':
                                  'german',
                              '\u0438\u0442\u0430\u043b\u044c\u044f\u043d\u0441\u043a\u0438\u0439':
                                  'italian',
                              '\u043f\u043e\u0440\u0442\u0443\u0433\u0430\u043b\u044c\u0441\u043a\u0438\u0439':
                                  'portuguese',
                              '\u043a\u0438\u0442\u0430\u0439\u0441\u043a\u0438\u0439':
                                  'chinese',
                              '\u044f\u043f\u043e\u043d\u0441\u043a\u0438\u0439':
                                  'japanese',
                              '\u043a\u043e\u0440\u0435\u0439\u0441\u043a\u0438\u0439':
                                  'korean',
                              '\u0430\u0440\u0430\u0431\u0441\u043a\u0438\u0439':
                                  'arabic',
                              '\u0442\u0443\u0440\u0435\u0446\u043a\u0438\u0439':
                                  'turkish',
                              '\u0443\u043a\u0440\u0430\u0438\u043d\u0441\u043a\u0438\u0439':
                                  'ukrainian',
                              '\u043f\u043e\u043b\u044c\u0441\u043a\u0438\u0439':
                                  'polish',
                              '\u043d\u0438\u0434\u0435\u0440\u043b\u0430\u043d\u0434\u0441\u043a\u0438\u0439':
                                  'dutch',
                              '\u0445\u0438\u043d\u0434\u0438': 'hindi',
                              '\u0438\u0432\u0440\u0438\u0442': 'hebrew',
                              '\u0448\u0432\u0435\u0434\u0441\u043a\u0438\u0439':
                                  'swedish',
                              '\u043d\u043e\u0440\u0432\u0435\u0436\u0441\u043a\u0438\u0439':
                                  'norwegian',
                              '\u0444\u0438\u043d\u0441\u043a\u0438\u0439':
                                  'finnish',
                            };
                            return aliases[normalized] ?? normalized;
                          }

                          final rawValue = _model.languages;
                          final rawItems =
                              rawValue is List ? rawValue : [rawValue];
                          final updateItems = <String>[];
                          for (final item in rawItems) {
                            final normalized = item
                                .toString()
                                .trim()
                                .replaceAll(RegExp(r'^[\[\{]+|[\]\}]+$'), '')
                                .replaceAll('"', '')
                                .replaceAll("'", '');
                            updateItems.addAll(
                              normalized
                                  .split(RegExp(r'[,;]'))
                                  .map((part) => canonicalLanguage(part))
                                  .where((part) => part.isNotEmpty),
                            );
                          }
                          final updateValue = updateItems.toSet().toList();
                          final value = updateValue.join(', ');

                          try {
                            await SupaFlow.client.from('profiles').upsert({
                              'user_id': userId,
                              'languages': updateValue,
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
                                'languagesOverride': serializeParam(
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
                          functions.profileLanguagesUiText('title')!,
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
                          Text(
                            functions.profileLanguagesUiText('helper')!,
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
                                  if (functions.profileLanguageSelected(
                                      _model.languages.toList(), 'english')!) {
                                    _model.removeFromLanguages('english');
                                    safeSetState(() {});
                                  } else {
                                    _model.addToLanguages('english');
                                    safeSetState(() {});
                                  }
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
                                            if (functions
                                                    .profileLanguageSelected(
                                                        _model.languages
                                                            .toList(),
                                                        'english') ??
                                                true)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 28.0,
                                                ),
                                              ),
                                            if (!functions
                                                .profileLanguageSelected(
                                                    _model.languages.toList(),
                                                    'english')!)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box_outline_blank,
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
                                          functions
                                              .profileLanguageLabel('english')!,
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
                                  if (functions.profileLanguageSelected(
                                      _model.languages.toList(), 'russian')!) {
                                    _model.removeFromLanguages('russian');
                                    safeSetState(() {});
                                  } else {
                                    _model.addToLanguages('russian');
                                    safeSetState(() {});
                                  }
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
                                            if (functions
                                                    .profileLanguageSelected(
                                                        _model.languages
                                                            .toList(),
                                                        'russian') ??
                                                true)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 28.0,
                                                ),
                                              ),
                                            if (!functions
                                                .profileLanguageSelected(
                                                    _model.languages.toList(),
                                                    'russian')!)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box_outline_blank,
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
                                          functions
                                              .profileLanguageLabel('russian')!,
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
                                  if (functions.profileLanguageSelected(
                                      _model.languages.toList(), 'spanish')!) {
                                    _model.removeFromLanguages('spanish');
                                    safeSetState(() {});
                                  } else {
                                    _model.addToLanguages('spanish');
                                    safeSetState(() {});
                                  }
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
                                            if (functions
                                                    .profileLanguageSelected(
                                                        _model.languages
                                                            .toList(),
                                                        'spanish') ??
                                                true)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 28.0,
                                                ),
                                              ),
                                            if (!functions
                                                .profileLanguageSelected(
                                                    _model.languages.toList(),
                                                    'spanish')!)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box_outline_blank,
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
                                          functions
                                              .profileLanguageLabel('spanish')!,
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
                                  if (functions.profileLanguageSelected(
                                      _model.languages.toList(), 'french')!) {
                                    _model.removeFromLanguages('french');
                                    safeSetState(() {});
                                  } else {
                                    _model.addToLanguages('french');
                                    safeSetState(() {});
                                  }
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
                                            if (functions
                                                    .profileLanguageSelected(
                                                        _model.languages
                                                            .toList(),
                                                        'french') ??
                                                true)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 28.0,
                                                ),
                                              ),
                                            if (!functions
                                                .profileLanguageSelected(
                                                    _model.languages.toList(),
                                                    'french')!)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box_outline_blank,
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
                                          functions
                                              .profileLanguageLabel('french')!,
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
                                  if (functions.profileLanguageSelected(
                                      _model.languages.toList(), 'german')!) {
                                    _model.removeFromLanguages('german');
                                    safeSetState(() {});
                                  } else {
                                    _model.addToLanguages('german');
                                    safeSetState(() {});
                                  }
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
                                            if (functions
                                                    .profileLanguageSelected(
                                                        _model.languages
                                                            .toList(),
                                                        'german') ??
                                                true)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 28.0,
                                                ),
                                              ),
                                            if (!functions
                                                .profileLanguageSelected(
                                                    _model.languages.toList(),
                                                    'german')!)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box_outline_blank,
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
                                          functions
                                              .profileLanguageLabel('german')!,
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
                                  if (functions.profileLanguageSelected(
                                      _model.languages.toList(), 'italian')!) {
                                    _model.removeFromLanguages('italian');
                                    safeSetState(() {});
                                  } else {
                                    _model.addToLanguages('italian');
                                    safeSetState(() {});
                                  }
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
                                            if (functions
                                                    .profileLanguageSelected(
                                                        _model.languages
                                                            .toList(),
                                                        'italian') ??
                                                true)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 28.0,
                                                ),
                                              ),
                                            if (!functions
                                                .profileLanguageSelected(
                                                    _model.languages.toList(),
                                                    'italian')!)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box_outline_blank,
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
                                          functions
                                              .profileLanguageLabel('italian')!,
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
                                  if (functions.profileLanguageSelected(
                                      _model.languages.toList(),
                                      'portuguese')!) {
                                    _model.removeFromLanguages('portuguese');
                                    safeSetState(() {});
                                  } else {
                                    _model.addToLanguages('portuguese');
                                    safeSetState(() {});
                                  }
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
                                            if (functions
                                                    .profileLanguageSelected(
                                                        _model.languages
                                                            .toList(),
                                                        'portuguese') ??
                                                true)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 28.0,
                                                ),
                                              ),
                                            if (!functions
                                                .profileLanguageSelected(
                                                    _model.languages.toList(),
                                                    'portuguese')!)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box_outline_blank,
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
                                          functions.profileLanguageLabel(
                                              'portuguese')!,
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
                                  if (functions.profileLanguageSelected(
                                      _model.languages.toList(), 'chinese')!) {
                                    _model.removeFromLanguages('chinese');
                                    safeSetState(() {});
                                  } else {
                                    _model.addToLanguages('chinese');
                                    safeSetState(() {});
                                  }
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
                                            if (functions
                                                    .profileLanguageSelected(
                                                        _model.languages
                                                            .toList(),
                                                        'chinese') ??
                                                true)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 28.0,
                                                ),
                                              ),
                                            if (!functions
                                                .profileLanguageSelected(
                                                    _model.languages.toList(),
                                                    'chinese')!)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box_outline_blank,
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
                                          functions
                                              .profileLanguageLabel('chinese')!,
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
                                  if (functions.profileLanguageSelected(
                                      _model.languages.toList(), 'japanese')!) {
                                    _model.removeFromLanguages('japanese');
                                    safeSetState(() {});
                                  } else {
                                    _model.addToLanguages('japanese');
                                    safeSetState(() {});
                                  }
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
                                            if (functions
                                                    .profileLanguageSelected(
                                                        _model.languages
                                                            .toList(),
                                                        'japanese') ??
                                                true)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 28.0,
                                                ),
                                              ),
                                            if (!functions
                                                .profileLanguageSelected(
                                                    _model.languages.toList(),
                                                    'japanese')!)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box_outline_blank,
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
                                          functions.profileLanguageLabel(
                                              'japanese')!,
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
                                  if (functions.profileLanguageSelected(
                                      _model.languages.toList(), 'korean')!) {
                                    _model.removeFromLanguages('korean');
                                    safeSetState(() {});
                                  } else {
                                    _model.addToLanguages('korean');
                                    safeSetState(() {});
                                  }
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
                                            if (functions
                                                    .profileLanguageSelected(
                                                        _model.languages
                                                            .toList(),
                                                        'korean') ??
                                                true)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 28.0,
                                                ),
                                              ),
                                            if (!functions
                                                .profileLanguageSelected(
                                                    _model.languages.toList(),
                                                    'korean')!)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box_outline_blank,
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
                                          functions
                                              .profileLanguageLabel('korean')!,
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
                                  if (functions.profileLanguageSelected(
                                      _model.languages.toList(), 'arabic')!) {
                                    _model.removeFromLanguages('arabic');
                                    safeSetState(() {});
                                  } else {
                                    _model.addToLanguages('arabic');
                                    safeSetState(() {});
                                  }
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
                                            if (functions
                                                    .profileLanguageSelected(
                                                        _model.languages
                                                            .toList(),
                                                        'arabic') ??
                                                true)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 28.0,
                                                ),
                                              ),
                                            if (!functions
                                                .profileLanguageSelected(
                                                    _model.languages.toList(),
                                                    'arabic')!)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box_outline_blank,
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
                                          functions
                                              .profileLanguageLabel('arabic')!,
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
                                  if (functions.profileLanguageSelected(
                                      _model.languages.toList(), 'turkish')!) {
                                    _model.removeFromLanguages('turkish');
                                    safeSetState(() {});
                                  } else {
                                    _model.addToLanguages('turkish');
                                    safeSetState(() {});
                                  }
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
                                            if (functions
                                                    .profileLanguageSelected(
                                                        _model.languages
                                                            .toList(),
                                                        'turkish') ??
                                                true)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 28.0,
                                                ),
                                              ),
                                            if (!functions
                                                .profileLanguageSelected(
                                                    _model.languages.toList(),
                                                    'turkish')!)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box_outline_blank,
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
                                          functions
                                              .profileLanguageLabel('turkish')!,
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
                                  if (functions.profileLanguageSelected(
                                      _model.languages.toList(),
                                      'ukrainian')!) {
                                    _model.removeFromLanguages('ukrainian');
                                    safeSetState(() {});
                                  } else {
                                    _model.addToLanguages('ukrainian');
                                    safeSetState(() {});
                                  }
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
                                            if (functions
                                                    .profileLanguageSelected(
                                                        _model.languages
                                                            .toList(),
                                                        'ukrainian') ??
                                                true)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 28.0,
                                                ),
                                              ),
                                            if (!functions
                                                .profileLanguageSelected(
                                                    _model.languages.toList(),
                                                    'ukrainian')!)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box_outline_blank,
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
                                          functions.profileLanguageLabel(
                                              'ukrainian')!,
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
                                  if (functions.profileLanguageSelected(
                                      _model.languages.toList(), 'polish')!) {
                                    _model.removeFromLanguages('polish');
                                    safeSetState(() {});
                                  } else {
                                    _model.addToLanguages('polish');
                                    safeSetState(() {});
                                  }
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
                                            if (functions
                                                    .profileLanguageSelected(
                                                        _model.languages
                                                            .toList(),
                                                        'polish') ??
                                                true)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 28.0,
                                                ),
                                              ),
                                            if (!functions
                                                .profileLanguageSelected(
                                                    _model.languages.toList(),
                                                    'polish')!)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box_outline_blank,
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
                                          functions
                                              .profileLanguageLabel('polish')!,
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
                                  if (functions.profileLanguageSelected(
                                      _model.languages.toList(), 'dutch')!) {
                                    _model.removeFromLanguages('dutch');
                                    safeSetState(() {});
                                  } else {
                                    _model.addToLanguages('dutch');
                                    safeSetState(() {});
                                  }
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
                                            if (functions
                                                    .profileLanguageSelected(
                                                        _model.languages
                                                            .toList(),
                                                        'dutch') ??
                                                true)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 28.0,
                                                ),
                                              ),
                                            if (!functions
                                                .profileLanguageSelected(
                                                    _model.languages.toList(),
                                                    'dutch')!)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box_outline_blank,
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
                                          functions
                                              .profileLanguageLabel('dutch')!,
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
                                  if (functions.profileLanguageSelected(
                                      _model.languages.toList(), 'hindi')!) {
                                    _model.removeFromLanguages('hindi');
                                    safeSetState(() {});
                                  } else {
                                    _model.addToLanguages('hindi');
                                    safeSetState(() {});
                                  }
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
                                            if (functions
                                                    .profileLanguageSelected(
                                                        _model.languages
                                                            .toList(),
                                                        'hindi') ??
                                                true)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 28.0,
                                                ),
                                              ),
                                            if (!functions
                                                .profileLanguageSelected(
                                                    _model.languages.toList(),
                                                    'hindi')!)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box_outline_blank,
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
                                          functions
                                              .profileLanguageLabel('hindi')!,
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
                                  if (functions.profileLanguageSelected(
                                      _model.languages.toList(), 'hebrew')!) {
                                    _model.removeFromLanguages('hebrew');
                                    safeSetState(() {});
                                  } else {
                                    _model.addToLanguages('hebrew');
                                    safeSetState(() {});
                                  }
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
                                            if (functions
                                                    .profileLanguageSelected(
                                                        _model.languages
                                                            .toList(),
                                                        'hebrew') ??
                                                true)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 28.0,
                                                ),
                                              ),
                                            if (!functions
                                                .profileLanguageSelected(
                                                    _model.languages.toList(),
                                                    'hebrew')!)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box_outline_blank,
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
                                          functions
                                              .profileLanguageLabel('hebrew')!,
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
                                  if (functions.profileLanguageSelected(
                                      _model.languages.toList(), 'swedish')!) {
                                    _model.removeFromLanguages('swedish');
                                    safeSetState(() {});
                                  } else {
                                    _model.addToLanguages('swedish');
                                    safeSetState(() {});
                                  }
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
                                            if (functions
                                                    .profileLanguageSelected(
                                                        _model.languages
                                                            .toList(),
                                                        'swedish') ??
                                                true)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 28.0,
                                                ),
                                              ),
                                            if (!functions
                                                .profileLanguageSelected(
                                                    _model.languages.toList(),
                                                    'swedish')!)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box_outline_blank,
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
                                          functions
                                              .profileLanguageLabel('swedish')!,
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
                                  if (functions.profileLanguageSelected(
                                      _model.languages.toList(),
                                      'norwegian')!) {
                                    _model.removeFromLanguages('norwegian');
                                    safeSetState(() {});
                                  } else {
                                    _model.addToLanguages('norwegian');
                                    safeSetState(() {});
                                  }
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
                                            if (functions
                                                    .profileLanguageSelected(
                                                        _model.languages
                                                            .toList(),
                                                        'norwegian') ??
                                                true)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 28.0,
                                                ),
                                              ),
                                            if (!functions
                                                .profileLanguageSelected(
                                                    _model.languages.toList(),
                                                    'norwegian')!)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box_outline_blank,
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
                                          functions.profileLanguageLabel(
                                              'norwegian')!,
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
                                  if (functions.profileLanguageSelected(
                                      _model.languages.toList(), 'finnish')!) {
                                    _model.removeFromLanguages('finnish');
                                    safeSetState(() {});
                                  } else {
                                    _model.addToLanguages('finnish');
                                    safeSetState(() {});
                                  }
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
                                            if (functions
                                                    .profileLanguageSelected(
                                                        _model.languages
                                                            .toList(),
                                                        'finnish') ??
                                                true)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box,
                                                  color: FloterTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 28.0,
                                                ),
                                              ),
                                            if (!functions
                                                .profileLanguageSelected(
                                                    _model.languages.toList(),
                                                    'finnish')!)
                                              Container(
                                                child: Icon(
                                                  Icons.check_box_outline_blank,
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
                                          functions
                                              .profileLanguageLabel('finnish')!,
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
