import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/data_handler/client_data_controller.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/utils/toasty.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find();

  final isOtpStep = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final selectedCity = 'mumbai'.obs;

  @override
  void onInit() {
    super.onInit();
    final c = ClientDataController.to;
    nameController.text = c.clientName.value;
    phoneController.text = c.clientPhone.value;
    selectedCity.value = c.clientCity.value;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }

  void useDemoAccount() {
    nameController.text = 'Priya Mehta';
    phoneController.text = '9123456780';
    selectedCity.value = 'mumbai';
    otpController.text = '123456';
    errorMessage.value = '';
    isOtpStep.value = true;
    Toasty.info('Demo account pre-filled. Tap Verify to continue.');
  }

  void sendOtp() {
    errorMessage.value = '';
    final name = nameController.text.trim();
    final phone = phoneController.text.replaceAll(RegExp(r'\D'), '');

    if (name.isEmpty) {
      errorMessage.value = 'Enter your name.';
      Toasty.failed(errorMessage.value);
      return;
    }

    if (phone.length != 10) {
      errorMessage.value = 'Enter a 10-digit mobile number.';
      Toasty.failed(errorMessage.value);
      return;
    }

    isOtpStep.value = true;
    otpController.clear();
    Toasty.success('OTP sent to +91 $phone');
  }

  Future<void> verifyOtp() async {
    errorMessage.value = '';
    final otp = otpController.text.trim();

    if (otp != '123456') {
      errorMessage.value = 'That OTP is incorrect. In this demo, use 123456.';
      Toasty.failed(errorMessage.value);
      return;
    }

    isLoading.value = true;
    try {
      final c = ClientDataController.to;
      await c.login(
        name: nameController.text.trim(),
        phone: phoneController.text.replaceAll(RegExp(r'\D'), ''),
        city: selectedCity.value,
      );

      Toasty.success('Welcome to Eldoria Care, ${c.clientName.value}!');
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      errorMessage.value = 'Failed to log in. Please try again.';
      Toasty.failed(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  void changeNumber() {
    isOtpStep.value = false;
    errorMessage.value = '';
    otpController.clear();
  }
}
