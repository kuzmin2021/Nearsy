import '/services/i18n/app_labels.dart';

const Map<String, String> _attributeAliases = {
  'female': 'woman',
  'male': 'man',
  'nonbinary': 'non_binary',
  'bachelor_degree': 'bachelors_degree',
  'master_degree': 'masters_degree',
};

String _clean(dynamic value) => (value?.toString() ?? '').trim();

String humanizeProfileValue(String? rawValue) {
  final text = _clean(rawValue);
  if (text.isEmpty) return '';
  final spaced = text.replaceAll('_', ' ');
  return spaced
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .map((part) {
    final lower = part.toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }).join(' ');
}

String canonicalProfileAttribute(dynamic rawValue) {
  final text = _clean(rawValue).toLowerCase();
  if (text.isEmpty) return '';
  final normalized = text
      .replaceAll("'", '')
      .replaceAll(RegExp(r'[^a-z0-9\u0400-\u04FF]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
  return _attributeAliases[normalized] ?? normalized;
}

const Map<String, Map<String, String>> _profileLabelsRu = {
  'gender': {
    'woman': 'Женщина',
    'female': 'Женщина',
    'man': 'Мужчина',
    'male': 'Мужчина',
    'other': 'Другое',
    'non_binary': 'Небинарный',
    'non-binary': 'Небинарный',
    'nonbinary': 'Небинарный',
  },
  'education': {
    'high_school': 'Средняя школа',
    'currently_studying': 'Учусь сейчас',
    'trade_qualification': 'Профессиональное образование',
    'bachelors_degree': 'Бакалавриат',
    'master_degree': 'Магистратура',
    'masters_degree': 'Магистратура',
    'doctorate_phd': 'Докторантура / PhD',
    'postgraduate': 'Постдипломное образование',
    'other': 'Другое',
    'prefer_not_to_say': 'Предпочитаю не говорить',
  },
  'kids': {
    'true': 'Есть дети',
    'false': 'Нет детей',
    'yes': 'Есть дети',
    'no': 'Нет детей',
    'i_have_kids': 'Есть дети',
    'i_dont_have_kids': 'Нет детей',
    'i_have': 'Есть дети',
    'i_dont_have': 'Нет детей',
    'prefer_not_to_say': 'Предпочитаю не говорить',
  },
  'relationship_type': {
    'something_serious': 'Серьезные отношения',
    'just_dating': 'Просто свидания',
    'just_fun': 'Просто веселье',
    'open_to_anything': 'Открыт(а) к разному',
    'not_sure': 'Не уверен(а)',
  },
  'religion': {
    'agnostic': 'Агностик',
    'atheist': 'Атеист',
    'buddhist': 'Буддизм',
    'christian': 'Христианство',
    'hindu': 'Индуизм',
    'jewish': 'Иудаизм',
    'muslim': 'Ислам',
    'sikh': 'Сикхизм',
    'spiritual': 'Духовные взгляды',
    'other': 'Другое',
  },
  'body_type': {
    'slim': 'Стройное',
    'lean': 'Подтянутое',
    'average': 'Среднее',
    'fit': 'В форме',
    'athletic': 'Спортивное',
    'muscular': 'Мускулистое',
    'broad': 'Крупное',
    'stocky': 'Плотное',
    'bigger': 'Больше среднего',
    'curvy': 'С формами',
    'prefer_not_to_say': 'Предпочитаю не говорить',
  },
  'exercise': {
    'regularly': 'Регулярно',
    'occasionally': 'Иногда',
    'rarely': 'Редко',
    'never': 'Никогда',
  },
  'drinking': {
    'yes': 'Да',
    'occasionally': 'Иногда',
    'rarely': 'Редко',
    'no': 'Нет',
    'stopped_for_now': 'Пока не пью',
  },
  'smoking': {
    'yes': 'Да',
    'sometimes': 'Иногда',
    'no': 'Нет',
    'trying_to_quit': 'Пытаюсь бросить',
  },
};

String localizeProfileAttribute(String attribute, dynamic rawValue,
    {String? localeKey}) {
  final value = canonicalProfileAttribute(rawValue);
  if (value.isEmpty) return '';
  final localized = AppLabels.staticProfileLabel(attribute, value);
  if (localized != value) return localized;
  return humanizeProfileValue(value);
}

String effectiveProfileAttribute(
    String? attribute, String? overrideValue, String? loadedValue,
    {String? localeKey}) {
  final attr = _clean(attribute);
  final overrideText = _clean(overrideValue);
  final loadedText = _clean(loadedValue);
  if (overrideText == '__cleared_profile_attribute__') return '';
  final value = overrideText.isNotEmpty ? overrideText : loadedText;
  if (value.isEmpty) return '';
  return localizeProfileAttribute(attr, value, localeKey: localeKey);
}
