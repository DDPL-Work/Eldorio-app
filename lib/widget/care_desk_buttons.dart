import 'package:eldoriaCare/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

  static Future<void> launchCall(String? phone) async {
    final p = (phone != null && phone.isNotEmpty) ? phone : '';
    final digits = p.replaceAll(RegExp(r'\D'), '');
    final url = 'tel:+91$digits';
    Helper.openUrl(url, launchMode: LaunchMode.externalApplication);
  }

  static Future<void> launchWhatsApp(String? phone, {String? text}) async {
    final p = (phone != null && phone.isNotEmpty) ? phone : '';
    final digits = p.replaceAll(RegExp(r'\D'), '');
    final msg = Uri.encodeComponent(
      text ?? 'Hello Eldoria, I need help with home care.',
    );
    final url = 'https://wa.me/+91$digits?text=$msg';

    Helper.openUrl(url, launchMode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final effectivePhone = phone ?? '';
    final effectiveWa = whatsapp ?? '';

    return Row(
      children: [
        // Call Button
        Expanded(
          child: InkWell(
            onTap: () => launchCall(effectivePhone),
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
                    color: isAccentCall
                        ? ThemeColors.deepNavy
                        : ThemeColors.textWhite,
                    size: 4.8.w,
                  ),
                  2.w.hs,
                  Text(
                    'Call $effectivePhone',
                    style: TextStyle(
                      color: isAccentCall
                          ? ThemeColors.deepNavy
                          : ThemeColors.textWhite,
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
            onTap: () => launchWhatsApp(
              effectiveWa,
              text:
                  whatsappPrefill ??
                  'Hello Eldoria, I need help with home care.',
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
