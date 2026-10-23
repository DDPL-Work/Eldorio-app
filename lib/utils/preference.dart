import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:eldoriaCare/model/users.dart';
import 'package:eldoriaCare/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preference extends User {
  static const _IS_LOGIN = "is_login";

  static const _USER = 'user_5684';
  static User? _user;
  static String _NEXT_LOGS_FILE_UPDATED = '';

  static SharedPreferences? _pref;

  static Future init() async {
    _pref = await SharedPreferences.getInstance();
    await LocalDB.init();
  }

  static bool get isAvailable => _pref != null;

  static bool containsKey(String key) => _pref!.containsKey(key);

  static bool get isUserAvailable =>
      _pref!.containsKey(_USER) && _pref!.getString(_USER).notEmpty;

  static int get nextLogsFileUpdated =>
      _pref!.getInt(_NEXT_LOGS_FILE_UPDATED) ?? Helper.currentMillis;

  static void scheduleNextLogsFileUpdated() {
    _pref!.setInt(
      _NEXT_LOGS_FILE_UPDATED,
      Helper.currentMillis + (10 * 60 * 1000),
    );
  }

  static User get user {
    if (_user == null && _pref != null) {
      final str = _pref!.getString(_USER);
      if (str != null && str.isNotEmpty) {
        try {
          _user = User.fromJson(jsonDecode(str));
        } catch (e) {
          _user = User();
        }
      } else {
        _user = User();
      }
    }
    return _user ?? User();
  }

  static void setUser(User u) {
    if (u.userInfo?.id?.isNotEmpty == true || u.token?.isNotEmpty == true) {
      _user = u;
      _pref?.setString(_USER, jsonEncode(u.toJson()));
    }
  }

  //Check Login or not?
  static bool get isLogin => _pref!.getBool(_IS_LOGIN) ?? false;

  static Future<void> setLogin(bool login) => _pref!.setBool(_IS_LOGIN, login);

  static ThemeMode get themeMode => ThemeMode.dark;

  static Future<void> setThemeMode(ThemeMode mode) async {}

  static Future<bool>? clear() {
    _user = null;
    return _pref?.clear();
  }
}

class LocalDB {
  static SharedPreferences? _pref;

  static const String keyUser = 'eldoria_client_user_v2';
  static const String keyNotifications = 'eldoria_client_notifications_v2';
  static const String keyBookings = 'eldoria_client_bookings_v2';
  static const String keyEnquiries = 'eldoria_client_enquiries_v2';
  static const String keyStaffId = 'eldoria_staff_id';

  static Future<void> init() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  static String get clientUserJson => _pref?.getString(keyUser) ?? '';

  static Future<bool> setClientUserJson(String jsonStr) async {
    await init();
    return await _pref!.setString(keyUser, jsonStr);
  }

  // Client Notifications ('eldoria_client_notifications_v2')
  static String get clientNotificationsJson =>
      _pref?.getString(keyNotifications) ?? '';

  static Future<bool> setClientNotificationsJson(String jsonStr) async {
    await init();
    return await _pref!.setString(keyNotifications, jsonStr);
  }

  // Client Bookings ('eldoria_client_bookings_v2')
  static String get clientBookingsJson => _pref?.getString(keyBookings) ?? '';

  static Future<bool> setClientBookingsJson(String jsonStr) async {
    await init();
    return await _pref!.setString(keyBookings, jsonStr);
  }

  // Client Enquiries ('eldoria_client_enquiries_v2')
  static String get clientEnquiriesJson => _pref?.getString(keyEnquiries) ?? '';

  static Future<bool> setClientEnquiriesJson(String jsonStr) async {
    await init();
    return await _pref!.setString(keyEnquiries, jsonStr);
  }

  // Current Staff ID ('eldoria_staff_id')
  static String get currentStaffId => _pref?.getString(keyStaffId) ?? '';

  static Future<bool> setCurrentStaffId(String id) async {
    await init();
    return await _pref!.setString(keyStaffId, id);
  }
}
