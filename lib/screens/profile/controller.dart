import 'package:eldoriaCare/data_handler/client_data_controller.dart';
import 'package:eldoriaCare/dialogs/alert_dialog.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/utils/helper.dart';
import 'package:eldoriaCare/utils/toasty.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final isLoading = false.obs;
  final clientData = ClientDataController.to;

  String get initials {
    final name = clientData.clientName.value.trim();
    final parts = name.split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'CL';
    if (parts.length == 1) return parts[0].substring(0, parts[0].length.clamp(0, 2)).toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  void promptSignOut() {
    MyAlertDialog()
        .setButtonAlignment(Alignment.bottomCenter)
        .setTitleAlignment(Alignment.bottomCenter)
        .setMessageAlignment(Alignment.bottomCenter)
        .setFirstSpacing(25)
        .setSecondSpacing(15)
        .setTitle('Log out?')
        .setMessage('Are you sure you want to log out of Eldoria Care?')
        .setPositiveButton('Log out', _performSignOut)
        .setNegativeButton('Cancel', null)
        .show();
  }

  Future<void> _performSignOut() async {
    try {
      isLoading.value = true;
      await clientData.logout();
      Toasty.normal('Logged out successfully');
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Toasty.failed('Failed to log out');
    } finally {
      isLoading.value = false;
    }
  }
}
