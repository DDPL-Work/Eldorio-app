import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/utils/preference.dart';

class ThemeController extends GetxController {
  final Rx<ThemeMode> themeMode = Preference.themeMode.obs;

  bool get isDark => true;

  Future<void> setThemeMode(ThemeMode mode) async {}

  Future<void> toggle(bool dark) async {}
}
