import 'package:eldoriaCare/data_handler/repository.dart';
import 'package:eldoriaCare/utils/helper.dart';
import 'package:eldoriaCare/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/data_handler/staff_service.dart';
import 'package:eldoriaCare/model/staff_profile.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/utils/toasty.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find();

  final staffList = <StaffModel>[].obs;
  final activeApplicant = Rxn<StaffModel>();
  final isLoading = false.obs;
  final isOtpSent = false.obs;
  final showPhoneLogin = false.obs;

  final formKey = GlobalKey<FormState>();
  final phoneCtrl = TextEditingController();
  final otpCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (Helper.isTester) {
      phoneCtrl.text = '8126552280';
    }
  }

  @override
  void onClose() {
    phoneCtrl.dispose();
    otpCtrl.dispose();
    super.onClose();
  }

  Future<void> sendOtp() async {
    final number = phoneCtrl.text.trim().replaceAll(RegExp(r'\D'), '');
    if (number.length != 10) {
      Toasty.failed('Enter a valid 10-digit mobile number');
      return;
    }
    isLoading.value = true;
    try {
      final response = await Repository.instance.sendOtp(number, 'login');
      if (response['success'] == false) {
        Toasty.failed(response['message'] ?? '');
        return;
      } else {
        isOtpSent.value = true;
        phoneCtrl.text = response['data']['phone'];
        otpCtrl.text = response['data']['otp'];
        await Clipboard.setData(ClipboardData(text: otpCtrl.text));
        Toasty.success('Demo OTP: ${response['data']['otp']}');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(String phone) async {
    final number = phone.trim().replaceAll(RegExp(r'\D'), '');
    final otp = otpCtrl.text.trim();
    if (number.length != 10) {
      Toasty.failed('Enter a valid 10-digit mobile number');
      return;
    }
    if (otp.length < 6) {
      Toasty.failed('Enter a valid 6-digit OTP');
      return;
    }
    isLoading.value = true;
    try {
      final response = await Repository.instance.verifyOtp(
        number,
        otp,
        'login',
      );
      final isSuccess =
          response != null &&
          (response['success'] == true || response['status'] == 'success');

      if (isSuccess && response['data'] != null) {
        final staff = StaffModel.fromJson(
          response['data'] as Map<String, dynamic>,
        );

        if (staff.isApproved) {
          Toasty.success('Welcome back, ${staff.name}!');
          Get.offAllNamed(AppRoutes.home);
        } else {
          Toasty.info('Your application is under review');
          Get.offAllNamed(
            AppRoutes.trackJoiningStatus,
            arguments: {'trackId': staff.id, 'application': staff},
          );
        }
      } else {
        Toasty.failed(response?['message'] ?? 'Staff record not found');
      }
    } catch (e) {
      Logger.e(tag: 'Error occurred while verifying OTP', value: e);
      Toasty.failed('somethingWentWrong'.t);
    } finally {
      isLoading.value = false;
    }
  }

  void goToTrack([String? trackId]) {
    Get.toNamed(AppRoutes.trackJoiningStatus, arguments: {'trackId': trackId});
  }
}
