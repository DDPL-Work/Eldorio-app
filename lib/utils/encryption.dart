

class Encryption {
  // static late IV _iv;
  // static late Encrypter _encrypter;
  //
  // static late IV _publicIv;
  // static late Encrypter _publicEncrypter;

  static bool privateEncAvailable = false;
  static bool publicEncAvailable = false;

  static Encryption? _instance;

  static Encryption get instance {
    if (_instance == null) {
      return _instance = Encryption._init();
    }
    return _instance!;
  }

  static void setNull() {
    _instance = null;
  }

  Encryption._init() {
    // List<String> keysList = Const.config.value.keys.split('765567');
    //
    // if (keysList.length == 0) {
    //   Logger.e(baseName: runtimeType, tag: 'ENCRYPTION NOT SETUP CORRECTLY!');
    //   return;
    // }
    //
    // if (keysList.length > 3 && keysList[3].notEmpty) {
    //   privateEncAvailable = true;
    //   publicEncAvailable = true;
    //   Logger.m(baseName: runtimeType, tag: 'BOTH ENCRYPTION AVAILABLE');
    // } else if (keysList.length > 1) {
    //   publicEncAvailable = true;
    //   Logger.m(baseName: runtimeType, tag: 'ONLY PUBLIC ENCRYPTION AVAILABLE');
    // }
    //
    // final key = keysList[0];
    // final iv = keysList[1];
    //
    // final publicKey = keysList[2];
    // final publicIv = keysList[3];

    // _iv = IV.fromUtf8(iv);
    // _encrypter = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.cbc));
    //
    // _publicIv = IV.fromUtf8(publicIv);
    // _publicEncrypter = Encrypter(AES(Key.fromUtf8(publicKey), mode: AESMode.cbc));
  }

  String encrypt(String value, {bool private = true}) {
    // if (value.empty) return '';
    //
    // try {
    //   if (private && privateEncAvailable) {
    //     return 'TWPRI' + _encrypter.encrypt(value, iv: _iv).base64;
    //   } else if (publicEncAvailable) {
    //     return 'TWPUB' + _publicEncrypter.encrypt(value, iv: _publicIv).base64;
    //   }
    // } catch (e) {
    //   Logger.ex(baseName: runtimeType, tag: 'ENC EXC', value: e);
    // }
    // return value;
    return '';
  }

  String decrypt(String base64value) {
    // try {
    //   if (base64value.startsWith('TWPRI')) {
    //     base64value = base64value.replaceAll('TWPRI', base64value);
    //     return _encrypter.decrypt(Encrypted.fromBase64(base64value), iv: _iv);
    //   } else if (base64value.startsWith('TWPUB')) {
    //     base64value = base64value.replaceAll('TWPUB', base64value);
    //     return _publicEncrypter.decrypt(
    //       Encrypted.fromBase64(base64value),
    //       iv: _publicIv,
    //     );
    //   }
    // } catch (e) {
    //   Logger.ex(baseName: runtimeType, tag: 'DEC EXC', value: e);
    // }
    // return base64value;
    return '';
  }

  Map<String, dynamic> encMap(Map<String, dynamic> map) {
    try {
      return map.map((key, value) {
        return MapEntry(
          key,
          value is String || value is int || value is double || value is bool
              ? Encryption.instance.encrypt(value.toString(), private: false)
              : value,
        );
      });
    } catch (e) {
      return map;
    }
  }
}
