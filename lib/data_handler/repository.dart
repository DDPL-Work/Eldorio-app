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

  Future<dynamic> registerStaff(Map<String, dynamic> payload) async {
    return super.postJson('staff/register', parameters: payload);
  }

  Future<dynamic> login(String email, String password) async {
    return super.postJson(
      'auth/login',
      parameters: {'email': email, 'password': password},
    );
  }

  Future<dynamic> sendOtp(String number, String purpose) async {
    return super.postJson(
      'auth/staff/send-otp',
      parameters: {'phone': number, 'purpose': purpose},
    );
  }

  Future<dynamic> verifyOtp(String phone, String otp, String purpose) async {
    return super.postJson(
      'auth/staff/verify-otp',
      parameters: {'phone': phone, 'otp': otp, 'purpose': purpose},
    );
  }

  Future<dynamic> checkApplicationStatus(String staffID) async {
    return super.getDynamic('staff/application/$staffID/status');
  }

  Future<dynamic> getProfile() async {
    return super.getDynamic('auth/profile');
  }

  Future<dynamic> getBookings() async {
    return super.getDynamic('staff/bookings');
  }

  Future<dynamic> getBookingById(String bookingId) async {
    return super.getDynamic('staff/booking/$bookingId');
  }

  Future<dynamic> updateProfile(Map<String, dynamic> data) async {
    return super.patchDynamic('profile', parameters: data);
  }

  Future<dynamic> deleteFolders({String? folderId}) async {
    return super.deleteDynamic('folders/$folderId');
  }
}
