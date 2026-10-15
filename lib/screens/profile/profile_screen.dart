import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/data_handler/client_data_controller.dart';
import 'package:eldoriaCare/screens/profile/controller.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:eldoriaCare/widget/care_desk_buttons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ProfileController());
    final clientData = ClientDataController.to;

    return Scaffold(
      backgroundColor: ThemeColors.appBackground,
      appBar: AppBar(
        backgroundColor: ThemeColors.appBar,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: ThemeColors.textWhite,
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        children: [
          // ── User Information Card ─────────────────────────────────────
          Obx(() => Container(
                padding: EdgeInsets.all(4.5.w),
                decoration: BoxDecoration(
                  color: ThemeColors.cardSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ThemeColors.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeColors.shadowColorDark,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Avatar Circle with Initials
                    Container(
                      width: 14.w,
                      height: 14.w,
                      decoration: BoxDecoration(
                        color: ThemeColors.goldenAmberBg,
                        shape: BoxShape.circle,
                        border: Border.all(color: ThemeColors.goldenAmber, width: 1.5),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        c.initials,
                        style: TextStyle(
                          color: ThemeColors.goldenAmber,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),

                    4.w.hs,

                    // Name & Phone
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            clientData.clientName.value,
                            style: TextStyle(
                              color: ThemeColors.textWhite,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          0.4.h.vs,
                          Text(
                            '+91 ${clientData.clientPhone.value}',
                            style: TextStyle(
                              color: ThemeColors.textMuted,
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),

          2.2.h.vs,

          // ── Care Desk Card ────────────────────────────────────────────
          Container(
            padding: EdgeInsets.all(4.5.w),
            decoration: BoxDecoration(
              color: ThemeColors.cardSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: ThemeColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Care desk',
                  style: TextStyle(
                    color: ThemeColors.textWhite,
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                1.5.h.vs,
                const CareDeskButtons(isAccentCall: false),
              ],
            ),
          ),

          2.5.h.vs,

          // ── Danger Log Out Button ─────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 5.6.h,
            child: OutlinedButton(
              onPressed: c.promptSignOut,
              style: OutlinedButton.styleFrom(
                foregroundColor: ThemeColors.errorRedColor,
                side: BorderSide(color: ThemeColors.errorRedColor.withValues(alpha: 0.4)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Obx(
                () => c.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ThemeColors.errorRedColor,
                        ),
                      )
                    : Text(
                        'Log out',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ),

          4.h.vs,
        ],
      ),
    );
  }
}
