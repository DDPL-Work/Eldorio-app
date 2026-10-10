import 'dart:async';
import 'package:flutter/foundation.dart';
import 'api_provider.dart';

class Repository extends ApiProvider {
  static Repository? _instance;

  static Repository get instance {
    _instance ??= Repository._init();
    return _instance!;
  }

  Repository._init();

  void onFlutterError(FlutterErrorDetails flutterErrorDetails) {
    String information = '';

    reportError(
      tag: flutterErrorDetails.toStringShort(),
      value: flutterErrorDetails.exceptionAsString(),
      context: flutterErrorDetails.context?.value?.toString() ?? '',
      stack: flutterErrorDetails.stack.toString(),
      information: information,
    );
  }

  void reportError({
    required String tag,
    required String value,
    String context = '',
    String stack = '',
    String information = '',
  }) {
    if (!kDebugMode) {
      // Map<String, dynamic> error = {
      //   'tag': tag,
      //   'value': value,
      //   'context': context,
      //   'userEmail': Preference.isAvailable && Preference.isLogin
      //       ? Preference.user.userInfo?.email.nullSafe
      //       : '',
      //   'stack': stack,
      //   'information': information,
      // };
      // super.postDynamic('reportError', parameters: error);
    }
  }

  Future<dynamic> login(String email, String password) async {
    return super.postJson(
      'auth/login',
      parameters: {'email': email, 'password': password},
    );
  }

  Future<dynamic> updateProfile(Map<String, dynamic> data) async {
    return super.patchDynamic('profile', parameters: data);
  }

  Future<dynamic> deleteFolders({String? folderId}) async {
    return super.deleteDynamic('folders/$folderId');
  }
}
