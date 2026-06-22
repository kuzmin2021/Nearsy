import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/nearsy_bottom_nav_widget.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/services/profile/profile_localization.dart';
import 'dart:ui';
import '/floter/custom_functions.dart' as functions;
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_page_model.dart';
export 'profile_page_model.dart';

/// Shows the current user profile, photos, and edit entry.
class ProfilePageWidget extends StatefulWidget {
  const ProfilePageWidget({
    super.key,
    String? aboutOverride,
    String? educationOverride,
    String? kidsOverride,
    String? relationshipTypeOverride,
    String? religionOverride,
    String? bodyTypeOverride,
    String? exerciseOverride,
    String? drinkingOverride,
    String? smokingOverride,
    String? genderOverride,
    String? birthdayOverride,
    String? languagesOverride,
    String? heightOverride,
    String? workOverride,
  })  : this.aboutOverride = aboutOverride ?? '',
        this.educationOverride = educationOverride ?? '',
        this.kidsOverride = kidsOverride ?? '',
        this.relationshipTypeOverride = relationshipTypeOverride ?? '',
        this.religionOverride = religionOverride ?? '',
        this.bodyTypeOverride = bodyTypeOverride ?? '',
        this.exerciseOverride = exerciseOverride ?? '',
        this.drinkingOverride = drinkingOverride ?? '',
        this.smokingOverride = smokingOverride ?? '',
        this.genderOverride = genderOverride ?? '',
        this.birthdayOverride = birthdayOverride ?? '',
        this.languagesOverride = languagesOverride ?? '',
        this.heightOverride = heightOverride ?? '',
        this.workOverride = workOverride ?? '';

  /// Fresh about-me text passed back from the editor after save.
  final String aboutOverride;

  /// Fresh profile attribute value passed back after save.
  final String educationOverride;

  /// Fresh profile attribute value passed back after save.
  final String kidsOverride;

  /// Fresh profile attribute value passed back after save.
  final String relationshipTypeOverride;

  /// Fresh profile attribute value passed back after save.
  final String religionOverride;

  /// Fresh profile attribute value passed back after save.
  final String bodyTypeOverride;

  /// Fresh profile attribute value passed back after save.
  final String exerciseOverride;

  /// Fresh profile attribute value passed back after save.
  final String drinkingOverride;

  /// Fresh profile attribute value passed back after save.
  final String smokingOverride;

  /// Fresh profile attribute value passed back after save.
  final String genderOverride;

  /// Fresh profile attribute value passed back after save.
  final String birthdayOverride;

  /// Fresh profile attribute value passed back after save.
  final String languagesOverride;

  /// Fresh profile attribute value passed back after save.
  final String heightOverride;

  /// Fresh profile attribute value passed back after save.
  final String workOverride;

  static String routeName = 'ProfilePage';
  static String routePath = '/profilePage';

  @override
  State<ProfilePageWidget> createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends State<ProfilePageWidget> {
  late ProfilePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _validProfileName(String? rawName) {
    final name = (rawName ?? '').trim();
    if (name.isEmpty || name.runes.length > 20) {
      return false;
    }
    return RegExp(r'[A-Za-z\u0400-\u04FF]').hasMatch(name);
  }

  bool _applyProfileDisplayNameState(String rawValue) {
    final value = rawValue.trim();
    final isValid = _validProfileName(value);
    _model.profileDisplayName = value;
    _model.showProfileNameError = !isValid;
    FTAppState().update(() {
      FTAppState().profileIsOnboarded = isValid;
    });
    safeSetState(() {});
    return isValid;
  }

  Future<void> _saveProfileDisplayName({
    bool showInvalidSnackBar = false,
  }) async {
    final userId = SupaFlow.client.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) {
      return;
    }

    final value =
        _model.profileDisplayNameFieldTextController?.text.trim() ?? '';
    final isValid = _applyProfileDisplayNameState(value);

    try {
      await SupaFlow.client.from('profiles').upsert({
        'user_id': userId,
        'display_name': value,
      }, onConflict: 'user_id', defaultToNull: false);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile: $error')),
        );
      }
      return;
    }

    if (!isValid && showInvalidSnackBar && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name must be 1-20 characters and include letters.'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfilePageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final userId = SupaFlow.client.auth.currentUser?.id;
      if (userId == null || userId.isEmpty) {
        _model.profileMainPhotoUrl = '';
        _model.profileAbout = '';
        _model.profileGender = '';
        _model.profileBirthday = '';
        _model.profileLocation = '';
        _model.profileLanguages = [];
        _model.profileHeight = '';
        _model.profileWork = '';
        _model.profileEducation = '';
        _model.profileKids = '';
        _model.profileRelationshipType = '';
        _model.profileBeliefs = '';
        _model.profileBodyType = '';
        _model.profileExercise = '';
        _model.profileDrinking = '';
        _model.profileSmoking = '';
        safeSetState(() {});
        return;
      }
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
        if (value is bool) {
          return value ? 'Yes' : 'No';
        }
        return value.toString().trim();
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

      final profiles = await SupaFlow.client
          .from('profiles')
          .select(
            'avatar_url, display_name, catchphrase, description, gender, birthday, '
            'location_label, languages, height, height_cm, is_metric, work, education, kids, '
            'relationship_type, religion, body_type, exercise, drinking, smoking',
          )
          .eq('user_id', userId)
          .limit(1);
      final profile = profiles.isNotEmpty ? profiles.first : null;
      final displayName = cleanValue(profile?['display_name']);
      final catchphrase = cleanValue(profile?['catchphrase']);
      FTAppState().update(() {
        FTAppState().profileIsOnboarded = _validProfileName(displayName);
      });
      _model.profileDisplayName = displayName;
      _model.profileCatchphrase = catchphrase;
      _model.showProfileNameError = !_validProfileName(displayName);
      _model.profileDisplayNameFieldTextController?.text = displayName;
      _model.profileCatchphraseFieldTextController?.text = catchphrase;
      _model.profileMainPhotoUrl = SupaFlow.resolvePhotoUrl(profile?['avatar_url']);
      _model.profileAbout = cleanValue(profile?['description']);
      _model.profileGender =
          localizeProfileAttribute('gender', profile?['gender']);
      _model.profileBirthday = cleanValue(profile?['birthday']);
      _model.profileLocation = cleanValue(profile?['location_label']);
      _model.profileLanguages = cleanStringList(profile?['languages']);
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

      String formatHeightDisplay(int? heightCm, bool isMetric) {
        if (heightCm == null || heightCm <= 0) {
          return '';
        }
        final languageCode =
            PlatformDispatcher.instance.locale.languageCode.toLowerCase();
        const labelsByLanguage = <String, Map<String, String>>{
          'en': {'cm': 'cm', 'ft': 'ft'},
          'ru': {'cm': '\u0441\u043c', 'ft': '\u0444\u0442'},
        };
        final labels =
            labelsByLanguage[languageCode] ?? labelsByLanguage['en']!;
        final unit = labels[isMetric ? 'cm' : 'ft']!;
        if (!isMetric) {
          final feet = heightCm / 30.48;
          final text = feet.toStringAsFixed(1);
          final feetText =
              text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
          return '$feetText $unit';
        }
        return '$heightCm $unit';
      }

      bool cleanBool(dynamic value) {
        if (value is bool) {
          return value;
        }
        final text = (value?.toString() ?? '').trim().toLowerCase();
        if (text == 'false' || text == '0' || text == 'ft') {
          return false;
        }
        return true;
      }

      _model.profileHeight = formatHeightDisplay(
        parseHeightCm(profile?['height_cm'] ?? profile?['height']),
        cleanBool(profile?['is_metric']),
      );
      if (widget.heightOverride == '__cleared_profile_attribute__') {
        _model.profileHeight = '';
      } else if (widget.heightOverride.trim().isNotEmpty) {
        _model.profileHeight = cleanValue(widget.heightOverride);
      }
      if (widget.languagesOverride == '__cleared_profile_attribute__') {
        _model.profileLanguages = [];
      } else if (widget.languagesOverride.trim().isNotEmpty) {
        _model.profileLanguages = cleanStringList(widget.languagesOverride);
      }
      if (widget.birthdayOverride == '__cleared_profile_attribute__') {
        _model.profileBirthday = '';
      } else if (widget.birthdayOverride.trim().isNotEmpty) {
        _model.profileBirthday = cleanValue(widget.birthdayOverride);
      }
      _model.profileWork = cleanValue(profile?['work']);
      _model.profileEducation =
          localizeProfileAttribute('education', profile?['education']);
      _model.profileKids = localizeProfileAttribute('kids', profile?['kids']);
      _model.profileRelationshipType = localizeProfileAttribute(
          'relationship_type', profile?['relationship_type']);
      _model.profileBeliefs =
          localizeProfileAttribute('religion', profile?['religion']);
      _model.profileBodyType =
          localizeProfileAttribute('body_type', profile?['body_type']);
      _model.profileExercise =
          localizeProfileAttribute('exercise', profile?['exercise']);
      _model.profileDrinking =
          localizeProfileAttribute('drinking', profile?['drinking']);
      _model.profileSmoking =
          localizeProfileAttribute('smoking', profile?['smoking']);
      final photos = await SupaFlow.client
          .from('user_photos')
          .select('photo_url, slot, order')
          .eq('user_id', userId)
          .order('slot', ascending: true)
          .order('order', ascending: true)
          .limit(6);

      final photoUrls = <String>[];
      for (final photo in photos) {
        final url = SupaFlow.resolvePhotoUrl(photo['photo_url']) ?? '';
        if (url.isNotEmpty) {
          photoUrls.add(url);
        }
        if (photoUrls.length >= 6) {
          break;
        }
      }
      final gridSlots = <String>[...photoUrls];
      final visibleSlots = photoUrls.length < 3 ? 3 : 6;
      if (photoUrls.length < 6) {
        gridSlots.add('__add_photo__');
      }
      while (gridSlots.length < visibleSlots) {
        gridSlots.add('__empty_photo__');
      }
      _model.profileGridSlots = gridSlots;
      safeSetState(() {});
    });

    _model.profileDisplayNameFieldTextController ??= TextEditingController();
    _model.profileDisplayNameFieldFocusNode ??= FocusNode();
    _model.profileDisplayNameFieldFocusNode!.addListener(
      () async {
        if (_model.profileDisplayNameFieldFocusNode?.hasFocus ?? false) {
          return;
        }
        await _saveProfileDisplayName();
      },
    );
    _model.profileCatchphraseFieldTextController ??= TextEditingController();
    _model.profileCatchphraseFieldFocusNode ??= FocusNode();
    _model.profileCatchphraseFieldFocusNode!.addListener(
      () async {
        if (_model.profileCatchphraseFieldFocusNode?.hasFocus ?? false) {
          return;
        }
        final userId = SupaFlow.client.auth.currentUser?.id;
        if (userId == null || userId.isEmpty) {
          return;
        }
        final value = _model.profileCatchphraseFieldTextController.text;
        _model.profileCatchphrase = value;
        safeSetState(() {});

        try {
          await SupaFlow.client.from('profiles').upsert({
            'user_id': userId,
            'catchphrase': value,
          }, onConflict: 'user_id', defaultToNull: false);
        } catch (error) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to save profile: $error')),
            );
          }
        }
      },
    );
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
            height: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(23.0, 36.0, 19.0, 20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                AppLabels.of(context).get(
                                  'profile.title' /* Profile */,
                                ),
                                style: FloterTheme.of(context)
                                    .titleLarge
                                    .override(
                                      font: GoogleFonts.interTight(
                                        fontWeight:
                                            FloterTheme.of(context)
                                                .titleLarge
                                                .fontWeight,
                                        fontStyle: FloterTheme.of(context)
                                            .titleLarge
                                            .fontStyle,
                                      ),
                                      color:
                                          FloterTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      fontWeight: FloterTheme.of(context)
                                          .titleLarge
                                          .fontWeight,
                                      fontStyle: FloterTheme.of(context)
                                          .titleLarge
                                          .fontStyle,
                                    ),
                              ),
                              FloterIconButton(
                                borderRadius: 8.0,
                                buttonSize: 54.0,
                                fillColor:
                                    FloterTheme.of(context).primaryBackground,
                               icon: Icon(
                                  Icons.tune,
                                  color: FloterTheme.of(context).primaryText,
                                  size: 22.0,
                                ),
                                onPressed: () {
                                  context.pushNamed(
                                      AccountSettingsPageWidget.routeName);
                                },
                              ),
                            ],
                          ),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          alignment:
                                              AlignmentDirectional(1.0, -1.0),
                                          children: [
                                            if (!(_model.profileMainPhotoUrl ==
                                                ''))
                                              Positioned.fill(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: CachedNetworkImage(
                                                    fadeInDuration: Duration(
                                                        milliseconds: 0),
                                                    fadeOutDuration: Duration(
                                                        milliseconds: 0),
                                                    imageUrl: _model
                                                        .profileMainPhotoUrl!,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            if (_model.profileMainPhotoUrl ==
                                                '')
                                              Positioned.fill(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        FloterTheme.of(context)
                                                            .primaryBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    border: Border.all(
                                                      color: FloterTheme.of(
                                                              context)
                                                          .primaryText,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      final result =
                                                          await FilePicker
                                                              .platform
                                                              .pickFiles(
                                                        type: FileType.image,
                                                        allowMultiple: false,
                                                        withData: true,
                                                      );
                                                      if (result == null ||
                                                          result
                                                              .files.isEmpty) {
                                                        return;
                                                      }
                                                      final pickedFile =
                                                          result.files.single;
                                                      final bytes =
                                                          pickedFile.bytes;
                                                      if (bytes == null ||
                                                          bytes.isEmpty) {
                                                        return;
                                                      }

                                                      final createDataTime =
                                                          DateTime.now()
                                                              .millisecondsSinceEpoch
                                                              .toString();
                                                      final userId = SupaFlow
                                                          .client
                                                          .auth
                                                          .currentUser
                                                          ?.id;
                                                       if (userId == null ||
                                                           userId.isEmpty) {
                                                         return;
                                                       }
                                                       final storagePath =
                                                           '$userId/$createDataTime';

                                                      var uploadedUrl = '';
                                                      var uploadFailed = false;
                                                      var uploadError = '';
                                                      try {
                                                        final storageBucket =
                                                            SupaFlow
                                                                .client.storage
                                                                .from(
                                                                    'user_photos');
                                                        await storageBucket
                                                            .uploadBinary(
                                                                storagePath,
                                                                bytes);
                                                        uploadedUrl =
                                                            SupaFlow
                                                                .publicPhotoUrl(
                                                                    storagePath);
                                                         await SupaFlow.client
                                                            .from('profiles')
                                                            .update({
                                                          'avatar_url':
                                                              storagePath
                                                        }).eq('user_id',
                                                                userId);
                                                        _model.profileMainPhotoUrl =
                                                            SupaFlow.publicPhotoUrl(
                                                                storagePath);
                                                        safeSetState(() {});
                                                      } catch (error) {
                                                        uploadFailed = true;
                                                        uploadError =
                                                            error.toString();
                                                      }

                                                      if (uploadFailed ||
                                                          uploadedUrl.isEmpty) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                              content: Text(uploadError
                                                                      .isEmpty
                                                                  ? 'Failed to upload photo'
                                                                  : uploadError)),
                                                        );
                                                        return;
                                                      }
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'Photo uploaded')),
                                                      );
                                                    },
                                                    child: Container(
                                                      width: 56.0,
                                                      height: 56.0,
                                                      decoration: BoxDecoration(
                                                        color: FloterTheme.of(
                                                                context)
                                                            .alternate,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(28.0),
                                                      ),
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Icon(
                                                        Icons.add,
                                                        color: FloterTheme.of(
                                                                context)
                                                            .primaryBackground,
                                                        size: 44.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            if (!(_model.profileMainPhotoUrl ==
                                                ''))
                                              Positioned(
                                                top: -8.0,
                                                right: -8.0,
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    if ((_model.profileMainPhotoUrl ??
                                                            '')
                                                        .trim()
                                                        .isEmpty) {
                                                      return;
                                                    }
                                                    final userId = SupaFlow
                                                        .client
                                                        .auth
                                                        .currentUser
                                                        ?.id;
                                                    if (userId == null ||
                                                        userId.isEmpty) {
                                                      return;
                                                    }
                                                    await SupaFlow.client
                                                        .from('profiles')
                                                        .update({
                                                      'avatar_url': ''
                                                    }).eq('user_id', userId);
                                                    _model.profileMainPhotoUrl =
                                                        '';
                                                    safeSetState(() {});
                                                  },
                                                  child: Container(
                                                    width: 42.0,
                                                    height: 42.0,
                                                    decoration: BoxDecoration(
                                                      color: FloterTheme.of(
                                                              context)
                                                          .alternate,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              21.0),
                                                    ),
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Icon(
                                                      Icons.close,
                                                      color: FloterTheme.of(
                                                              context)
                                                          .primaryBackground,
                                                      size: 28.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 44.0,
                                        child: Stack(
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          children: [
                                            if (!_model.showProfileNameError!)
                                              Container(
                                                width: double.infinity,
                                                height: 44.0,
                                                decoration: BoxDecoration(
                                                  color: FloterTheme.of(context)
                                                      .secondaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  border: Border.all(
                                                    color:
                                                        FloterTheme.of(context)
                                                            .primaryText,
                                                    width: 1.0,
                                                  ),
                                                ),
                                              ),
                                            if (_model.showProfileNameError ??
                                                true)
                                              Container(
                                                width: double.infinity,
                                                height: 44.0,
                                                decoration: BoxDecoration(
                                                  color: FloterTheme.of(context)
                                                      .secondaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  border: Border.all(
                                                    color:
                                                        FloterTheme.of(context)
                                                            .error,
                                                    width: 1.0,
                                                  ),
                                                ),
                                              ),
                                            Container(
                                              width: double.infinity,
                                              height: 44.0,
                                              child: Padding(
                                                padding: EdgeInsets.zero,
                                                child: TextFormField(
                                                  controller: _model
                                                      .profileDisplayNameFieldTextController,
                                                  focusNode: _model
                                                      .profileDisplayNameFieldFocusNode,
                                                  onChanged: (_) {
                                                    _applyProfileDisplayNameState(
                                                      _model.profileDisplayNameFieldTextController
                                                              ?.text ??
                                                          '',
                                                    );
                                                    EasyDebounce.debounce(
                                                      '_model.profileDisplayNameFieldTextController',
                                                      Duration(
                                                          milliseconds: 2000),
                                                      () async {
                                                        await _saveProfileDisplayName();
                                                      },
                                                    );
                                                  },
                                                  onFieldSubmitted: (_) async {
                                                    await _saveProfileDisplayName(
                                                      showInvalidSnackBar: true,
                                                    );
                                                  },
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(12.0, 0.0,
                                                                12.0, 0.0),
                                                    hintText:
                                                        AppLabels.of(context)
                                                            .get(
                                                      'profile.name' /* Name */,
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Color(0x00000000),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(
                                                                4.0),
                                                        topRight:
                                                            Radius.circular(
                                                                4.0),
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Color(0x00000000),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(
                                                                4.0),
                                                        topRight:
                                                            Radius.circular(
                                                                4.0),
                                                      ),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Color(0x00000000),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(
                                                                4.0),
                                                        topRight:
                                                            Radius.circular(
                                                                4.0),
                                                      ),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Color(0x00000000),
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(
                                                                4.0),
                                                        topRight:
                                                            Radius.circular(
                                                                4.0),
                                                      ),
                                                    ),
                                                    filled: true,
                                                  ),
                                                  style: TextStyle(),
                                                  maxLength: 20,
                                                  maxLengthEnforcement:
                                                      MaxLengthEnforcement
                                                          .enforced,
                                                  buildCounter: (context,
                                                          {required currentLength,
                                                          required isFocused,
                                                          maxLength}) =>
                                                      null,
                                                  validator: _model
                                                      .profileDisplayNameFieldTextControllerValidator
                                                      .asValidator(context),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      AspectRatio(
                                        aspectRatio: 3.0,
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FloterTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                              color: FloterTheme.of(context)
                                                  .secondaryText,
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.zero,
                                            child: TextFormField(
                                              controller: _model
                                                  .profileCatchphraseFieldTextController,
                                              focusNode: _model
                                                  .profileCatchphraseFieldFocusNode,
                                              onChanged: (_) =>
                                                  EasyDebounce.debounce(
                                                '_model.profileCatchphraseFieldTextController',
                                                Duration(milliseconds: 2000),
                                                () async {
                                                  _model.profileCatchphrase = _model
                                                      .profileCatchphraseFieldTextController
                                                      .text;
                                                  safeSetState(() {});
                                                },
                                              ),
                                              onFieldSubmitted: (_) async {
                                                _model.profileCatchphrase = _model
                                                    .profileCatchphraseFieldTextController
                                                    .text;
                                                safeSetState(() {});
                                                await ProfilesTable().update(
                                                  data: {
                                                    'catchphrase': _model
                                                        .profileCatchphraseFieldTextController
                                                        .text,
                                                  },
                                                  matchingRows: (rows) =>
                                                      rows.eqOrNull(
                                                    'user_id',
                                                    currentUserUid,
                                                  ),
                                                );

                                                safeSetState(() {});
                                              },
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(12.0, 8.0,
                                                            12.0, 8.0),
                                                hintText:
                                                    AppLabels.of(context).get(
                                                  'profile.catchphrase' /* Catchphrase */,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    topRight:
                                                        Radius.circular(4.0),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    topRight:
                                                        Radius.circular(4.0),
                                                  ),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    topRight:
                                                        Radius.circular(4.0),
                                                  ),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    topRight:
                                                        Radius.circular(4.0),
                                                  ),
                                                ),
                                                filled: true,
                                              ),
                                              style: TextStyle(),
                                              textAlignVertical:
                                                  TextAlignVertical.top,
                                              expands: true,
                                              minLines: null,
                                              maxLines: null,
                                              maxLength: 80,
                                              maxLengthEnforcement:
                                                  MaxLengthEnforcement.enforced,
                                              buildCounter: (context,
                                                      {required currentLength,
                                                      required isFocused,
                                                      maxLength}) =>
                                                  null,
                                              validator: _model
                                                  .profileCatchphraseFieldTextControllerValidator
                                                  .asValidator(context),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                ),
                              ].divide(SizedBox(width: 16.0)),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Builder(
                              builder: (context) {
                                final profileGridSlot =
                                    _model.profileGridSlots.toList();

                                return GridView.builder(
                                  padding: EdgeInsets.zero,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 12.0,
                                    mainAxisSpacing: 12.0,
                                    childAspectRatio: 1.0,
                                  ),
                                  shrinkWrap: true,
                                  itemCount: profileGridSlot.length,
                                  itemBuilder: (context, profileGridSlotIndex) {
                                    final profileGridSlotItem =
                                        profileGridSlot[profileGridSlotIndex];
                                    return Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        children: [
                                          if (functions
                                                  .isFilledProfilePhotoSlot(
                                                      profileGridSlotItem) ??
                                              true)
                                            Positioned.fill(
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                alignment: AlignmentDirectional(
                                                    1.0, -1.0),
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: CachedNetworkImage(
                                                      fadeInDuration: Duration(
                                                          milliseconds: 0),
                                                      fadeOutDuration: Duration(
                                                          milliseconds: 0),
                                                      imageUrl:
                                                          profileGridSlotItem,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: -8.0,
                                                    right: -8.0,
                                                    child: InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        _model.profileSelectedGridPhotoUrl =
                                                            profileGridSlotItem;
                                                        safeSetState(() {});
                                                        List<String>
                                                            buildGridSlots(
                                                                List<String>
                                                                    photoUrls) {
                                                          final compact = photoUrls
                                                              .map((url) =>
                                                                  url.trim())
                                                              .where((url) =>
                                                                  url.isNotEmpty)
                                                              .take(6)
                                                              .toList();
                                                          final slots =
                                                              <String>[
                                                            ...compact
                                                          ];
                                                          final visibleSlots =
                                                              compact.length < 3
                                                                  ? 3
                                                                  : 6;
                                                          if (compact.length <
                                                              6) {
                                                            slots.add(
                                                                '__add_photo__');
                                                          }
                                                          while (slots.length <
                                                              visibleSlots) {
                                                            slots.add(
                                                                '__empty_photo__');
                                                          }
                                                          return slots;
                                                        }

                                                        Future<
                                                                List<
                                                                    Map<String,
                                                                        dynamic>>>
                                                            loadPhotoRows(
                                                                String
                                                                    userId) async {
                                                          final rows = await SupaFlow
                                                              .client
                                                              .from(
                                                                  'user_photos')
                                                              .select(
                                                                  'photo_url, slot, order')
                                                              .eq('user_id',
                                                                  userId)
                                                              .order('slot',
                                                                  ascending:
                                                                      true)
                                                              .order('order',
                                                                  ascending:
                                                                      true)
                                                              .limit(6);
                                                          return rows
                                                              .map<
                                                                      Map<String,
                                                                          dynamic>>(
                                                                  (row) => Map<
                                                                      String,
                                                                      dynamic>.from(row))
                                                              .toList();
                                                        }

                                                        final selectedPhotoUrl =
                                                            (_model.profileSelectedGridPhotoUrl ??
                                                                    '')
                                                                .trim();
                                                        if (selectedPhotoUrl
                                                                .isEmpty ||
                                                            selectedPhotoUrl ==
                                                                '__add_photo__' ||
                                                            selectedPhotoUrl ==
                                                                '__empty_photo__') {
                                                          return;
                                                        }

                                                        final userId = SupaFlow
                                                            .client
                                                            .auth
                                                            .currentUser
                                                            ?.id;
                                                        if (userId == null ||
                                                            userId.isEmpty) {
                                                          return;
                                                        }

                                                        try {
                                                           await SupaFlow.client
                                                               .from(
                                                                   'user_photos')
                                                               .delete()
                                                               .eq('user_id',
                                                                   userId)
                                                               .eq('photo_url',
                                                                   SupaFlow.storagePathFromPhotoUrl(
                                                                       selectedPhotoUrl) ??
                                                                       '');

                                                          final remainingRows =
                                                              await loadPhotoRows(
                                                                  userId);
                                                           final urls = remainingRows
                                                               .map((row) =>
                                                                   SupaFlow.resolvePhotoUrl(
                                                                       row['photo_url']) ??
                                                                   '')
                                                               .where((url) =>
                                                                   url.isNotEmpty)
                                                               .take(6)
                                                               .toList();
                                                          _model.profileGridSlots =
                                                              buildGridSlots(
                                                                  urls);
                                                          _model.profileSelectedGridPhotoUrl =
                                                              '';
                                                          safeSetState(() {});
                                                          safeSetState(() {});
                                                        } catch (error) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                                content: Text(error
                                                                    .toString())),
                                                          );
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 42.0,
                                                        height: 42.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FloterTheme.of(
                                                                  context)
                                                              .alternate,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      21.0),
                                                        ),
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Icon(
                                                          Icons.close,
                                                          color: FloterTheme.of(
                                                                  context)
                                                              .primaryBackground,
                                                          size: 28.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (profileGridSlotItem ==
                                              '__add_photo__')
                                            Positioned.fill(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: FloterTheme.of(context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  border: Border.all(
                                                    color:
                                                        FloterTheme.of(context)
                                                            .primaryText,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    List<String> buildGridSlots(
                                                        List<String>
                                                            photoUrls) {
                                                      final compact = photoUrls
                                                          .map((url) =>
                                                              url.trim())
                                                          .where((url) =>
                                                              url.isNotEmpty)
                                                          .take(6)
                                                          .toList();
                                                      final slots = <String>[
                                                        ...compact
                                                      ];
                                                      final visibleSlots =
                                                          compact.length < 3
                                                              ? 3
                                                              : 6;
                                                      if (compact.length < 6) {
                                                        slots.add(
                                                            '__add_photo__');
                                                      }
                                                      while (slots.length <
                                                          visibleSlots) {
                                                        slots.add(
                                                            '__empty_photo__');
                                                      }
                                                      return slots;
                                                    }

                                                    Future<
                                                            List<
                                                                Map<String,
                                                                    dynamic>>>
                                                        loadPhotoRows(
                                                            String
                                                                userId) async {
                                                      final rows = await SupaFlow
                                                          .client
                                                          .from('user_photos')
                                                          .select(
                                                              'id, photo_url, slot, order')
                                                          .eq('user_id', userId)
                                                          .order('slot',
                                                              ascending: true)
                                                          .order('order',
                                                              ascending: true)
                                                          .limit(6);
                                                      return rows
                                                          .map<
                                                                  Map<String,
                                                                      dynamic>>(
                                                              (row) => Map<
                                                                      String,
                                                                      dynamic>.from(
                                                                  row))
                                                          .toList();
                                                    }

                                                    Future<void> refreshGrid(
                                                        String userId) async {
                                                      final rows =
                                                          await loadPhotoRows(
                                                              userId);
                                                      final urls = rows
                                                           .map((row) =>
                                                               SupaFlow.resolvePhotoUrl(
                                                                   row['photo_url']) ??
                                                               '')
                                                           .where((url) =>
                                                               url.isNotEmpty)
                                                           .toList();
                                                      _model.profileGridSlots =
                                                          buildGridSlots(urls);
                                                      safeSetState(() {});
                                                    }

                                                    final userId = SupaFlow
                                                        .client
                                                        .auth
                                                        .currentUser
                                                        ?.id;
                                                    if (userId == null ||
                                                        userId.isEmpty) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'User is not authenticated')),
                                                      );
                                                      return;
                                                    }

                                                    final existingRows =
                                                        await loadPhotoRows(
                                                            userId);
                                                    final existingUrls =
                                                        existingRows
                                                            .map((row) =>
                                                                (row['photo_url']
                                                                        as String?)
                                                                    ?.trim() ??
                                                                '')
                                                            .where((url) =>
                                                                url.isNotEmpty)
                                                            .toList();
                                                    if (existingUrls.length >=
                                                        6) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'Maximum 6 photos')),
                                                      );
                                                      return;
                                                    }

                                                    final result =
                                                        await FilePicker
                                                            .platform
                                                            .pickFiles(
                                                      type: FileType.image,
                                                      allowMultiple: false,
                                                      withData: true,
                                                    );
                                                    if (result == null ||
                                                        result.files.isEmpty) {
                                                      return;
                                                    }
                                                    final pickedFile =
                                                        result.files.single;
                                                    final bytes =
                                                        pickedFile.bytes;
                                                    if (bytes == null ||
                                                        bytes.isEmpty) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'Selected file is empty')),
                                                      );
                                                      return;
                                                    }

                                                    final existingSlots =
                                                        existingRows
                                                            .map((row) =>
                                                                row['slot'])
                                                            .whereType<int>()
                                                            .toList();
                                                    final maxSlot = existingSlots
                                                            .isEmpty
                                                        ? 0
                                                        : existingSlots.reduce(
                                                            (value, element) =>
                                                                value > element
                                                                    ? value
                                                                    : element);
                                                    final nextSlot =
                                                        maxSlot + 1;
                                                    final createDataTime =
                                                        DateTime.now()
                                                            .millisecondsSinceEpoch
                                                            .toString();
                                                    final storagePath =
                                                        '$userId/$createDataTime';
                                                    final storageBucket =
                                                        SupaFlow.client.storage
                                                            .from(
                                                                'user_photos');
                                                    var uploadedUrl = '';
                                                    try {
                                                      await storageBucket
                                                          .uploadBinary(
                                                              storagePath,
                                                              bytes);
                                                      uploadedUrl =
                                                          SupaFlow
                                                              .publicPhotoUrl(
                                                                  storagePath);
                                                      if (uploadedUrl
                                                          .trim()
                                                          .isEmpty) {
                                                        await storageBucket
                                                            .remove(
                                                                [storagePath]);
                                                        throw Exception(
                                                            'Uploaded photo URL is empty');
                                                      }
                                                      try {
                                                         await SupaFlow.client
                                                            .from('user_photos')
                                                            .insert({
                                                          'user_id': userId,
                                                          'position': nextSlot,
                                                          'photo_url':
                                                              storagePath,
                                                          'slot': nextSlot,
                                                          'order': nextSlot,
                                                        });
                                                      } catch (error) {
                                                        await storageBucket
                                                            .remove(
                                                                [storagePath]);
                                                        rethrow;
                                                      }
                                                      await refreshGrid(userId);
                                                      safeSetState(() {});
                                                    } catch (error) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                            content: Text(error
                                                                .toString())),
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 56.0,
                                                    height: 56.0,
                                                    decoration: BoxDecoration(
                                                      color: FloterTheme.of(
                                                              context)
                                                          .alternate,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              28.0),
                                                    ),
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Icon(
                                                      Icons.add,
                                                      color: FloterTheme.of(
                                                              context)
                                                          .primaryBackground,
                                                      size: 44.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (profileGridSlotItem ==
                                              '__empty_photo__')
                                            Positioned.fill(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: FloterTheme.of(context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  border: Border.all(
                                                    color:
                                                        FloterTheme.of(context)
                                                            .alternate,
                                                    width: 1.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                  ProfileAboutMePageWidget.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: FloterTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    9.0, 10.0, 9.0, 10.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLabels.of(context).get(
                                              'profile.about_me' /* About me */,
                                            ),
                                            maxLines: 1,
                                            style: GoogleFonts.inter(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              height: 1.0,
                                            ),
                                          ),
                                          Builder(
                                            builder: (context) {
                                              final value =
                                                  functions.effectiveProfileAttribute(
                                                      'about',
                                                      widget!.aboutOverride,
                                                      _model.profileAbout);
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return const SizedBox.shrink();
                                              }
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        top: 8.0),
                                                child: Text(
                                                  value,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                    height: 1.0,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 2.0, 0.0, 0.0),
                                        child: Icon(
                                          Icons.chevron_right,
                                          color: FloterTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context
                                  .pushNamed(ProfileGenderPageWidget.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: FloterTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    9.0, 11.0, 9.0, 11.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        AppLabels.of(context).get(
                                          'profile.gender' /* Gender */,
                                        ),
                                        maxLines: 2,
                                        style: GoogleFonts.inter(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          height: 1.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            final value = functions.effectiveProfileAttribute(
                                                'gender',
                                                widget!.genderOverride,
                                                _model.profileGender);
                                            if (value == null || value.isEmpty) {
                                              return const SizedBox.shrink();
                                            }
                                            return Container(
                                              width: 150.0,
                                              alignment: AlignmentDirectional(1.0, 0.0),
                                              child: Text(
                                                value,
                                                textAlign: TextAlign.end,
                                                maxLines: 1,
                                                style: GoogleFonts.inter(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  height: 1.0,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          },
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: FloterTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ].divide(SizedBox(width: 6.0)),
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(ProfileAgePageWidget.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: FloterTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    9.0, 11.0, 9.0, 11.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        AppLabels.of(context).get(
                                          'profile.age' /* Age */,
                                        ),
                                        maxLines: 2,
                                        style: GoogleFonts.inter(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          height: 1.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            final value = functions.effectiveProfileAttribute(
                                                'birthday',
                                                widget!.birthdayOverride,
                                                _model.profileBirthday);
                                            if (value == null || value.isEmpty) {
                                              return const SizedBox.shrink();
                                            }
                                            return Container(
                                              width: 150.0,
                                              alignment: AlignmentDirectional(1.0, 0.0),
                                              child: Text(
                                                value,
                                                textAlign: TextAlign.end,
                                                maxLines: 1,
                                                style: GoogleFonts.inter(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  height: 1.0,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          },
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: FloterTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ].divide(SizedBox(width: 6.0)),
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                  ProfileLanguagesPageWidget.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: FloterTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    9.0, 12.0, 9.0, 12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            functions.profileLanguagesUiText(
                                                'section')!,
                                            maxLines: 1,
                                            style: GoogleFonts.inter(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              height: 1.0,
                                            ),
                                          ),
                                          Text(
                                            functions.profileLanguagesEffectiveDisplay(
                                                _model.profileLanguages
                                                    .toList(),
                                                widget!.languagesOverride)!,
                                            maxLines: 8,
                                            style: GoogleFonts.inter(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              height: 1.0,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ].divide(SizedBox(height: 8.0)),
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 2.0, 0.0, 0.0),
                                        child: Icon(
                                          Icons.chevron_right,
                                          color: FloterTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context
                                  .pushNamed(ProfileHeightPageWidget.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: FloterTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    9.0, 11.0, 9.0, 11.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        AppLabels.of(context).get(
                                          'profile.height' /* Height */,
                                        ),
                                        maxLines: 2,
                                        style: GoogleFonts.inter(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          height: 1.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            final value = functions.effectiveProfileAttribute(
                                                'height',
                                                widget!.heightOverride,
                                                _model.profileHeight);
                                            if (value == null || value.isEmpty) {
                                              return const SizedBox.shrink();
                                            }
                                            return Container(
                                              width: 150.0,
                                              alignment: AlignmentDirectional(1.0, 0.0),
                                              child: Text(
                                                value,
                                                textAlign: TextAlign.end,
                                                maxLines: 1,
                                                style: GoogleFonts.inter(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  height: 1.0,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          },
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: FloterTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ].divide(SizedBox(width: 6.0)),
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context
                                  .pushNamed(ProfileWorkPageWidget.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: FloterTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    9.0, 11.0, 9.0, 11.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        AppLabels.of(context).get(
                                          'profile.work' /* Work */,
                                        ),
                                        maxLines: 2,
                                        style: GoogleFonts.inter(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          height: 1.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            final value = functions.effectiveProfileAttribute(
                                                'work',
                                                widget!.workOverride,
                                                _model.profileWork);
                                            if (value == null || value.isEmpty) {
                                              return const SizedBox.shrink();
                                            }
                                            return Container(
                                              width: 150.0,
                                              alignment: AlignmentDirectional(1.0, 0.0),
                                              child: Text(
                                                value,
                                                textAlign: TextAlign.end,
                                                maxLines: 1,
                                                style: GoogleFonts.inter(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  height: 1.0,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          },
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: FloterTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ].divide(SizedBox(width: 6.0)),
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                  ProfileEducationPageWidget.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: FloterTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    9.0, 11.0, 9.0, 11.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        AppLabels.of(context).get(
                                          'profile.education' /* Education */,
                                        ),
                                        maxLines: 2,
                                        style: GoogleFonts.inter(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          height: 1.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            final value = functions.effectiveProfileAttribute(
                                                'education',
                                                widget!.educationOverride,
                                                _model.profileEducation);
                                            if (value == null || value.isEmpty) {
                                              return const SizedBox.shrink();
                                            }
                                            return Container(
                                              width: 150.0,
                                              alignment: AlignmentDirectional(1.0, 0.0),
                                              child: Text(
                                                value,
                                                textAlign: TextAlign.end,
                                                maxLines: 1,
                                                style: GoogleFonts.inter(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  height: 1.0,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          },
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: FloterTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ].divide(SizedBox(width: 6.0)),
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context
                                  .pushNamed(ProfileKidsPageWidget.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: FloterTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    9.0, 11.0, 9.0, 11.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        AppLabels.of(context).get(
                                          'profile.kids' /* Kids */,
                                        ),
                                        maxLines: 2,
                                        style: GoogleFonts.inter(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          height: 1.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            final value = functions.effectiveProfileAttribute(
                                                'kids',
                                                widget!.kidsOverride,
                                                _model.profileKids);
                                            if (value == null || value.isEmpty) {
                                              return const SizedBox.shrink();
                                            }
                                            return Container(
                                              width: 150.0,
                                              alignment: AlignmentDirectional(1.0, 0.0),
                                              child: Text(
                                                value,
                                                textAlign: TextAlign.end,
                                                maxLines: 1,
                                                style: GoogleFonts.inter(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  height: 1.0,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          },
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: FloterTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ].divide(SizedBox(width: 6.0)),
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                  ProfileRelationshipPageWidget.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: FloterTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    9.0, 11.0, 9.0, 11.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        AppLabels.of(context).get(
                                          'profile.preferred_relationships' /* Preferred relationships */,
                                        ),
                                        maxLines: 2,
                                        style: GoogleFonts.inter(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          height: 1.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            final value = functions.effectiveProfileAttribute(
                                                'relationship_type',
                                                widget!
                                                    .relationshipTypeOverride,
                                                _model
                                                    .profileRelationshipType);
                                            if (value == null || value.isEmpty) {
                                              return const SizedBox.shrink();
                                            }
                                            return Container(
                                              width: 150.0,
                                              alignment: AlignmentDirectional(1.0, 0.0),
                                              child: Text(
                                                value,
                                                textAlign: TextAlign.end,
                                                maxLines: 1,
                                                style: GoogleFonts.inter(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  height: 1.0,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          },
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: FloterTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ].divide(SizedBox(width: 6.0)),
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                  ProfileReligionPageWidget.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: FloterTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    9.0, 11.0, 9.0, 11.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        AppLabels.of(context).get(
                                          'profile.beliefs' /* Beliefs */,
                                        ),
                                        maxLines: 2,
                                        style: GoogleFonts.inter(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          height: 1.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            final value = functions.effectiveProfileAttribute(
                                                'religion',
                                                widget!.religionOverride,
                                                _model.profileBeliefs);
                                            if (value == null || value.isEmpty) {
                                              return const SizedBox.shrink();
                                            }
                                            return Container(
                                              width: 150.0,
                                              alignment: AlignmentDirectional(1.0, 0.0),
                                              child: Text(
                                                value,
                                                textAlign: TextAlign.end,
                                                maxLines: 1,
                                                style: GoogleFonts.inter(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  height: 1.0,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          },
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: FloterTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ].divide(SizedBox(width: 6.0)),
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                  ProfileBodyTypePageWidget.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: FloterTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    9.0, 11.0, 9.0, 11.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        AppLabels.of(context).get(
                                          'profile.body_type' /* Body type */,
                                        ),
                                        maxLines: 2,
                                        style: GoogleFonts.inter(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          height: 1.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            final value = functions.effectiveProfileAttribute(
                                                'body_type',
                                                widget!.bodyTypeOverride,
                                                _model.profileBodyType);
                                            if (value == null || value.isEmpty) {
                                              return const SizedBox.shrink();
                                            }
                                            return Container(
                                              width: 150.0,
                                              alignment: AlignmentDirectional(1.0, 0.0),
                                              child: Text(
                                                value,
                                                textAlign: TextAlign.end,
                                                maxLines: 1,
                                                style: GoogleFonts.inter(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  height: 1.0,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          },
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: FloterTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ].divide(SizedBox(width: 6.0)),
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                  ProfileExercisePageWidget.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: FloterTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    9.0, 11.0, 9.0, 11.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        AppLabels.of(context).get(
                                          'profile.exercise' /* Exercise */,
                                        ),
                                        maxLines: 2,
                                        style: GoogleFonts.inter(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          height: 1.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            final value = functions.effectiveProfileAttribute(
                                                'exercise',
                                                widget!.exerciseOverride,
                                                _model.profileExercise);
                                            if (value == null || value.isEmpty) {
                                              return const SizedBox.shrink();
                                            }
                                            return Container(
                                              width: 150.0,
                                              alignment: AlignmentDirectional(1.0, 0.0),
                                              child: Text(
                                                value,
                                                textAlign: TextAlign.end,
                                                maxLines: 1,
                                                style: GoogleFonts.inter(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  height: 1.0,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          },
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: FloterTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ].divide(SizedBox(width: 6.0)),
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                  ProfileDrinkingPageWidget.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: FloterTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    9.0, 11.0, 9.0, 11.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        AppLabels.of(context).get(
                                          'profile.drinking' /* Drinking */,
                                        ),
                                        maxLines: 2,
                                        style: GoogleFonts.inter(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          height: 1.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            final value = functions.effectiveProfileAttribute(
                                                'drinking',
                                                widget!.drinkingOverride,
                                                _model.profileDrinking);
                                            if (value == null || value.isEmpty) {
                                              return const SizedBox.shrink();
                                            }
                                            return Container(
                                              width: 150.0,
                                              alignment: AlignmentDirectional(1.0, 0.0),
                                              child: Text(
                                                value,
                                                textAlign: TextAlign.end,
                                                maxLines: 1,
                                                style: GoogleFonts.inter(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  height: 1.0,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          },
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: FloterTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ].divide(SizedBox(width: 6.0)),
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                  ProfileSmokingPageWidget.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: FloterTheme.of(context).alternate,
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    9.0, 11.0, 9.0, 11.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        AppLabels.of(context).get(
                                          'profile.smoking' /* Smoking */,
                                        ),
                                        maxLines: 2,
                                        style: GoogleFonts.inter(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          height: 1.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Builder(
                                          builder: (context) {
                                            final value = functions.effectiveProfileAttribute(
                                                'smoking',
                                                widget!.smokingOverride,
                                                _model.profileSmoking);
                                            if (value == null || value.isEmpty) {
                                              return const SizedBox.shrink();
                                            }
                                            return Container(
                                              width: 150.0,
                                              alignment: AlignmentDirectional(1.0, 0.0),
                                              child: Text(
                                                value,
                                                textAlign: TextAlign.end,
                                                maxLines: 1,
                                                style: GoogleFonts.inter(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  height: 1.0,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          },
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: FloterTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                      ].divide(SizedBox(width: 6.0)),
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                              ),
                            ),
                          ),
                        ].divide(SizedBox(height: 18.0)),
                      ),
                    ),
                  ),
                ),
                wrapWithModel(
                  model: _model.nearsyBottomNavModel,
                  updateCallback: () => safeSetState(() {}),
                  child: NearsyBottomNavWidget(
                    activeTab: 'Profile',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
