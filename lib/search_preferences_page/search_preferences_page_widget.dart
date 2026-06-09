import 'dart:async';

import '/backend/supabase/supabase.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'search_preferences_page_model.dart';

export 'search_preferences_page_model.dart';

/// Figma search preferences flow for dating filters.
class SearchPreferencesPageWidget extends StatefulWidget {
  const SearchPreferencesPageWidget({super.key});

  static String routeName = 'SearchPreferencesPage';
  static String routePath = '/search-preferences';

  @override
  State<SearchPreferencesPageWidget> createState() =>
      _SearchPreferencesPageWidgetState();
}

class _SearchPreferencesPageWidgetState
    extends State<SearchPreferencesPageWidget> {
  late SearchPreferencesPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isExiting = false;
  bool _allowPop = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchPreferencesPageModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _loadPreferences();
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _loadPreferences() async {
    final userId = SupaFlow.client.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) {
      return;
    }

    try {
      final preferences = await SupaFlow.client
          .from('user_preferences')
          .select('min_age, max_age, preferred_genders')
          .eq('user_id', userId)
          .limit(1)
          .maybeSingle();

      if (!mounted) {
        return;
      }

      final rawGenders = (preferences?['preferred_genders'] as List?) ?? const [];
      final preferredGenders = rawGenders
          .map((item) => item?.toString().trim())
          .whereType<String>()
          .where((value) => value.isNotEmpty)
          .toSet();

      safeSetState(() {
        final loadedMin =
            (preferences?['min_age'] as num?)?.round() ?? _model.minAge ?? 20;
        final loadedMax =
            (preferences?['max_age'] as num?)?.round() ?? _model.maxAge ?? 50;
        final clampedMin = loadedMin.clamp(20, 100).toInt();
        final clampedMax = loadedMax.clamp(20, 100).toInt();
        _model.minAge = clampedMin;
        _model.maxAge = clampedMax < clampedMin ? clampedMin : clampedMax;
        _model.checkboxValue1 = preferredGenders.contains('woman');
        _model.checkboxValue2 = preferredGenders.contains('man');
        _model.checkboxValue3 = preferredGenders.contains('other');
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      safeSetState(() {
        _model.minAge = _model.minAge ?? 20;
        _model.maxAge = _model.maxAge ?? 50;
        _model.checkboxValue1 ??= false;
        _model.checkboxValue2 ??= false;
        _model.checkboxValue3 ??= false;
      });
    }
  }

  List<String> _selectedGenders() {
    final genders = <String>[];
    if (_model.checkboxValue1 == true) {
      genders.add('woman');
    }
    if (_model.checkboxValue2 == true) {
      genders.add('man');
    }
    if (_model.checkboxValue3 == true) {
      genders.add('other');
    }
    return genders;
  }

  String _ageSummaryText() {
    final minAge = _model.minAge ?? 20;
    final maxAge = _model.maxAge ?? 50;
    return '$minAge-$maxAge';
  }

  Future<void> _savePreferences() async {
    final userId = SupaFlow.client.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) {
      return;
    }

    final minAge = (_model.minAge ?? 20).clamp(20, 100).toInt();
    final maxAge = (_model.maxAge ?? 50).clamp(20, 100).toInt();

    await SupaFlow.client.from('user_preferences').upsert({
      'user_id': userId,
      'min_age': minAge,
      'max_age': maxAge,
      'preferred_genders': _selectedGenders(),
    }, onConflict: 'user_id');
  }

  Future<void> _saveAndExit() async {
    if (_isExiting) {
      return;
    }

    _isExiting = true;
    try {
      await _savePreferences();
      if (!mounted) {
        return;
      }
      safeSetState(() {
        _allowPop = true;
      });
      await Future<void>.delayed(Duration.zero);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save preferences: $error'),
          duration: const Duration(milliseconds: 3000),
        ),
      );
      _isExiting = false;
      _allowPop = false;
    }
  }

  Widget _buildGenderOption({
    required String labelKey,
    required bool? value,
    required ValueChanged<bool?> onChanged,
  }) {
    final theme = FloterTheme.of(context);
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Theme(
            data: ThemeData(
              checkboxTheme: CheckboxThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              unselectedWidgetColor: theme.secondaryText,
            ),
            child: Checkbox(
              value: value ?? false,
              onChanged: onChanged,
              side: BorderSide(
                width: 2,
                color: theme.secondaryText,
              ),
              activeColor: theme.primary,
              checkColor: theme.primaryBackground,
            ),
          ),
          const SizedBox(width: 6.0),
          Flexible(
            child: Text(
              AppLabels.of(context).get(labelKey),
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
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
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FloterTheme.of(context);
    final minAge = (_model.minAge ?? 20).toDouble();
    final maxAge = (_model.maxAge ?? 50).toDouble();

    return PopScope(
      canPop: _allowPop,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop || _isExiting) {
          return;
        }
        unawaited(_saveAndExit());
      },
      child: GestureDetector(
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
              padding: const EdgeInsetsDirectional.fromSTEB(24.0, 44.0, 24.0, 28.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FloterIconButton(
                          borderRadius: 8.0,
                          buttonSize: 40.0,
                          fillColor: theme.primaryBackground,
                          icon: Icon(
                            Icons.arrow_back,
                            color: theme.primaryText,
                            size: 24.0,
                          ),
                          onPressed: () async {
                            await _saveAndExit();
                          },
                        ),
                        Expanded(
                          child: Text(
                            AppLabels.of(context).get(
                              'search_preferences.title' /* Search Preferences */,
                            ),
                            maxLines: 2,
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
                        ),
                      ].divide(const SizedBox(width: 12.0)),
                    ),
                    Text(
                      AppLabels.of(context).get(
                        'search_preferences.who_you_want_to_date' /* Who you want to date: */,
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
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGenderOption(
                          labelKey: 'search_preferences.women',
                          value: _model.checkboxValue1,
                          onChanged: (newValue) {
                            safeSetState(() {
                              _model.checkboxValue1 = newValue ?? false;
                            });
                          },
                        ),
                        _buildGenderOption(
                          labelKey: 'search_preferences.men',
                          value: _model.checkboxValue2,
                          onChanged: (newValue) {
                            safeSetState(() {
                              _model.checkboxValue2 = newValue ?? false;
                            });
                          },
                        ),
                        _buildGenderOption(
                          labelKey: 'search_preferences.other_gender',
                          value: _model.checkboxValue3,
                          onChanged: (newValue) {
                            safeSetState(() {
                              _model.checkboxValue3 = newValue ?? false;
                            });
                          },
                        ),
                      ].divide(const SizedBox(width: 4.0)),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLabels.of(context).get(
                            'search_preferences.age' /* Age: */,
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
                        Text(
                          _ageSummaryText(),
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
                        RangeSlider(
                          values: RangeValues(minAge, maxAge),
                          min: 20.0,
                          max: 100.0,
                          divisions: 82,
                          activeColor: theme.primary,
                          inactiveColor: theme.alternate,
                          onChanged: (newValues) {
                            safeSetState(() {
                              final newMin = newValues.start.round();
                              final newMax = newValues.end.round();
                              _model.minAge = newMin;
                              _model.maxAge = newMax < newMin ? newMin : newMax;
                            });
                          },
                        ),
                      ].divide(const SizedBox(height: 4.0)),
                    ),
                  ].divide(const SizedBox(height: 16.0)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
