import 'package:hyphenatorx/hyphenatorx.dart';
import 'package:hyphenatorx/languages/language_ru.dart';

final _ruHyphenator = Hyphenator(Language_ru());

String hyphenate(String text) => _ruHyphenator.hyphenateText(text);
