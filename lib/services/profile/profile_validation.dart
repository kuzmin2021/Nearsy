bool isValidProfileName(String? name) {
  final trimmed = (name ?? '').trim();
  if (trimmed.isEmpty) return false;
  if (trimmed.runes.length > 20) return false;
  return RegExp(r'[A-Za-z\u0400-\u04FF]').hasMatch(trimmed);
}

String profileTextCounter(String? text, int? max) {
  final current = (text ?? '').runes.length;
  return '$current/$max';
}

String? profileBirthdayFromParts(String? day, String? month, String? year) {
  String clean(String? value) {
    final text = (value ?? '').trim();
    return text == '--' ? '' : text;
  }

  final cleanDay = clean(day);
  final cleanMonth = clean(month);
  final cleanYear = clean(year);
  if (cleanDay.isEmpty && cleanMonth.isEmpty && cleanYear.isEmpty) return '';
  if (cleanMonth.isEmpty || cleanYear.isEmpty) return '';
  if (cleanDay.isEmpty) return '-- $cleanMonth $cleanYear';
  return '$cleanDay $cleanMonth $cleanYear';
}

int? _monthNumber(String month) {
  final normalized = month.trim().toLowerCase();
  const months = {
    'january': 1,
    'jan': 1,
    'february': 2,
    'feb': 2,
    'march': 3,
    'mar': 3,
    'april': 4,
    'apr': 4,
    'may': 5,
    'june': 6,
    'jun': 6,
    'july': 7,
    'jul': 7,
    'august': 8,
    'aug': 8,
    'september': 9,
    'sep': 9,
    'october': 10,
    'oct': 10,
    'november': 11,
    'nov': 11,
    'december': 12,
    'dec': 12,
    '\u044f\u043d\u0432\u0430\u0440\u044c': 1,
    '\u044f\u043d\u0432\u0430\u0440\u044f': 1,
    '\u0444\u0435\u0432\u0440\u0430\u043b\u044c': 2,
    '\u0444\u0435\u0432\u0440\u0430\u043b\u044f': 2,
    '\u043c\u0430\u0440\u0442': 3,
    '\u043c\u0430\u0440\u0442\u0430': 3,
    '\u0430\u043f\u0440\u0435\u043b\u044c': 4,
    '\u0430\u043f\u0440\u0435\u043b\u044f': 4,
    '\u043c\u0430\u0439': 5,
    '\u043c\u0430\u044f': 5,
    '\u0438\u044e\u043d\u044c': 6,
    '\u0438\u044e\u043d\u044f': 6,
    '\u0438\u044e\u043b\u044c': 7,
    '\u0438\u044e\u043b\u044f': 7,
    '\u0430\u0432\u0433\u0443\u0441\u0442': 8,
    '\u0430\u0432\u0433\u0443\u0441\u0442\u0430': 8,
    '\u0441\u0435\u043d\u0442\u044f\u0431\u0440\u044c': 9,
    '\u0441\u0435\u043d\u0442\u044f\u0431\u0440\u044f': 9,
    '\u043e\u043a\u0442\u044f\u0431\u0440\u044c': 10,
    '\u043e\u043a\u0442\u044f\u0431\u0440\u044f': 10,
    '\u043d\u043e\u044f\u0431\u0440\u044c': 11,
    '\u043d\u043e\u044f\u0431\u0440\u044f': 11,
    '\u0434\u0435\u043a\u0430\u0431\u0440\u044c': 12,
    '\u0434\u0435\u043a\u0430\u0431\u0440\u044f': 12,
  };
  return months[normalized];
}

DateTime? _parseBirthdayValue(String? birthday) {
  final raw = (birthday ?? '').trim();
  if (raw.isEmpty) return null;

  final iso = DateTime.tryParse(raw);
  if (iso != null) return iso;

  final parts = raw.split(RegExp(r'\s+'));
  if (parts.length < 3) return null;

  final dayText = parts[0].trim();
  final monthText = parts[1].trim();
  final yearText = parts[2].trim();
  if (dayText == '--' || monthText == '--' || yearText == '--') return null;

  final day = int.tryParse(dayText);
  final month = int.tryParse(monthText) ?? _monthNumber(monthText);
  final year = int.tryParse(yearText);
  if (day == null || month == null || year == null) return null;
  if (day < 1 || day > 31 || month < 1 || month > 12) return null;

  final candidate = DateTime(year, month, day);
  if (candidate.year != year ||
      candidate.month != month ||
      candidate.day != day) {
    return null;
  }
  return candidate;
}

String? profileAgeFromBirthday(String? birthday) {
  final parsed = _parseBirthdayValue(birthday);
  if (parsed == null) return '';
  final now = DateTime.now();
  var age = now.year - parsed.year;
  if (now.month < parsed.month ||
      (now.month == parsed.month && now.day < parsed.day)) {
    age--;
  }
  if (age < 0) return '';
  return age.toString();
}
