import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:eldoriaCare/data_handler/api_keys.dart';
import 'package:eldoriaCare/utils/helper.dart';

class Const {
  static final RxInt notificationCount = 0.obs;

  static const String testNumber = '911234567890';
  static const String testName = 'Ajay';
  static const String testEmail = 'testsetup.dev@gmail.com';
  static const String testAddress = 'Survey Chock Dehradun';
  static const String testPassword = '123456';
  static List<String> testerIds = [testEmail, testNumber];

  static String privacyPolicy =
      '${BaseUrl.websiteUrl}/maven-jobs/employer-privacy';
  static String termsOfUse = '${BaseUrl.websiteUrl}/maven-jobs/employer-terms';
  static String aboutUs = '${BaseUrl.websiteUrl}/maven-jobs/about';

  // static final Rx<Config> config = Config().obs;
  static double loaderSize = 80;

  static String timeZone = 'UTC';
  static String packageName = '';
  static String versionCode = '0';
  static String versionName = '0';

  static final RxString name = 'AJAY RAWAT'.obs;
  static final RxString email = 'ajay@gmail.com'.obs;
  static final RxString profilePic = ''.obs;

  static const double webWidth = 420.0;

  static AppLifecycleState? lifecycleState = AppLifecycleState.resumed;
}

class PlatformType {
  static String platformType = '';

  static bool get isAndroid => platformType == 'android';

  static final bool isLinux = platformType == 'linux';

  static final bool isMacOS = platformType == 'macos';

  static final bool isWindows = platformType == 'windows';

  static final bool isIOS = platformType == 'ios';

  static final bool isFuchsia = platformType == 'fuchsia';

  static final bool isWeb = platformType == 'web';

  static final bool isMobile = isAndroid || isIOS;

  static final RxBool isWebMobileView =
      (100.w <= 411 || isAndroid || isIOS).obs;
}

class Status {
  static const String NORMAL = 'NORMAL';
  static const String PROGRESS = 'PROGRESS';
  static const String EMPTY = 'EMPTY';
  static const String ERROR = 'ERROR';
  static const String COMPLETED = 'COMPLETED';
}

class FeatureStatus {
  final String _type;
  final bool _accessibleInTrial;
  final bool _hasAccess;
  final String _message;

  FeatureStatus(
    this._type,
    this._accessibleInTrial,
    this._hasAccess,
    this._message,
  );

  bool get isPremium => _type == 'premium';

  bool get isAccessibleInTrial => _accessibleInTrial;

  bool get hasAccess => _hasAccess;

  String get message => _message;

  @override
  String toString() {
    return '{_type: $_type, _accessibleInTrial: $_accessibleInTrial, _hasAccess: $_hasAccess, _message: $_message}';
  }
}
