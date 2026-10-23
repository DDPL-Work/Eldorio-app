import 'package:eldoriaCare/model/staff_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/screens/profile/controller.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ProfileController());

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 4.8.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Profile',
              style: TextStyle(
                color: ThemeColors.textWhite,
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            2.h.vs,

            Obx(() => _buildProfileCard(c.currentStaff.value)),
            2.5.h.vs,

            _buildSignOutButton(c),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(StaffModel? user) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 7.w,
                backgroundColor: ThemeColors.skinTone,
                child: Text(
                  user?.initials ?? 'AP',
                  style: TextStyle(
                    color: ThemeColors.chipSelectedBg,
                    fontWeight: FontWeight.w800,
                    fontSize: 17.sp,
                  ),
                ),
              ),
              3.5.w.hs,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'Unknown',
                      style: TextStyle(
                        color: ThemeColors.textWhite,
                        fontWeight: FontWeight.w800,
                        fontSize: 18.sp,
                      ),
                    ),
                    0.3.h.vs,
                    Text(
                      user?.role ?? 'User Role',
                      style: TextStyle(
                        color: ThemeColors.textMuted,
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          2.h.vs,

          // Key-Value Rows
          _buildProfileRow('Phone', user?.phone ?? '+91 1234567890'),
          _buildProfileRow('City', user?.cityName ?? 'Mumbai'),
          _buildProfileRow('Area', user?.area ?? 'Andheri, Versova'),
          _buildProfileRow(
            'Skills',
            user != null && user.skills.isNotEmpty
                ? user.skills.join(', ')
                : 'Diabetic care, injections',
          ),
          _buildProfileRow(
            'Documents',
            user != null
                ? (user.isVerified ? 'Verified' : 'Pending verification')
                : 'Verified',
          ),
        ],
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              label,
              style: TextStyle(
                color: ThemeColors.textMuted,
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: ThemeColors.textWhite,
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutButton(ProfileController c) {
    return InkWell(
      onTap: c.signOut,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.6.h),
        decoration: BoxDecoration(
          color: ThemeColors.errorRedBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ThemeColors.signOutBorder),
        ),
        alignment: Alignment.center,
        child: Text(
          'Sign out',
          style: TextStyle(
            color: ThemeColors.errorRedColor,
            fontWeight: FontWeight.w700,
            fontSize: 15.sp,
          ),
        ),
      ),
    );
  }
}
