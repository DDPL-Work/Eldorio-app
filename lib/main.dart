import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/data_handler/repository.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/screens/splash/splash.dart';
import 'package:eldoriaCare/theme/theme_controller.dart';
import 'package:eldoriaCare/utils/const.dart';
import 'package:eldoriaCare/utils/helper.dart';
import 'package:eldoriaCare/utils/preference.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    Repository.instance.onFlutterError(details);
  };

  try {
    PlatformType.platformType = Platform.operatingSystem;
  } catch (e) {
    PlatformType.platformType = kIsWeb ? 'web' : 'unknown';
  }

  await Preference.init();
  Get.put(ThemeController(), permanent: true);

  FlutterNativeSplash.remove();

  final runnableApp = _buildRunnableApp(
    isWeb: kIsWeb,
    webAppWidth: Const.webWidth,
    app: const MyApp(),
  );
  runApp(runnableApp);
}

Widget _buildRunnableApp({
  required bool isWeb,
  required double webAppWidth,
  required Widget app,
}) {
  if (!isWeb) {
    return app;
  }

  return Center(
    child: ClipRect(
      child: SizedBox(width: webAppWidth, child: app),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'appName'.t,
      theme: ThemeColors.darkTheme,
      darkTheme: ThemeColors.darkTheme,
      themeMode: ThemeMode.dark,
      home: const SplashScreen(),
      getPages: AppRoutes.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
