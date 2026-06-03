import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

/// Checks whether a profile name is non-empty, under 20 chars, and contains
/// letters.
bool? isValidProfileName(String? name) {
  final trimmed = (name ?? '').trim();
  if (trimmed.isEmpty) {
    return false;
  }
  if (trimmed.runes.length > 20) {
    return false;
  }
  return RegExp(r'[A-Za-z\u0400-\u04FF]').hasMatch(trimmed);
}

/// Reads a string field from the first loaded profile row.
String? profileStringField(
  dynamic rows,
  String? field,
) {
  if (rows is! List || rows.isEmpty || field == null) {
    return '';
  }
  final row = rows.first;
  final value = row is SupabaseDataRow ? row.getField<String>(field) : null;
  return value ?? '';
}

/// Reads a boolean field from the first loaded profile row.
bool? profileBoolField(
  dynamic rows,
  String? field,
) {
  if (rows is! List || rows.isEmpty || field == null) {
    return false;
  }
  final row = rows.first;
  final value = row is SupabaseDataRow ? row.getField<bool>(field) : null;
  return value ?? false;
}

/// Compacts ordered additional profile photos into grid slots.
List<String>? compactUserPhotoSlots(dynamic rows) {
  final slots = <String>[];
  if (rows is List) {
    for (final row in rows) {
      final url =
          row is SupabaseDataRow ? row.getField<String>('photo_url') : null;
      if (url != null && url.trim().isNotEmpty) {
        slots.add(url);
      }
      if (slots.length >= 6) {
        break;
      }
    }
  }
  final visibleSlots = slots.length < 3 ? 3 : 6;
  slots.add('__add_photo__');
  while (slots.length < visibleSlots) {
    slots.add('__empty_photo__');
  }
  return slots;
}

/// Checks whether a profile photo grid slot contains a real photo URL.
bool? isFilledProfilePhotoSlot(String? slot) {
  final value = (slot ?? '').trim();
  return value.isNotEmpty &&
      value != '__add_photo__' &&
      value != '__empty_photo__';
}

/// Formats profile text length as a max-length counter.
String? profileTextCounter(
  String? text,
  int? max,
) {
  final current = (text ?? '').runes.length;
  return '$current/$max';
}

/// Chooses a fresh profile attribute override before loaded state and
/// localizes fixed values.
String? effectiveProfileAttribute(
  String? attribute,
  String? overrideValue,
  String? loadedValue,
) {
  String clean(dynamic value) {
    if (value == null) {
      return '';
    }
    return value.toString().trim();
  }

  String canonical(dynamic value) {
    final text = clean(value).toLowerCase();
    if (text.isEmpty) {
      return '';
    }
    final normalized = text
        .replaceAll("'", '')
        .replaceAll(RegExp(r'[^a-z0-9\u0400-\u04FF]+'), '_')
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

  final attr = clean(attribute);
  final overrideText = clean(overrideValue);
  final loadedText = clean(loadedValue);
  if (overrideText == '__cleared_profile_attribute__') {
    return '';
  }
  final value = overrideText.isNotEmpty ? overrideText : loadedText;
  if (value.isEmpty) {
    return '';
  }

  int monthNumber(String month) {
    final normalized = month.trim().toLowerCase();
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

  String ageFromBirthday(String birthday) {
    var day = 0;
    var month = 0;
    var year = 0;
    var dayKnown = false;

    final parsedDate = DateTime.tryParse(birthday);
    if (parsedDate != null) {
      year = parsedDate.year;
      month = parsedDate.month;
      day = parsedDate.day;
      dayKnown = true;
    } else if (RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})').hasMatch(birthday)) {
      final iso = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})').firstMatch(birthday)!;
      year = int.tryParse(iso.group(1)!) ?? 0;
      month = int.tryParse(iso.group(2)!) ?? 0;
      day = int.tryParse(iso.group(3)!) ?? 0;
      dayKnown = true;
    } else {
      final numeric = RegExp(
        r'^(\d{1,2})[./-](\d{1,2})[./-](\d{4})$',
      ).firstMatch(birthday);
      if (numeric != null) {
        day = int.tryParse(numeric.group(1)!) ?? 0;
        month = int.tryParse(numeric.group(2)!) ?? 0;
        year = int.tryParse(numeric.group(3)!) ?? 0;
        dayKnown = true;
      }
      final parts = birthday.split(RegExp(r'\s+'));
      if (year <= 0 && parts.length >= 3) {
        dayKnown = parts[0] != '--';
        day = dayKnown ? int.tryParse(parts[0]) ?? 0 : 1;
        month = monthNumber(parts[1]);
        year = int.tryParse(parts[2]) ?? 0;
      }
    }

    if (year <= 0 || month < 1 || month > 12 || day < 1 || day > 31) {
      return '';
    }
    final now = DateTime.now();
    var age = now.year - year;
    final hasBirthdayPassed = now.month > month ||
        (now.month == month && (!dayKnown || now.day >= day));
    if (!hasBirthdayPassed) {
      age -= 1;
    }
    if (age < 0 || age > 130) {
      return '';
    }
    return age.toString();
  }

  if (attr == 'birthday') {
    return ageFromBirthday(value);
  }

  final normalized = canonical(value);
  const labels = {
    'gender': {
      'woman': '\u0416\u0435\u043d\u0449\u0438\u043d\u0430',
      'female': '\u0416\u0435\u043d\u0449\u0438\u043d\u0430',
      'man': '\u041c\u0443\u0436\u0447\u0438\u043d\u0430',
      'male': '\u041c\u0443\u0436\u0447\u0438\u043d\u0430',
      'other': '\u0414\u0440\u0443\u0433\u043e\u0435',
      'non_binary':
          '\u041d\u0435\u0431\u0438\u043d\u0430\u0440\u043d\u044b\u0439',
      'non-binary':
          '\u041d\u0435\u0431\u0438\u043d\u0430\u0440\u043d\u044b\u0439',
      'nonbinary':
          '\u041d\u0435\u0431\u0438\u043d\u0430\u0440\u043d\u044b\u0439',
    },
    'education': {
      'high_school':
          '\u0421\u0440\u0435\u0434\u043d\u044f\u044f \u0448\u043a\u043e\u043b\u0430',
      'currently_studying':
          '\u0423\u0447\u0443\u0441\u044c \u0441\u0435\u0439\u0447\u0430\u0441',
      'trade_qualification':
          '\u041f\u0440\u043e\u0444\u0435\u0441\u0441\u0438\u043e\u043d\u0430\u043b\u044c\u043d\u043e\u0435 \u043e\u0431\u0440\u0430\u0437\u043e\u0432\u0430\u043d\u0438\u0435',
      'bachelors_degree':
          '\u0411\u0430\u043a\u0430\u043b\u0430\u0432\u0440\u0438\u0430\u0442',
      'master_degree':
          '\u041c\u0430\u0433\u0438\u0441\u0442\u0440\u0430\u0442\u0443\u0440\u0430',
      'masters_degree':
          '\u041c\u0430\u0433\u0438\u0441\u0442\u0440\u0430\u0442\u0443\u0440\u0430',
      'doctorate_phd':
          '\u0414\u043e\u043a\u0442\u043e\u0440\u0430\u043d\u0442\u0443\u0440\u0430 / PhD',
      'postgraduate':
          '\u041f\u043e\u0441\u0442\u0434\u0438\u043f\u043b\u043e\u043c\u043d\u043e\u0435 \u043e\u0431\u0440\u0430\u0437\u043e\u0432\u0430\u043d\u0438\u0435',
      'other': '\u0414\u0440\u0443\u0433\u043e\u0435',
      'prefer_not_to_say':
          '\u041f\u0440\u0435\u0434\u043f\u043e\u0447\u0438\u0442\u0430\u044e \u043d\u0435 \u0433\u043e\u0432\u043e\u0440\u0438\u0442\u044c',
    },
    'kids': {
      'true': '\u0415\u0441\u0442\u044c \u0434\u0435\u0442\u0438',
      'false': '\u041d\u0435\u0442 \u0434\u0435\u0442\u0435\u0439',
      'yes': '\u0415\u0441\u0442\u044c \u0434\u0435\u0442\u0438',
      'no': '\u041d\u0435\u0442 \u0434\u0435\u0442\u0435\u0439',
      'i_have_kids': '\u0415\u0441\u0442\u044c \u0434\u0435\u0442\u0438',
      'i_dont_have_kids': '\u041d\u0435\u0442 \u0434\u0435\u0442\u0435\u0439',
      'i_have': '\u0415\u0441\u0442\u044c \u0434\u0435\u0442\u0438',
      'i_dont_have': '\u041d\u0435\u0442 \u0434\u0435\u0442\u0435\u0439',
      'prefer_not_to_say':
          '\u041f\u0440\u0435\u0434\u043f\u043e\u0447\u0438\u0442\u0430\u044e \u043d\u0435 \u0433\u043e\u0432\u043e\u0440\u0438\u0442\u044c',
    },
    'relationship_type': {
      'something_serious':
          '\u0421\u0435\u0440\u044c\u0435\u0437\u043d\u044b\u0435 \u043e\u0442\u043d\u043e\u0448\u0435\u043d\u0438\u044f',
      'just_dating':
          '\u041f\u0440\u043e\u0441\u0442\u043e \u0441\u0432\u0438\u0434\u0430\u043d\u0438\u044f',
      'just_fun':
          '\u041f\u0440\u043e\u0441\u0442\u043e \u0432\u0435\u0441\u0435\u043b\u044c\u0435',
      'open_to_anything':
          '\u041e\u0442\u043a\u0440\u044b\u0442(\u0430) \u043a \u0440\u0430\u0437\u043d\u043e\u043c\u0443',
      'not_sure': '\u041d\u0435 \u0443\u0432\u0435\u0440\u0435\u043d(\u0430)',
    },
    'religion': {
      'agnostic': '\u0410\u0433\u043d\u043e\u0441\u0442\u0438\u043a',
      'atheist': '\u0410\u0442\u0435\u0438\u0441\u0442',
      'buddhist': '\u0411\u0443\u0434\u0434\u0438\u0437\u043c',
      'christian':
          '\u0425\u0440\u0438\u0441\u0442\u0438\u0430\u043d\u0441\u0442\u0432\u043e',
      'hindu': '\u0418\u043d\u0434\u0443\u0438\u0437\u043c',
      'jewish': '\u0418\u0443\u0434\u0430\u0438\u0437\u043c',
      'muslim': '\u0418\u0441\u043b\u0430\u043c',
      'sikh': '\u0421\u0438\u043a\u0445\u0438\u0437\u043c',
      'spiritual':
          '\u0414\u0443\u0445\u043e\u0432\u043d\u044b\u0435 \u0432\u0437\u0433\u043b\u044f\u0434\u044b',
      'other': '\u0414\u0440\u0443\u0433\u043e\u0435',
    },
    'body_type': {
      'slim': '\u0421\u0442\u0440\u043e\u0439\u043d\u043e\u0435',
      'lean': '\u041f\u043e\u0434\u0442\u044f\u043d\u0443\u0442\u043e\u0435',
      'average': '\u0421\u0440\u0435\u0434\u043d\u0435\u0435',
      'fit': '\u0412 \u0444\u043e\u0440\u043c\u0435',
      'athletic':
          '\u0421\u043f\u043e\u0440\u0442\u0438\u0432\u043d\u043e\u0435',
      'muscular':
          '\u041c\u0443\u0441\u043a\u0443\u043b\u0438\u0441\u0442\u043e\u0435',
      'broad': '\u041a\u0440\u0443\u043f\u043d\u043e\u0435',
      'stocky': '\u041f\u043b\u043e\u0442\u043d\u043e\u0435',
      'bigger':
          '\u0411\u043e\u043b\u044c\u0448\u0435 \u0441\u0440\u0435\u0434\u043d\u0435\u0433\u043e',
      'curvy': '\u0421 \u0444\u043e\u0440\u043c\u0430\u043c\u0438',
      'prefer_not_to_say':
          '\u041f\u0440\u0435\u0434\u043f\u043e\u0447\u0438\u0442\u0430\u044e \u043d\u0435 \u0433\u043e\u0432\u043e\u0440\u0438\u0442\u044c',
    },
    'exercise': {
      'regularly': '\u0420\u0435\u0433\u0443\u043b\u044f\u0440\u043d\u043e',
      'occasionally': '\u0418\u043d\u043e\u0433\u0434\u0430',
      'rarely': '\u0420\u0435\u0434\u043a\u043e',
      'never': '\u041d\u0438\u043a\u043e\u0433\u0434\u0430',
    },
    'drinking': {
      'yes': '\u0414\u0430',
      'occasionally': '\u0418\u043d\u043e\u0433\u0434\u0430',
      'rarely': '\u0420\u0435\u0434\u043a\u043e',
      'no': '\u041d\u0435\u0442',
      'stopped_for_now':
          '\u041f\u043e\u043a\u0430 \u043d\u0435 \u043f\u044c\u044e',
    },
    'smoking': {
      'yes': '\u0414\u0430',
      'sometimes': '\u0418\u043d\u043e\u0433\u0434\u0430',
      'no': '\u041d\u0435\u0442',
      'trying_to_quit':
          '\u041f\u044b\u0442\u0430\u044e\u0441\u044c \u0431\u0440\u043e\u0441\u0438\u0442\u044c',
    },
  };
  return labels[attr]?[normalized] ?? value;
}

/// Formats birthday dropdown selections, allowing an empty day.
String? profileBirthdayFromParts(
  String? day,
  String? month,
  String? year,
) {
  String clean(String? value) {
    final text = (value ?? '').trim();
    return text == '--' ? '' : text;
  }

  final cleanDay = clean(day);
  final cleanMonth = clean(month);
  final cleanYear = clean(year);
  if (cleanDay.isEmpty && cleanMonth.isEmpty && cleanYear.isEmpty) {
    return '';
  }
  if (cleanMonth.isEmpty || cleanYear.isEmpty) {
    return '';
  }
  if (cleanDay.isEmpty) {
    return '-- $cleanMonth $cleanYear';
  }
  return '$cleanDay $cleanMonth $cleanYear';
}

/// Checks whether a profile language key is selected in the local list.
bool? profileLanguageSelected(
  List<String>? languages,
  String? language,
) {
  String clean(dynamic value) {
    return (value?.toString() ?? '').trim().toLowerCase();
  }

  String canonical(dynamic value) {
    final text = clean(value);
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
      '\u0430\u043d\u0433\u043b\u0438\u0439\u0441\u043a\u0438\u0439': 'english',
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

  final target = canonical(language);
  if (target.isEmpty || languages == null) {
    return false;
  }
  for (final item in languages) {
    if (canonical(item) == target) {
      return true;
    }
  }
  return false;
}

/// Formats profile language keys as a comma-separated localized list.
String? profileLanguagesDisplay(List<String>? languages) {
  String clean(dynamic value) {
    return (value?.toString() ?? '').trim().toLowerCase();
  }

  String canonical(dynamic value) {
    final text = clean(value);
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
      '\u0430\u043d\u0433\u043b\u0438\u0439\u0441\u043a\u0438\u0439': 'english',
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

  String localeKey() {
    final deviceLocale = WidgetsBinding
        .instance.platformDispatcher.locale.languageCode
        .toLowerCase();
    if (deviceLocale.isNotEmpty && deviceLocale != 'und') {
      return deviceLocale;
    }
    final intlLocale = Intl.getCurrentLocale().toLowerCase();
    return intlLocale.split(RegExp(r'[-_]')).first;
  }

  final seen = <String>{};
  final output = <String>[];
  final isRu = localeKey() == 'ru';
  for (final item in languages ?? const <String>[]) {
    final rawParts = item
        .toString()
        .trim()
        .replaceAll(RegExp(r'^[\[\{]+|[\]\}]+$'), '')
        .split(RegExp(r'[,;]'));
    for (final part in rawParts) {
      final key = canonical(part);
      if (key.isEmpty || !seen.add(key)) {
        continue;
      }
      var label = key;
      if (isRu) {
        if (key == 'english') {
          label =
              '\u0410\u043d\u0433\u043b\u0438\u0439\u0441\u043a\u0438\u0439';
        } else if (key == 'russian') {
          label = '\u0420\u0443\u0441\u0441\u043a\u0438\u0439';
        } else if (key == 'spanish') {
          label = '\u0418\u0441\u043f\u0430\u043d\u0441\u043a\u0438\u0439';
        } else if (key == 'french') {
          label =
              '\u0424\u0440\u0430\u043d\u0446\u0443\u0437\u0441\u043a\u0438\u0439';
        } else if (key == 'german') {
          label = '\u041d\u0435\u043c\u0435\u0446\u043a\u0438\u0439';
        } else if (key == 'italian') {
          label =
              '\u0418\u0442\u0430\u043b\u044c\u044f\u043d\u0441\u043a\u0438\u0439';
        } else if (key == 'portuguese') {
          label =
              '\u041f\u043e\u0440\u0442\u0443\u0433\u0430\u043b\u044c\u0441\u043a\u0438\u0439';
        } else if (key == 'chinese') {
          label = '\u041a\u0438\u0442\u0430\u0439\u0441\u043a\u0438\u0439';
        } else if (key == 'japanese') {
          label = '\u042f\u043f\u043e\u043d\u0441\u043a\u0438\u0439';
        } else if (key == 'korean') {
          label = '\u041a\u043e\u0440\u0435\u0439\u0441\u043a\u0438\u0439';
        } else if (key == 'arabic') {
          label = '\u0410\u0440\u0430\u0431\u0441\u043a\u0438\u0439';
        } else if (key == 'turkish') {
          label = '\u0422\u0443\u0440\u0435\u0446\u043a\u0438\u0439';
        } else if (key == 'ukrainian') {
          label =
              '\u0423\u043a\u0440\u0430\u0438\u043d\u0441\u043a\u0438\u0439';
        } else if (key == 'polish') {
          label = '\u041f\u043e\u043b\u044c\u0441\u043a\u0438\u0439';
        } else if (key == 'dutch') {
          label =
              '\u041d\u0438\u0434\u0435\u0440\u043b\u0430\u043d\u0434\u0441\u043a\u0438\u0439';
        } else if (key == 'hindi') {
          label = '\u0425\u0438\u043d\u0434\u0438';
        } else if (key == 'hebrew') {
          label = '\u0418\u0432\u0440\u0438\u0442';
        } else if (key == 'swedish') {
          label = '\u0428\u0432\u0435\u0434\u0441\u043a\u0438\u0439';
        } else if (key == 'norwegian') {
          label =
              '\u041d\u043e\u0440\u0432\u0435\u0436\u0441\u043a\u0438\u0439';
        } else if (key == 'finnish') {
          label = '\u0424\u0438\u043d\u0441\u043a\u0438\u0439';
        }
      } else {
        if (key == 'english') {
          label = 'English';
        } else if (key == 'russian') {
          label = 'Russian';
        } else if (key == 'spanish') {
          label = 'Spanish';
        } else if (key == 'french') {
          label = 'French';
        } else if (key == 'german') {
          label = 'German';
        } else if (key == 'italian') {
          label = 'Italian';
        } else if (key == 'portuguese') {
          label = 'Portuguese';
        } else if (key == 'chinese') {
          label = 'Chinese';
        } else if (key == 'japanese') {
          label = 'Japanese';
        } else if (key == 'korean') {
          label = 'Korean';
        } else if (key == 'arabic') {
          label = 'Arabic';
        } else if (key == 'turkish') {
          label = 'Turkish';
        } else if (key == 'ukrainian') {
          label = 'Ukrainian';
        } else if (key == 'polish') {
          label = 'Polish';
        } else if (key == 'dutch') {
          label = 'Dutch';
        } else if (key == 'hindi') {
          label = 'Hindi';
        } else if (key == 'hebrew') {
          label = 'Hebrew';
        } else if (key == 'swedish') {
          label = 'Swedish';
        } else if (key == 'norwegian') {
          label = 'Norwegian';
        } else if (key == 'finnish') {
          label = 'Finnish';
        }
      }
      output.add(label);
    }
  }
  return output.join(', ');
}

/// Returns a localized label for a single canonical language key.
String? profileLanguageLabel(String? language) {
  String clean(dynamic value) {
    return (value?.toString() ?? '').trim().toLowerCase();
  }

  String canonical(dynamic value) {
    final text = clean(value);
    if (text.isEmpty) {
      return '';
    }
    final normalized = text
        .replaceAll("'", '')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
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
      '\u0430\u043d\u0433\u043b\u0438\u0439\u0441\u043a\u0438\u0439': 'english',
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

  String localeKey() {
    final deviceLocale = WidgetsBinding
        .instance.platformDispatcher.locale.languageCode
        .toLowerCase();
    if (deviceLocale.isNotEmpty && deviceLocale != 'und') {
      return deviceLocale;
    }
    final intlLocale = Intl.getCurrentLocale().toLowerCase();
    return intlLocale.split(RegExp(r'[-_]')).first;
  }

  const en = {
    'english': 'English',
    'russian': 'Russian',
    'spanish': 'Spanish',
    'french': 'French',
    'german': 'German',
    'italian': 'Italian',
    'portuguese': 'Portuguese',
    'chinese': 'Chinese',
    'japanese': 'Japanese',
    'korean': 'Korean',
    'arabic': 'Arabic',
    'turkish': 'Turkish',
    'ukrainian': 'Ukrainian',
    'polish': 'Polish',
    'dutch': 'Dutch',
    'hindi': 'Hindi',
    'hebrew': 'Hebrew',
    'swedish': 'Swedish',
    'norwegian': 'Norwegian',
    'finnish': 'Finnish',
  };
  const ru = {
    'english': '\u0410\u043d\u0433\u043b\u0438\u0439\u0441\u043a\u0438\u0439',
    'russian': '\u0420\u0443\u0441\u0441\u043a\u0438\u0439',
    'spanish': '\u0418\u0441\u043f\u0430\u043d\u0441\u043a\u0438\u0439',
    'french':
        '\u0424\u0440\u0430\u043d\u0446\u0443\u0437\u0441\u043a\u0438\u0439',
    'german': '\u041d\u0435\u043c\u0435\u0446\u043a\u0438\u0439',
    'italian':
        '\u0418\u0442\u0430\u043b\u044c\u044f\u043d\u0441\u043a\u0438\u0439',
    'portuguese':
        '\u041f\u043e\u0440\u0442\u0443\u0433\u0430\u043b\u044c\u0441\u043a\u0438\u0439',
    'chinese': '\u041a\u0438\u0442\u0430\u0439\u0441\u043a\u0438\u0439',
    'japanese': '\u042f\u043f\u043e\u043d\u0441\u043a\u0438\u0439',
    'korean': '\u041a\u043e\u0440\u0435\u0439\u0441\u043a\u0438\u0439',
    'arabic': '\u0410\u0440\u0430\u0431\u0441\u043a\u0438\u0439',
    'turkish': '\u0422\u0443\u0440\u0435\u0446\u043a\u0438\u0439',
    'ukrainian': '\u0423\u043a\u0440\u0430\u0438\u043d\u0441\u043a\u0438\u0439',
    'polish': '\u041f\u043e\u043b\u044c\u0441\u043a\u0438\u0439',
    'dutch':
        '\u041d\u0438\u0434\u0435\u0440\u043b\u0430\u043d\u0434\u0441\u043a\u0438\u0439',
    'hindi': '\u0425\u0438\u043d\u0434\u0438',
    'hebrew': '\u0418\u0432\u0440\u0438\u0442',
    'swedish': '\u0428\u0432\u0435\u0434\u0441\u043a\u0438\u0439',
    'norwegian': '\u041d\u043e\u0440\u0432\u0435\u0436\u0441\u043a\u0438\u0439',
    'finnish': '\u0424\u0438\u043d\u0441\u043a\u0438\u0439',
  };
  final labelsByLocale = {'en': en, 'ru': ru};
  final labels = labelsByLocale[localeKey()] ?? en;
  final key = canonical(language);
  if (localeKey() == 'ru') {
    const ruFixed = {
      'english': '\u0410\u043d\u0433\u043b\u0438\u0439\u0441\u043a\u0438\u0439',
      'russian': '\u0420\u0443\u0441\u0441\u043a\u0438\u0439',
      'spanish': '\u0418\u0441\u043f\u0430\u043d\u0441\u043a\u0438\u0439',
      'french':
          '\u0424\u0440\u0430\u043d\u0446\u0443\u0437\u0441\u043a\u0438\u0439',
      'german': '\u041d\u0435\u043c\u0435\u0446\u043a\u0438\u0439',
      'italian':
          '\u0418\u0442\u0430\u043b\u044c\u044f\u043d\u0441\u043a\u0438\u0439',
      'portuguese':
          '\u041f\u043e\u0440\u0442\u0443\u0433\u0430\u043b\u044c\u0441\u043a\u0438\u0439',
      'chinese': '\u041a\u0438\u0442\u0430\u0439\u0441\u043a\u0438\u0439',
      'japanese': '\u042f\u043f\u043e\u043d\u0441\u043a\u0438\u0439',
      'korean': '\u041a\u043e\u0440\u0435\u0439\u0441\u043a\u0438\u0439',
      'arabic': '\u0410\u0440\u0430\u0431\u0441\u043a\u0438\u0439',
      'turkish': '\u0422\u0443\u0440\u0435\u0446\u043a\u0438\u0439',
      'ukrainian':
          '\u0423\u043a\u0440\u0430\u0438\u043d\u0441\u043a\u0438\u0439',
      'polish': '\u041f\u043e\u043b\u044c\u0441\u043a\u0438\u0439',
      'dutch':
          '\u041d\u0438\u0434\u0435\u0440\u043b\u0430\u043d\u0434\u0441\u043a\u0438\u0439',
      'hindi': '\u0425\u0438\u043d\u0434\u0438',
      'hebrew': '\u0418\u0432\u0440\u0438\u0442',
      'swedish': '\u0428\u0432\u0435\u0434\u0441\u043a\u0438\u0439',
      'norwegian':
          '\u041d\u043e\u0440\u0432\u0435\u0436\u0441\u043a\u0438\u0439',
      'finnish': '\u0424\u0438\u043d\u0441\u043a\u0438\u0439',
    };
    return ruFixed[key] ?? en[key] ?? clean(language);
  }
  return labels[key] ?? en[key] ?? clean(language);
}

/// Returns localized copy for the languages profile screens.
String? profileLanguagesUiText(String? key) {
  String localeKey() {
    final deviceLocale = WidgetsBinding
        .instance.platformDispatcher.locale.languageCode
        .toLowerCase();
    if (deviceLocale.isNotEmpty && deviceLocale != 'und') {
      return deviceLocale;
    }
    final intlLocale = Intl.getCurrentLocale().toLowerCase();
    return intlLocale.split(RegExp(r'[-_]')).first;
  }

  const en = {
    'section': 'Languages',
    'title': 'My languages:',
    'helper': 'Choose every language you speak.',
  };
  const ru = {
    'section': '\u042f\u0437\u044b\u043a\u0438',
    'title': '\u041c\u043e\u0438 \u044f\u0437\u044b\u043a\u0438:',
    'helper':
        '\u0412\u044b\u0431\u0435\u0440\u0438\u0442\u0435 \u0432\u0441\u0435 \u044f\u0437\u044b\u043a\u0438, \u043a\u043e\u0442\u043e\u0440\u044b\u043c\u0438 \u0432\u044b \u0432\u043b\u0430\u0434\u0435\u0435\u0442\u0435.',
  };
  final labelsByLocale = {'en': en, 'ru': ru};
  final labels = labelsByLocale[localeKey()] ?? en;
  if (localeKey() == 'ru') {
    const ruFixed = {
      'section': '\u042f\u0437\u044b\u043a\u0438',
      'title': '\u041c\u043e\u0438 \u044f\u0437\u044b\u043a\u0438:',
      'helper':
          '\u0412\u044b\u0431\u0435\u0440\u0438\u0442\u0435 \u0432\u0441\u0435 \u044f\u0437\u044b\u043a\u0438, \u043a\u043e\u0442\u043e\u0440\u044b\u043c\u0438 \u0432\u044b \u0432\u043b\u0430\u0434\u0435\u0435\u0442\u0435.',
    };
    return ruFixed[key] ?? en[key] ?? key;
  }
  return labels[key] ?? en[key] ?? key;
}

/// Formats profile languages using the fresh editor override when present.
String? profileLanguagesEffectiveDisplay(
  List<String>? languages,
  String? overrideValue,
) {
  String clean(dynamic value) {
    return (value?.toString() ?? '').trim();
  }

  String canonical(dynamic value) {
    final text = clean(value).toLowerCase();
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
      '\u0430\u043d\u0433\u043b\u0438\u0439\u0441\u043a\u0438\u0439': 'english',
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

  List<String> parseItems(dynamic value) {
    if (value == null) {
      return <String>[];
    }
    final rawItems = value is List ? value : [value];
    final output = <String>[];
    for (final item in rawItems) {
      final normalized = clean(item)
          .replaceAll(RegExp(r'^[\[\{]+|[\]\}]+$'), '')
          .replaceAll('"', '')
          .replaceAll("'", '');
      output.addAll(
        normalized
            .split(RegExp(r'[,;]'))
            .map((part) => canonical(part))
            .where((part) => part.isNotEmpty),
      );
    }
    return output.toSet().toList();
  }

  String localeKey() {
    final deviceLocale = WidgetsBinding
        .instance.platformDispatcher.locale.languageCode
        .toLowerCase();
    if (deviceLocale.isNotEmpty && deviceLocale != 'und') {
      return deviceLocale;
    }
    final intlLocale = Intl.getCurrentLocale().toLowerCase();
    return intlLocale.split(RegExp(r'[-_]')).first;
  }

  final overrideText = clean(overrideValue);
  if (overrideText == '__cleared_profile_attribute__') {
    return '';
  }
  final keys = overrideText.isNotEmpty
      ? parseItems(overrideText)
      : parseItems(languages);
  final isRu = localeKey() == 'ru';
  const en = {
    'english': 'English',
    'russian': 'Russian',
    'spanish': 'Spanish',
    'french': 'French',
    'german': 'German',
    'italian': 'Italian',
    'portuguese': 'Portuguese',
    'chinese': 'Chinese',
    'japanese': 'Japanese',
    'korean': 'Korean',
    'arabic': 'Arabic',
    'turkish': 'Turkish',
    'ukrainian': 'Ukrainian',
    'polish': 'Polish',
    'dutch': 'Dutch',
    'hindi': 'Hindi',
    'hebrew': 'Hebrew',
    'swedish': 'Swedish',
    'norwegian': 'Norwegian',
    'finnish': 'Finnish',
  };
  const ru = {
    'english': '\u0410\u043d\u0433\u043b\u0438\u0439\u0441\u043a\u0438\u0439',
    'russian': '\u0420\u0443\u0441\u0441\u043a\u0438\u0439',
    'spanish': '\u0418\u0441\u043f\u0430\u043d\u0441\u043a\u0438\u0439',
    'french':
        '\u0424\u0440\u0430\u043d\u0446\u0443\u0437\u0441\u043a\u0438\u0439',
    'german': '\u041d\u0435\u043c\u0435\u0446\u043a\u0438\u0439',
    'italian':
        '\u0418\u0442\u0430\u043b\u044c\u044f\u043d\u0441\u043a\u0438\u0439',
    'portuguese':
        '\u041f\u043e\u0440\u0442\u0443\u0433\u0430\u043b\u044c\u0441\u043a\u0438\u0439',
    'chinese': '\u041a\u0438\u0442\u0430\u0439\u0441\u043a\u0438\u0439',
    'japanese': '\u042f\u043f\u043e\u043d\u0441\u043a\u0438\u0439',
    'korean': '\u041a\u043e\u0440\u0435\u0439\u0441\u043a\u0438\u0439',
    'arabic': '\u0410\u0440\u0430\u0431\u0441\u043a\u0438\u0439',
    'turkish': '\u0422\u0443\u0440\u0435\u0446\u043a\u0438\u0439',
    'ukrainian': '\u0423\u043a\u0440\u0430\u0438\u043d\u0441\u043a\u0438\u0439',
    'polish': '\u041f\u043e\u043b\u044c\u0441\u043a\u0438\u0439',
    'dutch':
        '\u041d\u0438\u0434\u0435\u0440\u043b\u0430\u043d\u0434\u0441\u043a\u0438\u0439',
    'hindi': '\u0425\u0438\u043d\u0434\u0438',
    'hebrew': '\u0418\u0432\u0440\u0438\u0442',
    'swedish': '\u0428\u0432\u0435\u0434\u0441\u043a\u0438\u0439',
    'norwegian': '\u041d\u043e\u0440\u0432\u0435\u0436\u0441\u043a\u0438\u0439',
    'finnish': '\u0424\u0438\u043d\u0441\u043a\u0438\u0439',
  };
  final labels = isRu ? ru : en;
  return keys.map((key) => labels[key] ?? en[key] ?? key).join(', ');
}
