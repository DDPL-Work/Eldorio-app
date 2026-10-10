import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/utils/helper.dart';
import 'package:eldoriaCare/values/theme_colors.dart';

class Toasty {
  static void success(String msg, {duration = 2}) {
    Get.showSnackbar(
      GetSnackBar(
        message: msg,
        snackPosition: SnackPosition.TOP,
        backgroundColor: ThemeColors.success500,
        borderRadius: 12,
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        duration: Duration(seconds: duration),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      ),
    );
  }

  static void failed(String msg, {duration = 2}) {
    Get.showSnackbar(
      GetSnackBar(
        message: msg,
        snackPosition: SnackPosition.TOP,
        backgroundColor: ThemeColors.danger500,
        borderRadius: 12,
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        duration: Duration(seconds: duration),
        icon: const Icon(Icons.error, color: Colors.white),
        isDismissible: true,
      ),
    );
  }

  static void info(String msg, {duration = 2}) {
    Get.showSnackbar(
      GetSnackBar(
        message: msg,
        snackPosition: SnackPosition.TOP,
        backgroundColor: ThemeColors.infoYellow,
        borderRadius: 12,
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        duration: Duration(seconds: duration),
        icon: const Icon(Icons.info, color: Colors.white),
      ),
    );
  }

  static void normal(String msg, {duration = 2}) {
    Get.showSnackbar(
      GetSnackBar(
        message: msg,
        snackPosition: SnackPosition.TOP,
        borderRadius: 8,
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        duration: Duration(seconds: duration),
      ),
    );
  }
}
