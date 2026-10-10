import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:eldoriaCare/utils/helper.dart';
import 'package:eldoriaCare/utils/logger.dart';
import 'package:eldoriaCare/utils/toasty.dart';
import 'package:get/get.dart';

Widget empty() => SizedBox();

Widget assetImage(
  String? name, {
  double? width,
  double? height,
  Color? color,
  BoxFit? fit,
  Alignment alignment = Alignment.center,
  ImageErrorWidgetBuilder? errorBuilder,
}) {
  try {
    if (name.empty) throw Exception('Empty Asset!');
    return Image.asset(
      name.nullSafe,
      width: width,
      height: height,
      color: color,
      fit: fit,
      alignment: alignment,
      errorBuilder:
          errorBuilder ??
          (c, o, s) {
            Logger.e(tag: 'ASSET IMAGE : ${name.nullSafe}', value: s);
            return SizedBox(width: width, height: height);
          },
    );
  } catch (e) {
    Logger.ex(tag: 'ASSET IMAGE', value: e);
    return empty();
  }
}

class MyFlatButton extends MaterialButton {
  const MyFlatButton({
    super.key,
    required VoidCallback super.onPressed,
    required Widget super.child,
    super.onLongPress,
    super.height,
    final double? width = double.infinity,
    super.minWidth,
    final Color? color,
    super.focusColor,
    super.splashColor,
    super.textColor,
    final EdgeInsetsGeometry? padding = EdgeInsets.zero,
    super.shape,
    final double? elevation,
    final MaterialTapTargetSize? materialTapTargetSize,
  }) : super(
         color: color ?? ThemeColors.transparentColor,
         highlightElevation: elevation ?? 0,
         padding: padding ?? EdgeInsets.zero,
         elevation: elevation ?? 0,
         materialTapTargetSize:
             materialTapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
       );
}

class MyTextStyle extends TextStyle {
  const MyTextStyle({
    super.inherit,
    super.color,
    super.backgroundColor,
    double super.fontSize = 14,
    super.fontWeight,
    super.fontStyle,
    super.fontFamily,
    super.letterSpacing,
    super.wordSpacing,
    super.textBaseline,
    super.height,
    super.decoration,
  });
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final double? fontSize;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;

  // final VoidCallback? onTab;
  final VoidCallback? onComplete;
  final VoidCallback? onChanged;

  const CustomTextField({
    required this.controller,
    required this.hintText,
    this.fontSize,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.enabled = true,
    // this.onTab,
    this.onChanged,
    this.onComplete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ThemeColors.grey.withAlpha(50)),
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onEditingComplete: onComplete,
        onChanged: (v) => onChanged,
        enabled: enabled,
        style: TextStyle(
          color: ThemeColors.textPrimaryColor,
          fontSize: fontSize ?? 4.w,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: ThemeColors.greyColor,
            fontSize: fontSize ?? 4.w,
          ),
          filled: true,
          fillColor: ThemeColors.offWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.w),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const CustomButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 7.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? ThemeColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.w),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 4.w,
            fontWeight: FontWeight.w600,
            color: ThemeColors.white,
          ),
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String icon;
  final Function() onTap;

  const SocialButton({required this.icon, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: onTap,
      onTap: () {
        Toasty.info('This feature is not available now');
      },
      child: Container(
        width: 12.w,
        height: 12.w,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: ThemeColors.offWhite,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: ThemeColors.greyColor.withValues(alpha: 0.2),
          ),
        ),
        // child: Icon(icon, color: color, size: 6.w),
        child: Image(image: AssetImage(icon)),
      ),
    );
  }
}

Widget customRefresh({
  required Widget child,
  required Future<void> Function() onRefresh,
}) {
  return RefreshIndicator(
    onRefresh: onRefresh,
    color: ThemeColors.white,
    backgroundColor: ThemeColors.colorSecondary.withAlpha(200),
    child: child,
  );
}

class CustomTabBarView extends StatelessWidget {
  final List<Widget> children;
  final ScrollPhysics? physics;
  final DragStartBehavior dragStartBehavior;
  final double viewportFraction;
  final Clip clipBehavior;

  const CustomTabBarView({
    super.key,
    required this.children,
    this.physics,
    this.dragStartBehavior = DragStartBehavior.start,
    this.viewportFraction = 1.0,
    this.clipBehavior = Clip.hardEdge,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: physics,
      dragStartBehavior: dragStartBehavior,
      viewportFraction: viewportFraction,
      clipBehavior: clipBehavior,
      children: children,
    );
  }
}

class DummyTextField extends StatelessWidget {
  final RxString hintText;
  final double? fontSize;
  final Widget? suffixIcon;
  final VoidCallback? onTab;

  const DummyTextField({
    required this.hintText,
    this.fontSize,
    this.suffixIcon,
    this.onTab,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      child: Container(
        height: 14.w,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: ThemeColors.black.withAlpha(60),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(30),
          color: ThemeColors.offWhite,
        ),
        child: Row(
          children: [
            if (suffixIcon != null) ...[suffixIcon!, 2.w.hs],
            Expanded(
              child: ClipRect(
                child: Obx(() {
                  final currentKey = ValueKey(hintText.value);
                  return AnimatedSwitcher(
                    duration: const Duration(seconds: 1),
                    layoutBuilder: (currentChild, previousChildren) {
                      return currentChild ?? const SizedBox.shrink();
                    },
                    transitionBuilder: (child, animation) {
                      if (child.key != currentKey) {
                        return const SizedBox.shrink();
                      }

                      final slideAnimation =
                          Tween<Offset>(
                            begin: const Offset(0, -1),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          );

                      return SlideTransition(
                        position: slideAnimation,
                        child: child,
                      );
                    },
                    child: Align(
                      key: currentKey,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        hintText.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ThemeColors.greyColor,
                          fontSize: fontSize ?? 4.w,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


