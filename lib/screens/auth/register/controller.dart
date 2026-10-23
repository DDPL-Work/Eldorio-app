import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/data_handler/repository.dart';
import 'package:eldoriaCare/model/users.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/utils/preference.dart';
import 'package:eldoriaCare/utils/toasty.dart';

class RegisterController extends GetxController {
  static RegisterController get to => Get.find();

  final phone = ''.obs;
  final verificationToken = ''.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final nameController = TextEditingController();
  final cityController = TextEditingController(text: 'Dehradun');
  final areaController = TextEditingController();
  final selectedCity = 'Dehradun'.obs;

  bool _isSubmitting = false;


  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      phone.value = (args['phone'] ?? '').toString();
      verificationToken.value = (args['verificationToken'] ?? '').toString();
      final prefillName = (args['name'] ?? '').toString();
      if (prefillName.isNotEmpty) {
        nameController.text = prefillName;
      }
      final prefillCity = (args['city'] ?? '').toString();
      if (prefillCity.isNotEmpty) {
        selectedCity.value = prefillCity;
        cityController.text = prefillCity;
      }
    }

    if (phone.value.isEmpty && Preference.isUserAvailable && Preference.user.userInfo?.phone?.isNotEmpty == true) {
      phone.value = Preference.user.userInfo!.phone!;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    cityController.dispose();
    areaController.dispose();
    super.onClose();
  }

  void onCitySelected(String cityName) {
    selectedCity.value = cityName;
    cityController.text = cityName;
  }

  Future<void> registerUser() async {
    if (_isSubmitting || isLoading.value) return;

    errorMessage.value = '';

    final token = verificationToken.value.trim();
    final userPhone = phone.value.trim().replaceAll(RegExp(r'\D'), '');
    final city = selectedCity.value.trim().isNotEmpty
        ? selectedCity.value.trim()
        : cityController.text.trim();
    final area = areaController.text.trim();
    final name = nameController.text.trim();

    if (token.isEmpty) {
      errorMessage.value = 'Verification session expired. Please verify your OTP again.';
      Toasty.failed(errorMessage.value);
      Get.back();
      return;
    }

    if (userPhone.length != 10) {
      errorMessage.value = 'Invalid 10-digit mobile number.';
      Toasty.failed(errorMessage.value);
      return;
    }

    if (city.isEmpty) {
      errorMessage.value = 'Please select or enter your city.';
      Toasty.failed(errorMessage.value);
      return;
    }

    if (area.isEmpty) {
      errorMessage.value = 'Please enter your area / locality.';
      Toasty.failed(errorMessage.value);
      return;
    }

    _isSubmitting = true;
    isLoading.value = true;

    try {
      final response = await Repository.instance.registerClient(
        verificationToken: token,
        phone: userPhone,
        city: city,
        area: area,
      );

      if (response != null && response is Map && response['success'] == true) {
        final user = User.fromJson(Map<String, dynamic>.from(response));

        // Save session locally
        Preference.setUser(user);
        await Preference.setLogin(true);

        final resolvedName = name.isNotEmpty
            ? name
            : (user.userInfo?.name?.isNotEmpty == true
                ? user.userInfo!.name!
                : 'Client');

        // Save active user profile in local SharedPreferences
        try {
          await LocalDB.setClientUserJson(
            jsonEncode({
              'name': resolvedName,
              'phone': userPhone,
              'city': city,
              'address': '$area, $city',
            }),
          );
        } catch (_) {}

        Toasty.success(response['message']?.toString() ?? 'Registration successful!');
        Get.offAllNamed(AppRoutes.home);
      } else {
        final msg = response is Map && response['message'] != null
            ? response['message'].toString()
            : 'Registration failed. Please check your details and try again.';
        errorMessage.value = msg;
        Toasty.failed(msg);
      }
    } catch (e) {
      errorMessage.value = 'Connection error: ${e.toString()}';
      Toasty.failed(errorMessage.value);
    } finally {
      isLoading.value = false;
      _isSubmitting = false;
    }
  }
}
