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

  static String? get currentStaffId => _pref?.getString('eldoria_staff_id');

  static Future<void> setCurrentStaffId(String id) async {
    await _pref?.setString('eldoria_staff_id', id);
  }

  static Future<bool>? clear() {
    _user == null;
    return _pref?.clear();
  }
}
