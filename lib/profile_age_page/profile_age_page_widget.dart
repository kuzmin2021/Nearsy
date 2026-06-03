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
                return FTLocalizations.of(context).getText(
                  'yw24pjew' /* January */,
                );
              case 2:
                return FTLocalizations.of(context).getText(
                  'xqnx7l0f' /* February */,
                );
              case 3:
                return FTLocalizations.of(context).getText(
                  'ypwnkp0l' /* March */,
                );
              case 4:
                return FTLocalizations.of(context).getText(
                  'hb7et7lf' /* April */,
                );
              case 5:
                return FTLocalizations.of(context).getText(
                  'uodv0vde' /* May */,
                );
              case 6:
                return FTLocalizations.of(context).getText(
                  'xil6itt6' /* June */,
                );
              case 7:
                return FTLocalizations.of(context).getText(
                  'daazanz1' /* July */,
                );
              case 8:
                return FTLocalizations.of(context).getText(
                  'mewzycrj' /* August */,
                );
              case 9:
                return FTLocalizations.of(context).getText(
                  'mck9r90j' /* September */,
                );
              case 10:
                return FTLocalizations.of(context).getText(
                  '0tadc3ic' /* October */,
                );
              case 11:
                return FTLocalizations.of(context).getText(
                  '2f6ro706' /* November */,
                );
              case 12:
                return FTLocalizations.of(context).getText(
                  'vyx9usdo' /* December */,
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
                          FTLocalizations.of(context).getText(
                            'yfngd0ai' /* When were you born: */,
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
                                          FTLocalizations.of(context).getText(
                                            'evj11y9k' /* -- */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'hnoclb5h' /* 01 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'i85tsvb7' /* 02 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '544ol1ml' /* 03 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'a3av34yv' /* 04 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '81ksvrw7' /* 05 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '7qf0dsbo' /* 06 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'ilnr6qid' /* 07 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'vbpifo3j' /* 08 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '8jarvmm2' /* 09 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'yu89i5ty' /* 10 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'm0zx38hh' /* 11 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '20xpr3yy' /* 12 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'q7kpg6g7' /* 13 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'dorwptj7' /* 14 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'zbwxjkmb' /* 15 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '0dvgzzxk' /* 16 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'kt4o5r39' /* 17 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'pqahhuyj' /* 18 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'lsjhr27i' /* 19 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'lz46yfmf' /* 20 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'sqlukj38' /* 21 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'bwphn9sh' /* 22 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'n83rygwt' /* 23 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'ru7bpod1' /* 24 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'n77q723c' /* 25 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'jbzbwzyr' /* 26 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '93jznrsc' /* 27 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'w6fihphh' /* 28 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'vmvx9nth' /* 29 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'p1fe7s7h' /* 30 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'vaz558z1' /* 31 */,
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
                                            FTLocalizations.of(context).getText(
                                          'ffkcps64' /* Day */,
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
                                          FTLocalizations.of(context).getText(
                                            'w6gdyvm3' /* -- */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'yw24pjew' /* January */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'xqnx7l0f' /* February */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'ypwnkp0l' /* March */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'hb7et7lf' /* April */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'uodv0vde' /* May */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'xil6itt6' /* June */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'daazanz1' /* July */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'mewzycrj' /* August */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'mck9r90j' /* September */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '0tadc3ic' /* October */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '2f6ro706' /* November */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'vyx9usdo' /* December */,
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
                                            FTLocalizations.of(context).getText(
                                          'wro3xzbl' /* Month */,
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
                                          FTLocalizations.of(context).getText(
                                            '6nbq71q6' /* -- */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'c20ppisq' /* 2008 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'g24py9k7' /* 2007 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'loveqmon' /* 2006 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'cb74gq5d' /* 2005 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'lakasbmc' /* 2004 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'hz4476jx' /* 2003 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'wss64wkx' /* 2002 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'qcx81s4w' /* 2001 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'g60eifu5' /* 2000 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '2k3vaatx' /* 1999 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'mxr48o4z' /* 1998 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'l6lczap5' /* 1997 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '4fu848nm' /* 1996 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '236bfgsf' /* 1995 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'd1avq9cy' /* 1994 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '1nbt1eeu' /* 1993 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '8y3exir8' /* 1992 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'dtlwmlij' /* 1991 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'ox2affg6' /* 1990 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'p5qhzce4' /* 1989 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'obyf4hzv' /* 1988 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'l35b37ny' /* 1987 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'yg7n723u' /* 1986 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'kzf33ry6' /* 1985 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'gw4msgi4' /* 1984 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'lsd1exvt' /* 1983 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'q5iv982i' /* 1982 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'a87kkvle' /* 1981 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'ewu7ac53' /* 1980 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '2y2mdqiq' /* 1979 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'o5fop9uj' /* 1978 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'htl3x8t7' /* 1977 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'po7f6gcg' /* 1976 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'yj80jxq5' /* 1975 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'ylsru30s' /* 1974 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '4s8fkbc9' /* 1973 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '7pgfsedg' /* 1972 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'q8q7x2k5' /* 1971 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'uo3oc8cn' /* 1970 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'vq0war2f' /* 1969 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'ohfc9njg' /* 1968 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'insmnflw' /* 1967 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'voj4gjl6' /* 1966 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'zc6iv1gb' /* 1965 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'e4tbwikj' /* 1964 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'xg2oofva' /* 1963 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'dsjmkhp1' /* 1962 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            't2htqnuh' /* 1961 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '74hbtmwu' /* 1960 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'v429irv6' /* 1959 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'b6rrlvof' /* 1958 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'v9og6b0r' /* 1957 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '9bz27hpf' /* 1956 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'nb7x4dno' /* 1955 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '0c83m1qq' /* 1954 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'b7ipsprs' /* 1953 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '3sggpffy' /* 1952 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'g2sr6st0' /* 1951 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'cr9exfsb' /* 1950 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'zuyrui2c' /* 1949 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'mvs8blc4' /* 1948 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'r8n934c9' /* 1947 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'p3xh973v' /* 1946 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '98dw87hb' /* 1945 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '4fjsj5qy' /* 1944 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'kps1ikcc' /* 1943 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'k0eszrws' /* 1942 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '0i7qwcl7' /* 1941 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'vnyalti1' /* 1940 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'j3aaqeyq' /* 1939 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'mj75dg2j' /* 1938 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'qtwz8zuh' /* 1937 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'o7yfp5on' /* 1936 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'lssxvy06' /* 1935 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'lxd6pn86' /* 1934 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'qces6nnm' /* 1933 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'zql2izt3' /* 1932 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'uc62tpi0' /* 1931 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'nred6q16' /* 1930 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'd0p7yk1s' /* 1929 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'rday2dad' /* 1928 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'wxch9755' /* 1927 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'exam0qgm' /* 1926 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'vycvn9aq' /* 1925 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'q72yrkaf' /* 1924 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'xsl2ar2o' /* 1923 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '3d7v4qed' /* 1922 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'afysxs78' /* 1921 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'nwyawcg8' /* 1920 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'vx3k7jjk' /* 1919 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'mdkebgdf' /* 1918 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'euapssdd' /* 1917 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'g5plhn21' /* 1916 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'etmorxb0' /* 1915 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '9x0cysiv' /* 1914 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '2pcf6p0h' /* 1913 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'nus89wj5' /* 1912 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'my8pl9gv' /* 1911 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            'hkhxqi8g' /* 1910 */,
                                          ),
                                          FTLocalizations.of(context).getText(
                                            '1z59mvhk' /* 1909 */,
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
                                            FTLocalizations.of(context).getText(
                                          'hsmz61d9' /* Year */,
                                        ),
                                        labelTextStyle: TextStyle(),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 4.0)),
                                ),
                                Text(
                                  FTLocalizations.of(context).getText(
                                    'b0qb2m72' /* Optional */,
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
