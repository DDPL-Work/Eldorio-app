import 'package:flutter/material.dart';
import 'package:eldoriaCare/data_handler/client_data_controller.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';

class CareDeskButtons extends StatelessWidget {
  final String? phone;
  final String? whatsapp;
  final String? whatsappPrefill;
  final bool isAccentCall;

  const CareDeskButtons({
    super.key,
    this.phone,
    this.whatsapp,
    this.whatsappPrefill,
    this.isAccentCall = true,
  });

  @override
  Widget build(BuildContext context) {
    final c = ClientDataController.to;
    final effectivePhone = phone ?? c.careDeskPhone.value;
    final effectiveWa = whatsapp ?? c.careDeskWhatsapp.value;

    return Row(
      children: [
        // Call Button
        Expanded(
          child: InkWell(
            onTap: () => c.makePhoneCall(effectivePhone),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 1.3.h),
              decoration: BoxDecoration(
                gradient: isAccentCall
                    ? const LinearGradient(
                        colors: [
                          ThemeColors.goldenAmberLight,
                          ThemeColors.goldenAmber,
                          ThemeColors.goldenAmberDark,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isAccentCall ? null : ThemeColors.brandNavySoft,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isAccentCall
                    ? [
                        BoxShadow(
                          color: ThemeColors.glowAmber,
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.phone_rounded,
                    color: isAccentCall ? ThemeColors.deepNavy : ThemeColors.textWhite,
                    size: 4.8.w,
                  ),
                  2.w.hs,
                  Text(
                    'Call $effectivePhone',
                    style: TextStyle(
                      color: isAccentCall ? ThemeColors.deepNavy : ThemeColors.textWhite,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        3.w.hs,

        // WhatsApp Button
        Expanded(
          child: InkWell(
            onTap: () => c.openWhatsApp(
              effectiveWa,
              text: whatsappPrefill ?? 'Hello Eldoria, I need help with home care.',
            ),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 1.3.h),
              decoration: BoxDecoration(
                color: ThemeColors.whatsAppGreen,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: ThemeColors.whatsAppGreen.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: ThemeColors.textWhite,
                    size: 4.8.w,
                  ),
                  2.w.hs,
                  Text(
                    'WhatsApp',
                    style: TextStyle(
                      color: ThemeColors.textWhite,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
