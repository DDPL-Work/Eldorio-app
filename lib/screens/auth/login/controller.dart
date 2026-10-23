import 'dart:async';
import 'dart:convert';
import 'package:eldoriaCare/utils/const.dart';
import 'package:eldoriaCare/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/data_handler/repository.dart';
import 'package:eldoriaCare/model/users.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/utils/preference.dart';
import 'package:eldoriaCare/utils/toasty.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find();

  // Mode: false = Login, true = Sign Up
  final isSignUp = false.obs;

  final isOtpStep = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final resendSeconds = 0.obs;
  final verificationToken = ''.obs;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final selectedCity = 'Dehradun'.obs;

  Timer? _countdownTimer;


  @override
  void onInit() {
    super.onInit();
    if (Helper.isTester) {
      phoneController.text = '9084773519';
    }

    _initDefaults();
  }

  Future<void> _initDefaults() async {
    try {
      final userStr = LocalDB.clientUserJson;
      if (userStr.isNotEmpty) {
        final u = jsonDecode(userStr);
        if (u['name'] != null && u['name'].toString().trim().isNotEmpty) {
          nameController.text = u['name'].toString().trim();
        }
        if (u['phone'] != null && u['phone'].toString().trim().isNotEmpty) {
          phoneController.text = u['phone'].toString().trim();
        }
        if (u['city'] != null && u['city'].toString().trim().isNotEmpty) {
          final raw = u['city'].toString().trim();
          final match = Const.cities.firstWhereOrNull(
            (c) =>
                c.id.toLowerCase() == raw.toLowerCase() ||
                c.name.toLowerCase() == raw.toLowerCase(),
          );
          if (match != null) {
            selectedCity.value = match.name;
          }
        }
      } else if (Preference.isUserAvailable) {
        final user = Preference.user.userInfo;
        if (user != null) {
          if (user.name != null && user.name!.isNotEmpty) {
            nameController.text = user.name!;
          }
          if (user.phone != null && user.phone!.isNotEmpty) {
            phoneController.text = user.phone!;
          }
        }
      }
    } catch (_) {}
  }

  void setSignUpMode(bool signUp) {
    if (isSignUp.value == signUp) return;
    isSignUp.value = signUp;
    isOtpStep.value = false;
    errorMessage.value = '';
    otpController.clear();
    _countdownTimer?.cancel();
    resendSeconds.value = 0;
  }

  void _startResendCountdown() {
    _countdownTimer?.cancel();
    resendSeconds.value = 60;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds.value > 0) {
        resendSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> sendOtp() async {
    if (isLoading.value) return;

    errorMessage.value = '';
    final phone = phoneController.text.replaceAll(RegExp(r'\D'), '');

    if (phone.length != 10) {
      errorMessage.value = 'Enter a valid 10-digit mobile number.';
      Toasty.failed(errorMessage.value);
      return;
    }

    final purpose = isSignUp.value ? 'registration' : 'login';

    isLoading.value = true;
    try {
      final response = await Repository.instance.sendOtp(
        phone: phone,
        purpose: purpose,
      );

      if (response != null && response is Map && response['success'] == true) {
        isOtpStep.value = true;
        otpController.clear();
        _startResendCountdown();

        final returnedOtp = response['data']?['otp']?.toString();
        if (returnedOtp != null && returnedOtp.isNotEmpty) {
          otpController.text = returnedOtp;
        }

        final msg = response['message']?.toString() ?? 'OTP sent to +91 $phone';
        Toasty.success(msg);
      } else {
        final msg = response is Map && response['message'] != null
            ? response['message'].toString()
            : 'Failed to send OTP. Please try again.';
        errorMessage.value = msg;
        Toasty.failed(msg);
      }
    } catch (e) {
      errorMessage.value = 'Network error: ${e.toString()}';
      Toasty.failed(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (resendSeconds.value > 0 || isLoading.value) return;
    await sendOtp();
  }

  Future<void> verifyOtp() async {
    if (isLoading.value) return;

    errorMessage.value = '';
    final phone = phoneController.text.replaceAll(RegExp(r'\D'), '');
    final otp = otpController.text.trim();

    if (phone.length != 10) {
      errorMessage.value = 'Invalid mobile number.';
      Toasty.failed(errorMessage.value);
      return;
    }

    if (otp.length != 6) {
      errorMessage.value = 'Please enter the complete 6-digit OTP.';
      Toasty.failed(errorMessage.value);
      return;
    }

    final purpose = isSignUp.value ? 'registration' : 'login';

    isLoading.value = true;
    try {
      final response = await Repository.instance.verifyOtp(
        phone: phone,
        otp: otp,
        purpose: purpose,
      );

      if (response != null && response is Map && response['success'] == true) {
        final Map<String, dynamic> data = response['data'] is Map
            ? Map<String, dynamic>.from(response['data'])
            : <String, dynamic>{};

        final bool isNewUser = data['isNewUser'] == true;
        final bool isRegistered = data['isRegistered'] == true;
        final String? nextStep = data['nextStep']?.toString();
        final String? token = data['token']?.toString();
        final String? returnedVerificationToken = data['verificationToken']
            ?.toString();

        // Case 1: Unregistered / New User -> Proceed to Registration
        if (isNewUser ||
            !isRegistered ||
            nextStep == 'register' ||
            (returnedVerificationToken != null &&
                returnedVerificationToken.isNotEmpty &&
                token == null)) {
          verificationToken.value = returnedVerificationToken ?? '';

          Toasty.success('OTP verified! Please complete your registration.');

          Get.toNamed(
            AppRoutes.register,
            arguments: {
              'phone': phone,
              'verificationToken': verificationToken.value,
              'name': nameController.text.trim(),
              'city': selectedCity.value,
            },
          );
          return;
        }

        // Case 2: Registered user with authentication token -> Complete Login
        if (token != null && token.isNotEmpty) {
          final user = User.fromJson(Map<String, dynamic>.from(response));

          Preference.setUser(user);
          await Preference.setLogin(true);

          final userName = user.userInfo?.name ?? nameController.text.trim();
          final userCity =
              user.profile?.city ??
              user.profile?.currentCity ??
              selectedCity.value;
          final userArea = user.profile?.area;

          // Save active user profile in local SharedPreferences
          try {
            await LocalDB.setClientUserJson(
              jsonEncode({
                'name': userName.isNotEmpty ? userName : 'Client',
                'phone': phone,
                'city': userCity,
                'address': userArea != null && userArea.isNotEmpty
                    ? '$userArea, $userCity'
                    : (user.profile?.address ?? ''),
              }),
            );
          } catch (_) {}

          Toasty.success('Welcome back to Eldoria Care!');
          Get.offAllNamed(AppRoutes.home);
          return;
        }

        // Fallback: If verification token is provided, navigate to register
        if (returnedVerificationToken != null &&
            returnedVerificationToken.isNotEmpty) {
          verificationToken.value = returnedVerificationToken;
          Get.toNamed(
            AppRoutes.register,
            arguments: {
              'phone': phone,
              'verificationToken': verificationToken.value,
              'name': nameController.text.trim(),
              'city': selectedCity.value,
            },
          );
        } else {
          errorMessage.value =
              'Unexpected response from server. Please try again.';
          Toasty.failed(errorMessage.value);
        }
      } else {
        final msg = response is Map && response['message'] != null
            ? response['message'].toString()
            : 'Invalid or expired OTP. Please enter the correct OTP.';
        errorMessage.value = msg;
        Toasty.failed(msg);
      }
    } catch (e) {
      errorMessage.value = 'Network error: ${e.toString()}';
      Toasty.failed(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  void changeNumber() {
    isOtpStep.value = false;
    errorMessage.value = '';
    otpController.clear();
    _countdownTimer?.cancel();
    resendSeconds.value = 0;
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    nameController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
