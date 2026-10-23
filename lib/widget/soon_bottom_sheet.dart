import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/model/client_models.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:eldoriaCare/widget/care_desk_buttons.dart';
import 'package:eldoriaCare/widget/service_icon.dart';

class SoonBottomSheet extends StatelessWidget {
  final ServiceItem? service;
  final String? title;
  final String? iconKey;

  const SoonBottomSheet({
    super.key,
    this.service,
    this.title,
    this.iconKey,
  });

  static void show(
    BuildContext context, {
    ServiceItem? service,
    String? title,
    String? iconKey,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SoonBottomSheet(
        service: service,
        title: title ?? service?.name,
        iconKey: iconKey ?? service?.icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 6.w,
        vertical: 3.h,
      ),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: ThemeColors.cardBorder, width: 1),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grab handle
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: ThemeColors.lineBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            2.5.h.vs,

            // Header row with icon & coming soon badge
            Row(
              children: [
                ServiceIcon(
                  iconKey: iconKey ?? service?.icon ?? 'steth',
                  size: 6.w,
                  containerSize: 12.w,
                ),
                3.w.hs,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? service?.name ?? 'Doctor Services',
                        style: TextStyle(
                          color: ThemeColors.textWhite,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      0.5.h.vs,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.2.w,
                          vertical: 0.3.h,
                        ),
                        decoration: BoxDecoration(
                          color: ThemeColors.surface2,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          'Coming soon',
                          style: TextStyle(
                            color: ThemeColors.textMuted,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            2.h.vs,

            // Explanatory note matching HTML
            Text(
              'We\'re onboarding verified doctors in your city. This service will open here soon. Need a doctor now? Our care desk can guide you.',
              style: TextStyle(
                color: ThemeColors.textMuted,
                fontSize: 13.sp,
                height: 1.45,
              ),
            ),

            2.5.h.vs,

            // Care Desk Buttons
            const CareDeskButtons(),

            2.h.vs,

            // Close button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: ThemeColors.lineBorder),
                  padding: EdgeInsets.symmetric(vertical: 1.4.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: ThemeColors.textLight,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
