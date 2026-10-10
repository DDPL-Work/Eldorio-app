import 'package:eldoriaCare/utils/data/en.dart';
import 'package:eldoriaCare/utils/helper.dart';
import 'package:eldoriaCare/utils/logger.dart';

class Strings {
  static String _languageCode = 'en';
  static const Map<String, Map<String, String>> _languages = {
    'en': en /*, 'hi': hi, 'fr': fr*/,
  };

  static void init(String languageCode) {
    _languageCode = languageCode;
  }

  static String get(
    String? key, {
    bool removeSpaces = false,
    String? languageCode,
  }) {
    key = key.nullSafe;
    key = removeSpaces ? key.replaceAll(' ', '') : key;

    if (Helper.isTester &&
        Helper.isEmpty(_languages[languageCode ?? _languageCode]![key])) {
      Logger.m(
        tag: 'Strings.get()',
        value: "(undefined '$key' in $_languageCode)",
      );
    }

    return _languages[languageCode ?? _languageCode]![key] ?? key;
  }
}
