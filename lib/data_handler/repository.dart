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

  Future<dynamic> sendOtp({
    required String phone,
    required String purpose,
  }) async {
    return super.postJson(
      'client/login/send-otp',
      parameters: {'phone': phone, 'purpose': purpose},
    );
  }

  Future<dynamic> verifyOtp({
    required String phone,
    required String otp,
    required String purpose,
  }) async {
    return super.postJson(
      'client/login/verify-otp',
      parameters: {'phone': phone, 'otp': otp, 'purpose': purpose},
    );
  }

  Future<dynamic> registerClient({
    required String verificationToken,
    required String phone,
    required String city,
    required String area,
  }) async {
    return super.postJson(
      'client/register',
      parameters: {
        'verificationToken': verificationToken,
        'phone': phone,
        'city': city,
        'area': area,
      },
    );
  }

  Future<dynamic> createBooking(Map<String, dynamic> payload) async {
    return super.postJson('client/booking/create', parameters: payload);
  }

  Future<dynamic> getBookings() async {
    return super.getDynamic('client/bookings');
  }

  Future<dynamic> getProfile() async {
    return super.getDynamic('auth/profile');
  }

  Future<dynamic> getServices({
    String city = 'pune',
    String category = 'all',
  }) async {
    return super.getDynamic('client/services?city=$city&category=$category');
  }

  Future<dynamic> getSetting() async {
    return super.getDynamic('setting');
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
