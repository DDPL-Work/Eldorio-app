import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final String? label;
  final VoidCallback? onRetry;

  const EmptyWidget({
    super.key,
    this.title,
    this.message,
    this.label,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              color: ThemeColors.whiteBlue,
              shape: BoxShape.circle,
            ),
            child: Lottie.asset(
              'assets/json/empty.json',
              width: 130.sp,
              height: 130.sp,
              fit: BoxFit.contain,
            ),
          ),
          18.sp.vs,
          if (title != null) ...[
            Text(
              title!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: ThemeColors.defaultTextColor,
              ),
            ),
            6.sp.vs,
          ],
          if (message != null) ...[
            Text(
              message!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.4,
                color: ThemeColors.textPrimaryColor,
              ),
            ),
            20.sp.vs,
          ],
          if (onRetry != null)
            Material(
              color: ThemeColors.transparentColor,
              child: InkWell(
                onTap: onRetry,
                borderRadius: BorderRadius.circular(30.sp),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.sp,
                    horizontal: 26.sp,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeColors.black.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(30.sp),
                    border: Border.all(
                      color: ThemeColors.black.withValues(alpha: .3),
                    ),
                  ),
                  child: Text(
                    label ?? 'Retry',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.black,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class EmptyCard extends StatelessWidget {
  final String? title;
  final String? message;
  final String? label;
  final IconData? icon;
  final VoidCallback? onRetry;

  const EmptyCard({
    super.key,
    this.title,
    this.message,
    this.label,
    this.icon,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: _SectionMessageCard(
        icon: icon ?? Icons.folder_open_outlined,
        title: title ?? '',
        message: message ?? "",
      ),
    );
  }
}

class _SectionMessageCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _SectionMessageCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: ThemeColors.cardColorOf(context),
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(color: ThemeColors.grey300.withValues(alpha: .5)),
      ),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: ThemeColors.softSurface,
              borderRadius: BorderRadius.circular(4.w),
            ),
            child: Icon(icon, color: ThemeColors.mutedText(context), size: 6.w),
          ),
          1.5.h.vs,
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ThemeColors.textOnSurface(context),
              fontSize: 4.w,
              fontWeight: FontWeight.w800,
            ),
          ),
          0.8.h.vs,
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ThemeColors.mutedText(context),
              fontSize: 3.2.w,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
