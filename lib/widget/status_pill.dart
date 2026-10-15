import 'package:flutter/material.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';

class StatusPill extends StatelessWidget {
  final String status;
  final String? customLabel;

  const StatusPill({
    super.key,
    required this.status,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = _resolveStyle();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 2.2.w,
        vertical: 0.4.h,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        customLabel ?? label,
        style: TextStyle(
          color: fg,
          fontSize: 10.5.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  (String, Color, Color) _resolveStyle() {
    switch (status.toLowerCase()) {
      case 'requested':
        return ('Request received', ThemeColors.statusRequestedBg, ThemeColors.statusRequestedFg);
      case 'confirmed':
        return ('Confirmed', ThemeColors.statusConfirmedBg, ThemeColors.statusConfirmedFg);
      case 'assigned':
        return ('Staff assigned', ThemeColors.statusAssignedBg, ThemeColors.statusAssignedFg);
      case 'on_the_way':
        return ('On the way', ThemeColors.statusOnWayBg, ThemeColors.statusOnWayFg);
      case 'in_progress':
        return ('Visit in progress', ThemeColors.statusProgressBg, ThemeColors.statusProgressFg);
      case 'completed':
        return ('Completed', ThemeColors.statusCompletedBg, ThemeColors.statusCompletedFg);
      case 'cancelled':
        return ('Cancelled', ThemeColors.statusCancelledBg, ThemeColors.statusCancelledFg);
      case 'new':
        return ('New', ThemeColors.statusRequestedBg, ThemeColors.statusRequestedFg);
      case 'contacted':
        return ('Contacted', ThemeColors.statusConfirmedBg, ThemeColors.statusConfirmedFg);
      case 'converted':
        return ('Converted', ThemeColors.statusCompletedBg, ThemeColors.statusCompletedFg);
      case 'verified':
        return ('Verified', ThemeColors.statusCompletedBg, ThemeColors.statusCompletedFg);
      case 'pending':
        return ('Pending', ThemeColors.statusRequestedBg, ThemeColors.statusRequestedFg);
      case 'coming_soon':
      case 'soon':
        return ('Coming soon', ThemeColors.surface2, ThemeColors.textMuted);
      default:
        return (status, ThemeColors.surface2, ThemeColors.textLight);
    }
  }
}
