import '/backend/supabase/supabase.dart';
import '/floter/floter_drop_down.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import '/floter/form_field_controller.dart';
import 'dart:ui';
import '/floter/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'profile_age_page_model.dart';
export 'profile_age_page_model.dart';

/// Edits the user birthday used for age display.
class ProfileAgePageWidget extends StatefulWidget {
  const ProfileAgePageWidget({super.key});

  static String routeName = 'ProfileAgePage';
  static String routePath = '/profile-age';

  @override
  State<ProfileAgePageWidget> createState() => _ProfileAgePageWidgetState();
}

class _ProfileAgePageWidgetState extends State<ProfileAgePageWidget> {
  late ProfileAgePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileAgePageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      void syncBirthdayDropdownControllers() {
        _model.profileBirthdayDayDropdownValue = _model.birthdayDay;
        _model.profileBirthdayDayDropdownValueController?.value =
            _model.birthdayDay;
        _model.profileBirthdayMonthDropdownValue = _model.birthdayMonth;
        _model.profileBirthdayMonthDropdownValueController?.value =
            _model.birthdayMonth;
        _model.profileBirthdayYearDropdownValue = _model.birthdayYear;
        _model.profileBirthdayYearDropdownValueController?.value =
            _model.birthdayYear;
      }

      final userId = SupaFlow.client.auth.currentUser?.id;
      if (userId == null || userId.isEmpty) {
        _model.birthday = '';
        _model.birthdayDay = '--';
        _model.birthdayMonth = '--';
        _model.birthdayYear = '--';
        syncBirthdayDropdownControllers();
        safeSetState(() {});
        return;
      }

      final profiles = await SupaFlow.client
          .from('profiles')
          .select('birthday')
          .eq('user_id', userId)
          .limit(1);
      final profile = profiles.isNotEmpty ? profiles.first : null;
      final raw = (profile?['birthday']?.toString() ?? '').trim();

      String cleanPart(String? value) {
        final text = (value ?? '').trim();
        return text.isEmpty ? '--' : text;
      }

      Map<String, String> parseBirthdayParts(String value) {
        final empty = {'day': '--', 'month': '--', 'year': '--'};
        if (value.isEmpty) {
          return empty;
        }
        final parsedDate = DateTime.tryParse(value);
        if (parsedDate != null) {
          String localizedMonthName(int month) {
            switch (month) {
              case 1:
                return AppLabels.of(context).get(
                  'months.january' /* January */,
                );
              case 2:
                return AppLabels.of(context).get(
                  'months.february' /* February */,
                );
              case 3:
                return AppLabels.of(context).get(
                  'months.march' /* March */,
                );
              case 4:
                return AppLabels.of(context).get(
                  'months.april' /* April */,
                );
              case 5:
                return AppLabels.of(context).get(
                  'months.may' /* May */,
                );
              case 6:
                return AppLabels.of(context).get(
                  'months.june' /* June */,
                );
              case 7:
                return AppLabels.of(context).get(
                  'months.july' /* July */,
                );
              case 8:
                return AppLabels.of(context).get(
                  'months.august' /* August */,
                );
              case 9:
                return AppLabels.of(context).get(
                  'months.september' /* September */,
                );
              case 10:
                return AppLabels.of(context).get(
                  'months.october' /* October */,
                );
              case 11:
                return AppLabels.of(context).get(
                  'months.november' /* November */,
                );
              case 12:
                return AppLabels.of(context).get(
                  'months.december' /* December */,
                );
              default:
                return '--';
            }
          }

          if (parsedDate.month < 1 || parsedDate.month > 12) {
            return empty;
          }
          return {
            'day': parsedDate.day.toString().padLeft(2, '0'),
            'month': localizedMonthName(parsedDate.month),
            'year': parsedDate.year.toString(),
          };
        }

        int monthNumber(String month) {
          final normalized = month.trim().toLowerCase();
          const months = {
            'january': 1,
            'jan': 1,
            '\u044f\u043d\u0432\u0430\u0440\u044c': 1,
            '\u044f\u043d\u0432\u0430\u0440\u044f': 1,
            'february': 2,
            'feb': 2,
            '\u0444\u0435\u0432\u0440\u0430\u043b\u044c': 2,
            '\u0444\u0435\u0432\u0440\u0430\u043b\u044f': 2,
            'march': 3,
            'mar': 3,
            '\u043c\u0430\u0440\u0442': 3,
            '\u043c\u0430\u0440\u0442\u0430': 3,
            'april': 4,
            'apr': 4,
            '\u0430\u043f\u0440\u0435\u043b\u044c': 4,
            '\u0430\u043f\u0440\u0435\u043b\u044f': 4,
            'may': 5,
            '\u043c\u0430\u0439': 5,
            '\u043c\u0430\u044f': 5,
            'june': 6,
            'jun': 6,
            '\u0438\u044e\u043d\u044c': 6,
            '\u0438\u044e\u043d\u044f': 6,
            'july': 7,
            'jul': 7,
            '\u0438\u044e\u043b\u044c': 7,
            '\u0438\u044e\u043b\u044f': 7,
            'august': 8,
            'aug': 8,
            '\u0430\u0432\u0433\u0443\u0441\u0442': 8,
            '\u0430\u0432\u0433\u0443\u0441\u0442\u0430': 8,
            'september': 9,
            'sep': 9,
            '\u0441\u0435\u043d\u0442\u044f\u0431\u0440\u044c': 9,
            '\u0441\u0435\u043d\u0442\u044f\u0431\u0440\u044f': 9,
            'october': 10,
            'oct': 10,
            '\u043e\u043a\u0442\u044f\u0431\u0440\u044c': 10,
            '\u043e\u043a\u0442\u044f\u0431\u0440\u044f': 10,
            'november': 11,
            'nov': 11,
            '\u043d\u043e\u044f\u0431\u0440\u044c': 11,
            '\u043d\u043e\u044f\u0431\u0440\u044f': 11,
            'december': 12,
            'dec': 12,
            '\u0434\u0435\u043a\u0430\u0431\u0440\u044c': 12,
            '\u0434\u0435\u043a\u0430\u0431\u0440\u044f': 12,
          };
          return months[normalized] ?? 0;
        }

        String monthName(int month) {
          const months = [
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December',
          ];
          if (month < 1 || month > 12) {
            return '--';
          }
          return months[month - 1];
        }

        final parts = value.split(RegExp(r'\s+'));
        if (parts.length >= 3) {
          final day = cleanPart(parts[0] == '--' ? '' : parts[0]);
          final month = monthNumber(parts[1]);
          return {
            'day': day.isEmpty ? '--' : day.padLeft(2, '0'),
            'month': monthName(month),
            'year': cleanPart(parts[2]),
          };
        }
        return empty;
      }

      _model.birthday = raw;
      final parts = parseBirthdayParts(raw);
      _model.birthdayDay = parts['day'];
      _model.birthdayMonth = parts['month'];
      _model.birthdayYear = parts['year'];
      syncBirthdayDropdownControllers();
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

                          String cleanBirthdayPart(String? raw) {
                            final value = (raw ?? '').trim();
                            return value == '--' ? '' : value;
                          }

                          int monthNumber(String raw) {
                            final normalized = raw.trim().toLowerCase();
                            const months = {
                              'january': 1,
                              'jan': 1,
                              'enero': 1,
                              'janvier': 1,
                              'يناير': 1,
                              'জানুয়ারি': 1,
                              'январь': 1,
                              'janeiro': 1,
                              'جنوری': 1,
                              'januari': 1,
                              'januar': 1,
                              '一月': 1,
                              'जानेवारी': 1,
                              'జనవరి': 1,
                              'ocak': 1,
                              'february': 2,
                              'feb': 2,
                              'febrero': 2,
                              'février': 2,
                              'فبراير': 2,
                              'ফেব্রুয়ারি': 2,
                              'февраль': 2,
                              'fevereiro': 2,
                              'فروری': 2,
                              'februari': 2,
                              'februar': 2,
                              '二月': 2,
                              'फेब्रुवारी': 2,
                              'ఫిబ్రవరి': 2,
                              'şubat': 2,
                              'march': 3,
                              'mar': 3,
                              'marzo': 3,
                              'mars': 3,
                              'مارس': 3,
                              'মার্চ': 3,
                              'март': 3,
                              'março': 3,
                              'مارچ': 3,
                              'maret': 3,
                              'märz': 3,
                              '三月': 3,
                              'మార్చి': 3,
                              'mart': 3,
                              'april': 4,
                              'apr': 4,
                              'abril': 4,
                              'avril': 4,
                              'أبريل': 4,
                              'এপ্রিল': 4,
                              'апрель': 4,
                              'اپریل': 4,
                              '4月': 4,
                              'एप्रिल': 4,
                              'ఏప్రిల్': 4,
                              'nisan': 4,
                              'may': 5,
                              'mayo': 5,
                              'mai': 5,
                              'مايو': 5,
                              'মে': 5,
                              'май': 5,
                              'maio': 5,
                              'مئی': 5,
                              'mei': 5,
                              '5月': 5,
                              'मे': 5,
                              'మే': 5,
                              'mayıs': 5,
                              'june': 6,
                              'jun': 6,
                              'junio': 6,
                              'juin': 6,
                              'يونيو': 6,
                              'জুন': 6,
                              'июнь': 6,
                              'junho': 6,
                              'جون': 6,
                              'juni': 6,
                              '6月': 6,
                              'జూన్': 6,
                              'haziran': 6,
                              'july': 7,
                              'jul': 7,
                              'julio': 7,
                              'juillet': 7,
                              'يوليو': 7,
                              'জুলাই': 7,
                              'июль': 7,
                              'julho': 7,
                              'جولائی': 7,
                              '7月': 7,
                              'जुलै': 7,
                              'జూలై': 7,
                              'temmuz': 7,
                              'august': 8,
                              'aug': 8,
                              'agosto': 8,
                              'août': 8,
                              'أغسطس': 8,
                              'আগস্ট': 8,
                              'август': 8,
                              'اگست': 8,
                              'agustus': 8,
                              '8月': 8,
                              'ऑगस्ट': 8,
                              'ఆగస్టు': 8,
                              'ağustos': 8,
                              'september': 9,
                              'sep': 9,
                              'septiembre': 9,
                              'septembre': 9,
                              'سبتمبر': 9,
                              'সেপ্টেম্বর': 9,
                              'сентябрь': 9,
                              'setembro': 9,
                              'ستمبر': 9,
                              '9月': 9,
                              'सप्टेंबर': 9,
                              'సెప్టెంబర్': 9,
                              'eylül': 9,
                              'october': 10,
                              'octubre': 10,
                              'octobre': 10,
                              'أكتوبر': 10,
                              'अक्टूबर': 10,
                              'অক্টোবর': 10,
                              'октябрь': 10,
                              'outubro': 10,
                              'اکتوبر': 10,
                              'oktober': 10,
                              '10月': 10,
                              'ऑक्टोबर': 10,
                              'అక్టోబర్': 10,
                              'ekim': 10,
                              'november': 11,
                              'noviembre': 11,
                              'novembre': 11,
                              'نوفمبر': 11,
                              'নভেম্বর': 11,
                              'ноябрь': 11,
                              'novembro': 11,
                              'نومبر': 11,
                              '11月': 11,
                              'नोव्हेंबर': 11,
                              'నవంబర్': 11,
                              'kasım': 11,
                              'december': 12,
                              'diciembre': 12,
                              'décembre': 12,
                              'ديسمبر': 12,
                              'ডিসেম্বর': 12,
                              'декабрь': 12,
                              'dezembro': 12,
                              'دسمبر': 12,
                              'desember': 12,
                              'dezember': 12,
                              '12月': 12,
                              'डिसेंबर': 12,
                              'డిసెంబర్': 12,
                              'aralık': 12,
                            };
                            return months[normalized] ?? 0;
                          }

                          String formatBirthdayForStorage(
                              String? day, String? month, String? year) {
                            final cleanDay = cleanBirthdayPart(day);
                            final cleanMonth = cleanBirthdayPart(month);
                            final cleanYear = cleanBirthdayPart(year);
                            if (cleanDay.isEmpty &&
                                cleanMonth.isEmpty &&
                                cleanYear.isEmpty) {
                              return '';
                            }
                            if (cleanMonth.isEmpty || cleanYear.isEmpty) {
                              return '';
                            }
                            final parsedMonth = monthNumber(cleanMonth);
                            final parsedYear = int.tryParse(cleanYear);
                            if (parsedMonth < 1 ||
                                parsedMonth > 12 ||
                                parsedYear == null ||
                                parsedYear < 1900) {
                              return '';
                            }

                            String monthName(int month) {
                              const months = [
                                'January',
                                'February',
                                'March',
                                'April',
                                'May',
                                'June',
                                'July',
                                'August',
                                'September',
                                'October',
                                'November',
                                'December',
                              ];
                              return months[month - 1];
                            }

                            if (cleanDay.isEmpty) {
                              return '-- ${monthName(parsedMonth)} $parsedYear';
                            }

                            final parsedDay = int.tryParse(cleanDay);
                            if (parsedDay == null ||
                                parsedDay < 1 ||
                                parsedDay > 31) {
                              return '';
                            }
                            final candidate =
                                DateTime(parsedYear, parsedMonth, parsedDay);
                            if (candidate.year != parsedYear ||
                                candidate.month != parsedMonth ||
                                candidate.day != parsedDay) {
                              return '';
                            }
                            final dayText =
                                parsedDay.toString().padLeft(2, '0');
                            final monthText =
                                parsedMonth.toString().padLeft(2, '0');
                            return '$parsedYear-$monthText-$dayText';
                          }

                          final value = formatBirthdayForStorage(
                            _model.birthdayDay,
                            _model.birthdayMonth,
                            _model.birthdayYear,
                          );
                          final updateValue = value.isEmpty ? null : value;

                          try {
                            await SupaFlow.client.from('profiles').upsert({
                              'user_id': userId,
                              'birthday': updateValue,
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
                                'birthdayOverride': serializeParam(
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
                            'profile_age.when_were_you_born' /* When were you born: */,
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
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 72.0,
                                      height: 32.0,
                                      child: FloterDropDown<String>(
                                        controller: _model
                                                .profileBirthdayDayDropdownValueController ??=
                                            FormFieldController<String>(
                                          _model.profileBirthdayDayDropdownValue ??=
                                              _model.birthdayDay,
                                        ),
                                        options: [
                                          AppLabels.of(context).get(
                                            'profile_age.day_placeholder' /* -- */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 01 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 02 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 03 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 04 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 05 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 06 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 07 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 08 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 09 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 10 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 11 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 12 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 13 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 14 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 15 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 16 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 17 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 18 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 19 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 20 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 21 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 22 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 23 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 24 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 25 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 26 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 27 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 28 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 29 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 30 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 31 */,
                                          )
                                        ],
                                        onChanged: (val) async {
                                          safeSetState(() => _model
                                                  .profileBirthdayDayDropdownValue =
                                              val);
                                          _model.birthdayDay = _model
                                              .profileBirthdayDayDropdownValue;
                                          safeSetState(() {});
                                          _model.birthday = functions
                                              .profileBirthdayFromParts(
                                                  _model.birthdayDay,
                                                  _model.birthdayMonth,
                                                  _model.birthdayYear);
                                          safeSetState(() {});
                                        },
                                        textStyle: FloterTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FloterTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FloterTheme.of(context)
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
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: FloterTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                        fillColor: FloterTheme.of(context)
                                            .secondaryBackground,
                                        elevation: 2.0,
                                        borderColor:
                                            FloterTheme.of(context)
                                                .alternate,
                                        borderWidth: 1.0,
                                        borderRadius: 8.0,
                                        margin: EdgeInsetsDirectional.fromSTEB(
                                            12.0, 0.0, 12.0, 0.0),
                                        hidesUnderline: true,
                                        isOverButton: false,
                                        isSearchable: false,
                                        isMultiSelect: false,
                                        labelText:
                                            AppLabels.of(context).get(
                                          'profile_age.day' /* Day */,
                                        ),
                                        labelTextStyle: TextStyle(),
                                      ),
                                    ),
                                    Container(
                                      width: 113.0,
                                      height: 32.0,
                                      child: FloterDropDown<String>(
                                        controller: _model
                                                .profileBirthdayMonthDropdownValueController ??=
                                            FormFieldController<String>(
                                          _model.profileBirthdayMonthDropdownValue ??=
                                              _model.birthdayMonth,
                                        ),
                                        options: [
                                          AppLabels.of(context).get(
                                            'profile_age.month_placeholder' /* -- */,
                                          ),
                                          AppLabels.of(context).get(
                                            'months.january' /* January */,
                                          ),
                                          AppLabels.of(context).get(
                                            'months.february' /* February */,
                                          ),
                                          AppLabels.of(context).get(
                                            'months.march' /* March */,
                                          ),
                                          AppLabels.of(context).get(
                                            'months.april' /* April */,
                                          ),
                                          AppLabels.of(context).get(
                                            'months.may' /* May */,
                                          ),
                                          AppLabels.of(context).get(
                                            'months.june' /* June */,
                                          ),
                                          AppLabels.of(context).get(
                                            'months.july' /* July */,
                                          ),
                                          AppLabels.of(context).get(
                                            'months.august' /* August */,
                                          ),
                                          AppLabels.of(context).get(
                                            'months.september' /* September */,
                                          ),
                                          AppLabels.of(context).get(
                                            'months.october' /* October */,
                                          ),
                                          AppLabels.of(context).get(
                                            'months.november' /* November */,
                                          ),
                                          AppLabels.of(context).get(
                                            'months.december' /* December */,
                                          )
                                        ],
                                        onChanged: (val) async {
                                          safeSetState(() => _model
                                                  .profileBirthdayMonthDropdownValue =
                                              val);
                                          _model.birthdayMonth = _model
                                              .profileBirthdayMonthDropdownValue;
                                          safeSetState(() {});
                                          _model.birthday = functions
                                              .profileBirthdayFromParts(
                                                  _model.birthdayDay,
                                                  _model.birthdayMonth,
                                                  _model.birthdayYear);
                                          safeSetState(() {});
                                        },
                                        textStyle: FloterTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FloterTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FloterTheme.of(context)
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
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: FloterTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                        fillColor: FloterTheme.of(context)
                                            .secondaryBackground,
                                        elevation: 2.0,
                                        borderColor:
                                            FloterTheme.of(context)
                                                .alternate,
                                        borderWidth: 1.0,
                                        borderRadius: 8.0,
                                        margin: EdgeInsetsDirectional.fromSTEB(
                                            12.0, 0.0, 12.0, 0.0),
                                        hidesUnderline: true,
                                        isOverButton: false,
                                        isSearchable: false,
                                        isMultiSelect: false,
                                        labelText:
                                            AppLabels.of(context).get(
                                          'profile_age.month' /* Month */,
                                        ),
                                        labelTextStyle: TextStyle(),
                                      ),
                                    ),
                                    Container(
                                      width: 96.0,
                                      height: 32.0,
                                      child: FloterDropDown<String>(
                                        controller: _model
                                                .profileBirthdayYearDropdownValueController ??=
                                            FormFieldController<String>(
                                          _model.profileBirthdayYearDropdownValue ??=
                                              _model.birthdayYear,
                                        ),
                                        options: [
                                          AppLabels.of(context).get(
                                            'profile_age.year_placeholder' /* -- */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 2008 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 2007 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 2006 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 2005 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 2004 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 2003 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 2002 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 2001 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 2000 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1999 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1998 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1997 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1996 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1995 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1994 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1993 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1992 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1991 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1990 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1989 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1988 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1987 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1986 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1985 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1984 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1983 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1982 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1981 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1980 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1979 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1978 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1977 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1976 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1975 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1974 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1973 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1972 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1971 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1970 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1969 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1968 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1967 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1966 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1965 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1964 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1963 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1962 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1961 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1960 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1959 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1958 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1957 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1956 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1955 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1954 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1953 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1952 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1951 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1950 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1949 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1948 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1947 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1946 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1945 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1944 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1943 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1942 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1941 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1940 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1939 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1938 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1937 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1936 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1935 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1934 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1933 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1932 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1931 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1930 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1929 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1928 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1927 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1926 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1925 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1924 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1923 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1922 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1921 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1920 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1919 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1918 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1917 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1916 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1915 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1914 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1913 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1912 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1911 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1910 */,
                                          ),
                                          AppLabels.of(context).get(
                                            'skip' /* 1909 */,
                                          )
                                        ],
                                        onChanged: (val) async {
                                          safeSetState(() => _model
                                                  .profileBirthdayYearDropdownValue =
                                              val);
                                          _model.birthdayYear = _model
                                              .profileBirthdayYearDropdownValue;
                                          safeSetState(() {});
                                          _model.birthday = functions
                                              .profileBirthdayFromParts(
                                                  _model.birthdayDay,
                                                  _model.birthdayMonth,
                                                  _model.birthdayYear);
                                          safeSetState(() {});
                                        },
                                        textStyle: FloterTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FloterTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FloterTheme.of(context)
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
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: FloterTheme.of(context)
                                              .secondaryText,
                                          size: 24.0,
                                        ),
                                        fillColor: FloterTheme.of(context)
                                            .secondaryBackground,
                                        elevation: 2.0,
                                        borderColor:
                                            FloterTheme.of(context)
                                                .alternate,
                                        borderWidth: 1.0,
                                        borderRadius: 8.0,
                                        margin: EdgeInsetsDirectional.fromSTEB(
                                            12.0, 0.0, 12.0, 0.0),
                                        hidesUnderline: true,
                                        isOverButton: false,
                                        isSearchable: false,
                                        isMultiSelect: false,
                                        labelText:
                                            AppLabels.of(context).get(
                                          'profile_age.year' /* Year */,
                                        ),
                                        labelTextStyle: TextStyle(),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 4.0)),
                                ),
                                Text(
                                  AppLabels.of(context).get(
                                    'profile_age.optional' /* Optional */,
                                  ),
                                  style: FloterTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FloterTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FloterTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color: FloterTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FloterTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FloterTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(height: 3.0)),
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
