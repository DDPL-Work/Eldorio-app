import 'dart:async';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:eldoriaCare/dialogs/alert_dialog.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/utils/helper.dart';
import 'package:eldoriaCare/utils/logger.dart';
import 'package:eldoriaCare/utils/preference.dart';
import 'package:eldoriaCare/values/strings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'const.dart';
export '../values/size_config.dart';
export '../values/theme_colors.dart';

typedef RefreshCallback = void Function();

class Helper {
  // static const String DATE_FORMAT_1 = "yyyy_MM_dd_HH_mm_ss";
  // static const String DATE_FORMAT_2 = "yyyy-MM-dd HH:mm:ss";
  // static const String DATE_FORMAT_3 = "dd MMM yyyy, hh:mm a";
  // static const String DATE_FORMAT_4 = "dd MMM yyyy";
  // static const String DATE_FORMAT_5 = "EEE, dd MMM, hh:mm a";
  // static const String DATE_FORMAT_6 = "EEE, dd MMM yy";
  // static const String DATE_FORMAT_7 = "EEE, dd MMM, hh:mm a";
  // static const String DATE_FORMAT_8 = "EEE, dd MMM, yyyy";
  // static const String DATE_FORMAT_9 = "EEE, dd MMM\nhh:mm a";
  // static const String TIME_FORMAT_1 = "hh:mm a";
  // static const String TIME_FORMAT_2 = "hh:mm:ss";
  static Map<String, RefreshCallback> fastRefreshCallbacks =
      <String, RefreshCallback>{};
  static Map<String, RefreshCallback> refreshCallbacks =
      <String, RefreshCallback>{};
  static GlobalKey<ScaffoldState> appBarKey = GlobalKey<ScaffoldState>();

  // static Timer? _timer;
  static double buttonWidth = 70.w;

  static final RxBool networkAvailable = true.obs;
  static final RxString errorTitle = ''.obs;
  static final RxString errorMessage = ''.obs;
  static String currentDeviceId = '';

  // static String getTimeAgo(String dateString) {
  //   // Parse the input date string
  //   DateTime dateTime = DateTime.parse(dateString);
  //
  //   // Get the current date and time
  //   DateTime now = DateTime.now();
  //
  //   // Calculate the difference between the two dates
  //   Duration difference = now.difference(dateTime);
  //
  //   if (difference.inDays > 0) {
  //     if (difference.inDays == 1) {
  //       return '1 day ago';
  //     } else {
  //       return '${difference.inDays} days ago';
  //     }
  //   } else if (difference.inHours > 0) {
  //     return '${difference.inHours} hours ago';
  //   } else if (difference.inMinutes > 0) {
  //     return '${difference.inMinutes} minutes ago';
  //   } else if (difference.inSeconds > 0) {
  //     return '${difference.inSeconds} seconds ago';
  //   } else {
  //     return 'Just now';
  //   }
  // }

  static void init() async {
    var deviceInfo = DeviceInfoPlugin();
    if (PlatformType.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      currentDeviceId = androidDeviceInfo.id; // unique ID on Android
    } else if (PlatformType.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      currentDeviceId =
          iosDeviceInfo.identifierForVendor ?? ''; // unique ID on iOS
    }
  }

  static void openDrawer() async {
    appBarKey.currentState?.openDrawer();
  }

  static bool get isTester {
    return kDebugMode ||
        (Preference.isAvailable &&
            (Preference.user.userInfo?.email ?? "").contains(Const.testEmail));
  }

  static String hideEmail(String email) {
    if (!email.contains('@')) return email;

    final parts = email.split('@');
    final name = parts[0];
    final domain = parts[1];

    String hiddenName;
    if (name.length <= 2) {
      hiddenName = '${name[0]}*';
    } else {
      hiddenName = name[0] + '*' * (name.length - 2) + name[name.length - 1];
    }

    return '$hiddenName@$domain';
  }

  static void addRefreshCallback(
    String key,
    VoidCallback callback, {
    bool fastRefresh = false,
  }) {
    if (fastRefresh) {
      if (!fastRefreshCallbacks.containsKey(key)) {
        fastRefreshCallbacks.putIfAbsent(key, () => callback);
      } else {
        Logger.m(
          tag: '!!!!!!!!!! Callback already exist !!!!!!!!!!',
          value: key,
        );
      }
    } else {
      if (!refreshCallbacks.containsKey(key)) {
        refreshCallbacks.putIfAbsent(key, () => callback);
      } else {
        Logger.m(
          tag: '!!!!!!!!!! Callback already exist !!!!!!!!!!',
          value: key,
        );
      }
    }
  }

  static void removeAutoRefreshCallback(String key) {
    if (fastRefreshCallbacks.containsKey(key)) fastRefreshCallbacks.remove(key);
    if (refreshCallbacks.containsKey(key)) refreshCallbacks.remove(key);
    Logger.m(tag: 'Removed From Refresh Callback', value: key);
  }

  static int parseInt(dynamic value) {
    if (value == null || value.toString().empty) {
      // Logger.m(tag: 'INTEGER PARSE ERROR', value: 'NULL VALUE');
      return 0;
    }

    if (value is int) {
      return value;
    }

    if (value is String) {
      try {
        return value.isNotEmpty ? int.parse(value) : 0;
      } catch (e) {
        Logger.m(tag: 'INTEGER PARSE ERROR', value: e);
      }
    }

    if (value is double) {
      return value.toInt();
    }

    return 0;
  }

  static double parseDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    }

    if (value is int) {
      return value.toDouble();
    }

    if (value is String) {
      try {
        return value.isNotEmpty ? double.parse(value) : 0;
      } catch (e) {
        return 0.0;
      }
    }

    if (value is double) {
      return value;
    }

    return 0.0;
  }

  static String parseString(dynamic value) {
    if (value == null) {
      return '';
    }

    if (value is String) {
      return value;
    }

    return value.toString();
  }

  static String checkNull(String? value, {String defaultValue = ''}) {
    if (!isEmpty(value)) {
      return value.nullSafe;
    }
    return defaultValue.nullSafe;
  }

  static bool isEmpty(String? value) {
    return value == null || value == '' || value.isEmpty || value == 'null';
  }

  static bool isEmptyAny(List<String>? values) {
    if (values == null) {
      return true;
    }

    for (int i = 0; i < values.length; i++) {
      if (isEmpty(values[i])) {
        return true;
      }
    }
    return false;
  }

  static bool isValidUrl(
    String path, {
    String imageName = '',
    List<String> validExtensions = const [
      'png',
      'jpg',
      'jpeg',
      'webp',
      'pdf',
      'doc',
      'docx',
    ],
  }) {
    if (isEmpty(path)) {
      return false;
    }

    path = path + imageName.nullSafe;

    String ext = path.split('.').last;

    if (path.startsWith('http') && validExtensions.contains(ext)) {
      return true;
    }

    return false;
  }

  static BoxDecoration dialogBoxDecoration([double radius = 20]) =>
      BoxDecoration(
        color: ThemeColors.white,
        borderRadius: BorderRadius.circular(radius),
      );

  static String getEveryFirstDigit(String? name) {
    if (Helper.isEmpty(name)) {
      return '?';
    }

    List<String> li = name!.trim().split(' ');

    String str = '';

    if (li.length == 1 && li[0].length >= 2) {
      return li[0].substring(0, 2).toUpperCase();
    }

    for (var element in li) {
      str += element.substring(0, 1);
    }

    return str.toUpperCase();
  }

  static Future<void> openUrl(
    String url, {
    bool includeHttp = false,
    void Function()? success,
    void Function(String s)? onError,
    LaunchMode launchMode = LaunchMode.inAppWebView,
  }) async {
    if (url.isEmpty) {
      onError?.call("Can't launch url!");
      return;
    }

    try {
      if (includeHttp &&
          !url.startsWith('http://') &&
          !url.startsWith('https://') &&
          !url.startsWith('mailto:') &&
          !url.startsWith('whatsapp:')) {
        url = 'https://$url';
      }

      final Uri uri = Uri.parse(url);

      final bool launched = await launchUrl(uri, mode: launchMode);

      if (launched) {
        Logger.m(tag: 'OPEN URL', value: url);
        success?.call();
      } else {
        onError?.call("Can't launch url!");
      }
    } catch (e) {
      Logger.m(tag: 'openUrl', value: "'$url' Can't be launched! $e");
      onError?.call(e.toString());
    }
  }

  static String getTimeAgo(dynamic time) {
    if (time == null || time.toString().isEmpty) {
      return '';
    }

    try {
      if (time.toString().contains('ago')) {
        return time.toString();
      }

      DateTime dateTime;

      if (time.toString().isNumeric) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(
          int.parse(time.toString()),
        );
      } else {
        dateTime = DateTime.tryParse(time.toString()) ?? DateTime.now();
      }

      final diff = DateTime.now().difference(dateTime);

      if (diff.inDays > 365) {
        final years = (diff.inDays / 365).floor();
        return "$years ${years == 1 ? "year" : "years"} ago";
      }
      if (diff.inDays > 30) {
        final months = (diff.inDays / 30).floor();
        return "$months ${months == 1 ? "month" : "months"} ago";
      }
      if (diff.inDays > 7) {
        final weeks = (diff.inDays / 7).floor();
        return "$weeks ${weeks == 1 ? "week" : "weeks"} ago";
      }
      if (diff.inDays > 0) {
        return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
      }
      if (diff.inHours > 0) {
        return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
      }
      if (diff.inMinutes > 0) {
        return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
      }

      return "Just now";
    } catch (e) {
      Logger.ex(tag: 'GET TIME AGO', value: '$e ($time)');
      return '';
    }
  }

  static double calculateDistance(
    double? lat1,
    double? lon1,
    double? lat2,
    double? lon2,
  ) {
    if (lat1 == null ||
        lat2 == null ||
        lon1 == null ||
        lon2 == null ||
        lat1 <= 0.0 ||
        lat2 <= 0 ||
        lon1 <= 0 ||
        lon2 <= 0) {
      return -1;
    }

    var p = 0.017453292519943295;
    var c = cos;
    var a =
        0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  static int get currentMillis => DateTime.now().microsecondsSinceEpoch;

  static String getCurrentDate(String format) {
    final DateFormat formatter = DateFormat(format);
    return formatter.format(DateTime.now());
  }

  static String formatDate(DateTime dateTime, String format) {
    final DateFormat formatter = DateFormat(format);
    return formatter.format(dateTime);
  }

  static String formatMilliseconds(int milli, String format) {
    final DateFormat formatter = DateFormat(format);
    return formatter.format(DateTime.fromMillisecondsSinceEpoch(milli));
  }

  static String format(String dateTime, String format) {
    try {
      final DateFormat formatter = DateFormat(format);
      return formatter.format(DateTime.parse(dateTime.trim()));
    } catch (e) {
      Logger.e(tag: "DATE FORMAT : ", value: e.toString());
      return dateTime.nullSafe;
    }
  }

  static DateTime formatDateTime(String dateTime) {
    try {
      return DateTime.parse(dateTime);
    } catch (e) {
      Logger.e(tag: "DATE FORMAT : ", value: e.toString());
      return DateTime(1990);
    }
  }

  static int convertToMillis(String dateTime) {
    try {
      return DateTime.parse(dateTime).millisecondsSinceEpoch;
    } catch (e) {
      Logger.e(tag: "DATE FORMAT : ", value: e.toString());
      return DateTime(1990).millisecondsSinceEpoch;
    }
  }

  // static String getDay(String dateTime) {
  //   try {
  //     final DateFormat formatter = DateFormat('d');
  //     return formatter.format(DateTime.parse(dateTime));
  //   } catch (e) {
  //     Logger.e(tag: "DATE FORMAT : ", value: e.toString());
  //     return '';
  //   }
  // }

  static String createGroupId(String first, String second) {
    if (first.hashCode > second.hashCode) {
      return '${first}__$second';
    } else {
      return '${second}__$first';
    }
  }

  static bool isContainKeyword(String keyword, List<String?>? values) {
    if (!Helper.isEmpty(keyword) && values != null && values.isNotEmpty) {
      for (int i = 0; i < values.length; i++) {
        if (!Helper.isEmpty(values[i]) &&
            values[i]!.toLowerCase().contains(keyword.toLowerCase())) {
          return true;
        }
      }
    }
    return false;
  }

  // static void shareApp() => Share.share(
  //     'Please download App From here   https://play.google.com/store/apps/details?id=com.mkctv.app');

  static void shareApp() =>
      'Please download App From here   https://play.google.com/store/apps/details?id=com.mkctv.app';

  static int get generateNumber => Random().nextInt(900000) + 100000;

  static List<String> toList(String? s) {
    if (isEmpty(s)) {
      return <String>[];
    }

    List<String> li = s!.split(',');
    return li.where((element) => !isEmpty(element)).toList();
  }

  static String formatResponseTime(int minutes) {
    Duration duration = Duration(minutes: minutes);
    int twoDigits(int n) => n.toString().padLeft(2, '0').toInt;
    int twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    // int twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    String time;
    if (minutes >= 60) {
      time = '${twoDigits(duration.inHours)}h ';
    } else {
      time = '';
    }

    if (twoDigitMinutes > 0) {
      time += '${twoDigitMinutes}min';
    }

    return time;
  }

  // static void currencyFormatter(
  //     String value, TextEditingController controller) {
  //   int dotCount = value.charCount('.');
  //   int allowedDigitBeforeDot = 8;
  //   int allowedDigitAfterDot = 4;
  //
  //   if (dotCount > 1) {
  //     var v = value.split('.');
  //
  //     value = v[0] + '.' + v[1];
  //
  //     controller.value = TextEditingValue(
  //         text: value,
  //         selection: TextSelection.collapsed(offset: value.length));
  //   }
  //
  //   if (dotCount > 0) {
  //     var v = value.split('.');
  //
  //     if (v[0].length > allowedDigitBeforeDot) {
  //       v[0] = v[0].substring(0, allowedDigitBeforeDot);
  //     }
  //
  //     if (v[1].length > allowedDigitAfterDot) {
  //       v[1] = v[1].substring(0, allowedDigitAfterDot);
  //     }
  //
  //     value = v[0] + '.' + v[1];
  //
  //     controller.value = TextEditingValue(
  //         text: value,
  //         selection: TextSelection.collapsed(offset: value.length));
  //   } else if (value.length > allowedDigitBeforeDot) {
  //     value = value.substring(0, allowedDigitBeforeDot);
  //     controller.value = TextEditingValue(
  //         text: value,
  //         selection: TextSelection.collapsed(offset: value.length));
  //   }
  // }

  static void logOut() {
    MyAlertDialog()
        .setButtonAlignment(Alignment.bottomCenter)
        .setTitleAlignment(Alignment.bottomCenter)
        .setMessageAlignment(Alignment.bottomCenter)
        .setFirstSpacing(30)
        .setSecondSpacing(15)
        .setTitle('${Strings.get('logout')}?')
        .setMessage(Strings.get('youWantToLogOut'))
        .setPositiveButton('yes'.t, logOutWithoutAlert)
        .setNegativeButton('no'.t, null)
        .show();
  }

  static Future<void> logOutWithoutAlert() async {
    await Preference.setLogin(false);
    await Preference.clear();
    // await NotificationDbHelper().clearNotifications();
    Helper.refreshCallbacks.clear();
    Helper.fastRefreshCallbacks.clear();
    await Get.deleteAll();
    // Const.reset();
    // Get.back();
    Get.offAllNamed(AppRoutes.login);
  }

  static void exitAlert() {
    MyAlertDialog()
        .setButtonAlignment(Alignment.bottomCenter)
        .setTitleAlignment(Alignment.bottomCenter)
        .setMessageAlignment(Alignment.bottomCenter)
        .setFirstSpacing(30)
        .setSecondSpacing(15)
        .setTitle(Strings.get('exit'))
        .setMessage(Strings.get('youWantToExitFromApp'))
        .setPositiveButton('yes'.t, () {
          SystemNavigator.pop();
          return;
        })
        .setNegativeButton('no'.t, null)
        .show();
  }

  static String numberToString(int number) {
    switch (number) {
      case 0:
        return 'First';
      case 1:
        return 'Second';
      case 2:
        return 'Third';
      default:
        return "${number + 1}th";
    }
  }

  static String formatNumber(String? s, {bool withPlus = false}) {
    if (s.empty) {
      return '';
    }

    for (String c in [' ', '+', '-', '(', ')']) {
      s = s!.replaceAll(c, '');
    }

    return (withPlus ? '+' : '') + s.nullSafe;
  }

  // static String getFileNamePrefix(String pathType) {
  //   switch (pathType) {
  //     case FileUploadType.FILE:
  //       return 'FILE_';
  //     case FileUploadType.PROFILE_IMG:
  //       return 'PROFILE_';
  //     case FileUploadType.SMS_MEDIA:
  //       return 'SMS_IMG_';
  //   }
  //   return 'UNKNOWN_';
  // }

  static String starred(String str, int count) {
    if (str.empty) return '';

    if (str.length < count) return str;

    return str.substring(0, count) +
        List.generate(min(str.length - count, 20), (index) => '*').join('');
  }

  // static bool hasAccess(String featureName) {
  //   // if (Helper.isTester) {
  //   //   Toasty.normal('Working in test mode');
  //   //   return true;
  //   // }
  //
  //   if (!Const.featuresStatus.containsKey(featureName)) {
  //     MyAlertDialog()
  //         .setTitle('Error!')
  //         .setMessage(
  //             'Something is wrong with this feature!\nPlease contact to the support and try again later')
  //         .setPositiveButton('OK', null)
  //         .show();
  //     return false;
  //   }
  //
  //   FeatureStatus status = Const.featuresStatus[featureName]!;
  //
  //   Logger.m(tag: "ON TRIAL : ", value: Const.onTrial.isTrue);
  //   Logger.m(tag: "FEATURE SS : " + featureName, value: status.toString());
  //
  //   if (status.isPremium) {
  //     if ((Const.onTrial.isTrue && status.isAccessibleInTrial) ||
  //         status.hasAccess) {
  //       return true;
  //     }
  //   } else {
  //     return true;
  //   }
  //
  //   // SubscriptionAlertSheet(status.message);
  //   return false;
  // }

  // static String getVerboseDateTimeRepresentation(String date) {
  //   try {
  //     int dateTime = DateTime.parse(date).millisecondsSinceEpoch;
  //     int now = DateTime.now().millisecondsSinceEpoch;
  //
  //     int diff = now - dateTime;
  //
  //     if (diff < 12 * 60 * 60 * 1000) {
  //       return Helper.formatMilliseconds(dateTime, 'hh:mm a');
  //     } else if (diff < 365 * 24 * 60 * 60 * 1000) {
  //       return Helper.formatMilliseconds(dateTime, 'MMM dd');
  //     } else {
  //       return Helper.formatMilliseconds(dateTime, 'dd MMM, yyyy');
  //     }
  //   } catch (e) {
  //     Logger.e(tag: 'DateTimeRepresentation', value: e);
  //     return '';
  //   }
  // }

  static String? emptyValidator(String str) {
    return str.empty ? 'Please fill this field!' : null;
  }

  // static bool isSupportedMime(File file) {
  //   String mimeType = lookupMimeType(file.path) ?? '';
  //   return Const.allSupportedMimeType.contains(mimeType);
  // }
  //
  // static bool isImage(File file) {
  //   String mimeType = lookupMimeType(file.path) ?? '';
  //   return Const.supportedImageType.contains(mimeType);
  // }
  //
  // static bool isAudio(File file) {
  //   String mimeType = lookupMimeType(file.path) ?? '';
  //   return Const.supportedAudioType.contains(mimeType);
  // }
  //
  // static bool isVideo(File file) {
  //   String mimeType = lookupMimeType(file.path) ?? '';
  //   return Const.supportedVideoType.contains(mimeType);
  // }

  // static void openSupportWhatsapp() {
  //   var whatsappAndroid = "https://wa.me/${Const.config.value.wss}/?text=";
  //   Helper.openUrl(whatsappAndroid, onError: (e) {
  //     Toasty.failed('WhatsApp not installed!');
  //   }, launchMode: LaunchMode.externalApplication);
  // }
}

extension StringExtensions on String? {
  String get inCaps => notEmpty && this!.isNotEmpty
      ? '${this![0].toUpperCase()}${this!.substring(1).toLowerCase()}'
      : '';

  String get capitalizeFirstOfEach => notEmpty
      ? this!
            .replaceAll(RegExp(' +'), ' ')
            .split(' ')
            .map((str) => str.inCaps)
            .join(' ')
      : '';

  String get everyFirstDigit => Helper.getEveryFirstDigit(this);

  // String get nullSafe => Helper.checkNull(this);
  String get nullSafe => this ?? '';

  String placeholder(String? def) => empty ? def.nullSafe : nullSafe;

  String get nullStr => this ?? '------';

  bool get notEmpty => !Helper.isEmpty(this);

  bool get empty => Helper.isEmpty(this);

  int get toInt => Helper.parseInt(this);

  double get toDouble => Helper.parseDouble(this);

  void get copy => Clipboard.setData(ClipboardData(text: nullSafe));

  List<String> get toList => Helper.toList(this);

  String get t => Strings.get(this);

  bool get isNumeric => notEmpty && double.tryParse(this ?? '0') != null;

  String get formatNumber => Helper.formatNumber(this ?? '0');

  String get formatNumberWithPlus =>
      Helper.formatNumber(this ?? '0', withPlus: true);

  String get starred => Helper.starred(nullSafe, 6);

  int charCount(String char) => notEmpty
      ? nullSafe
            .split('')
            .fold<int>(
              0,
              (previousValue, ch) => previousValue + (ch == char ? 1 : 0),
            )
      : 0;

  String take(int length) {
    if (notEmpty && nullSafe.length > length) {
      return '${nullSafe.substring(0, length)}...';
    }
    return nullSafe;
  }
}
