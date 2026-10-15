import 'package:flutter/material.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';

class ServiceIcon extends StatelessWidget {
  final String iconKey;
  final double? size;
  final double? containerSize;
  final Color? color;
  final Color? backgroundColor;

  const ServiceIcon({
    super.key,
    required this.iconKey,
    this.size,
    this.containerSize,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final IconData icon = _mapIcon(iconKey);
    final double s = size ?? 5.5.w;
    final double cSize = containerSize ?? (s * 1.8);

    return Container(
      width: cSize,
      height: cSize,
      decoration: BoxDecoration(
        color: backgroundColor ?? ThemeColors.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeColors.cardBorder,
          width: 0.8,
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: s,
        color: color ?? ThemeColors.goldenAmber,
      ),
    );
  }

  IconData _mapIcon(String key) {
    switch (key.toLowerCase()) {
      case 'heart':
        return Icons.favorite_rounded;
      case 'cross':
      case 'local_hospital':
        return Icons.local_hospital_rounded;
      case 'syringe':
        return Icons.vaccines_rounded;
      case 'droplet':
        return Icons.water_drop_rounded;
      case 'bandage':
        return Icons.healing_rounded;
      case 'tube':
        return Icons.medical_services_rounded;
      case 'pulse':
        return Icons.monitor_heart_rounded;
      case 'users':
      case 'people':
        return Icons.people_alt_rounded;
      case 'male':
        return Icons.man_rounded;
      case 'female':
        return Icons.woman_rounded;
      case 'clock':
        return Icons.schedule_rounded;
      case 'home':
        return Icons.home_rounded;
      case 'brain':
        return Icons.psychology_rounded;
      case 'bed':
        return Icons.single_bed_rounded;
      case 'ribbon':
        return Icons.bookmark_added_rounded;
      case 'hand':
        return Icons.front_hand_rounded;
      case 'baby':
        return Icons.child_care_rounded;
      case 'walker':
        return Icons.accessibility_new_rounded;
      case 'wheelchair':
        return Icons.accessible_rounded;
      case 'oxygen':
        return Icons.air_rounded;
      case 'sofa':
        return Icons.chair_rounded;
      case 'steth':
        return Icons.health_and_safety_rounded;
      case 'pin':
        return Icons.location_on_rounded;
      case 'shield':
        return Icons.shield_rounded;
      case 'search':
        return Icons.search_rounded;
      case 'cal':
      case 'calendar':
        return Icons.calendar_month_rounded;
      case 'bell':
        return Icons.notifications_rounded;
      case 'help':
        return Icons.help_outline_rounded;
      default:
        return Icons.favorite_rounded;
    }
  }
}
