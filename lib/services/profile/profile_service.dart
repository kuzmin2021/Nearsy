String cleanValue(dynamic value) {
  if (value == null) return '';
  if (value is String) return value.trim();
  if (value is List) {
    return value
        .map((item) => cleanValue(item))
        .where((item) => item.isNotEmpty)
        .join(', ');
  }
  if (value is bool) return value ? 'Yes' : 'No';
  return value.toString().trim();
}

int? parseHeightCm(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.round();
  final text = value.toString().trim();
  if (text.isEmpty) return null;
  return int.tryParse(text.replaceAll(RegExp(r'[^0-9.-]'), ''));
}

String formatHeightDisplay(int? heightCm, bool isMetric,
    {required String localeKey}) {
  if (heightCm == null || heightCm <= 0) return '';
  const labelsByLanguage = <String, Map<String, String>>{
    'en': {'cm': 'cm', 'ft': 'ft'},
    'ru': {'cm': 'см', 'ft': 'фт'},
  };
  final labels = labelsByLanguage[localeKey] ?? labelsByLanguage['en']!;
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
