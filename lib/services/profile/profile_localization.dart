import '/services/i18n/app_labels.dart';

const Map<String, String> _attributeAliases = {};

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
