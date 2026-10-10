import 'package:flutter/material.dart';
import 'package:eldoriaCare/utils/const.dart';
import 'package:get/get.dart';

enum DeviceType { mobile, tablet, desktop }

class SizeConfig {
  static SizeConfig? _instance;

  static SizeConfig get instance {
    _instance ??= SizeConfig.init();
    return _instance!;
  }

  late double screenWidth;
  late double screenHeight;
  late double blockSizeHorizontal;
  late double blockSizeVertical;

  late double _safeAreaHorizontal;
  late double _safeAreaVertical;
  late double safeBlockHorizontal;
  late double safeBlockVertical;

  /// Text scale factor clamped so fonts don't blow up on large-text devices
  late double textScaleFactor;

  // ── Private initializer ──────────────────────────────────
  SizeConfig._();

  // ── Init from BuildContext (call in root widget) ─────────
  static void initWithContext(BuildContext context) {
    final mq = MediaQuery.of(context);
    _instance ??= SizeConfig._();
    _instance!._init(mq);
  }

  // ── Init from GetX context (fallback) ────────────────────
  SizeConfig.init() {
    final mq = Get.context!.mediaQuery;
    _init(mq);
  }

  void _init(MediaQueryData mq) {
    screenWidth = PlatformType.isWeb ? Const.webWidth : mq.size.width;
    screenHeight = mq.size.height;

    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal = mq.padding.left + mq.padding.right;
    _safeAreaVertical = mq.padding.top + mq.padding.bottom;

    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;

    // Clamp text scale between 0.8 and 1.2 for safe UI rendering
    textScaleFactor = mq.textScaler.scale(1.0).clamp(0.8, 1.2);
  }

  // ── Device type helpers ──────────────────────────────────
  DeviceType get deviceType {
    if (screenWidth >= 1100) return DeviceType.desktop;
    if (screenWidth >= 600) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  bool get isMobile => deviceType == DeviceType.mobile;

  bool get isTablet => deviceType == DeviceType.tablet;

  bool get isDesktop => deviceType == DeviceType.desktop;

  /// Returns different values based on device type.
  /// Usage: SizeConfig.instance.responsive(mobile: 14, tablet: 16, desktop: 18)
  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    switch (deviceType) {
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.mobile:
        return mobile;
    }
  }

  /// Horizontal padding that scales with device type
  double get horizontalPadding =>
      responsive(mobile: 16.0, tablet: 24.0, desktop: 32.0);

  /// Card width for grid layouts
  double get cardWidth => responsive(
    mobile: screenWidth,
    tablet: (screenWidth - 48) / 2,
    desktop: (screenWidth - 96) / 3,
  );
}

// ─────────────────────────────────────────────────────────────
//  Extensions on num  (w, h, sp, vs, hs)
// ─────────────────────────────────────────────────────────────
extension SizeExtOnNum on num {
  /// % of safe screen width   →  10.w  == 10% width
  double get w => this * SizeConfig.instance.safeBlockHorizontal;

  /// % of safe screen height  →  5.h   == 5% height
  double get h => this * SizeConfig.instance.safeBlockVertical;

  /// Scaled font size (respects textScaleFactor clamp)
  /// Usage: 14.sp
  double get sp => this * SizeConfig.instance.textScaleFactor;

  /// Responsive font — scales relative to 375px baseline (iPhone SE width)
  /// Usage: 16.rf
  double get rf {
    final ratio = SizeConfig.instance.screenWidth / 375;
    final scaled = this * ratio.clamp(0.85, 1.4);
    return scaled.toDouble();
  }

  /// Vertical SizedBox spacer  →  16.vs
  Widget get vs => SizedBox(height: toDouble());

  /// Horizontal SizedBox spacer →  8.hs
  Widget get hs => SizedBox(width: toDouble());
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final sc = SizeConfig.instance;
    if (sc.isDesktop && desktop != null) return desktop!;
    if (sc.isTablet && tablet != null) return tablet!;
    return mobile;
  }
}
