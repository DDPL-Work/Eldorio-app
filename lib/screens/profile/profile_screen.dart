import 'package:eldoriaCare/model/profile_model.dart';
import 'package:eldoriaCare/screens/profile/controller.dart';
import 'package:eldoriaCare/utils/helper.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:eldoriaCare/widget/care_desk_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ProfileController());

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
      body: RefreshIndicator(
        color: ThemeColors.goldenAmber,
        backgroundColor: ThemeColors.cardSurface,
        onRefresh: () => c.fetchProfile(showLoading: false),
        child: Obx(() {
          if (c.isProfileLoading.value && c.profileData.value == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: ThemeColors.goldenAmber,
                  ),
                  2.h.vs,
                  Text(
                    'Loading profile...',
                    style: TextStyle(
                      color: ThemeColors.textMuted,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              // ── 1. Hero Profile Header Card ─────────────────────────────
              _buildHeaderCard(c),

              2.2.h.vs,

              // ── 2. Contact & Personal Details Card ──────────────────────
              _buildPersonalDetailsCard(c),

              // ── 3. Professional & Work Details (if Staff / Present) ──────
              if (c.hasWorkDetails) ...[2.2.h.vs, _buildWorkDetailsCard(c)],

              // ── 4. Verified Documents Card ──────────────────────────────
              if (c.hasDocuments) ...[2.2.h.vs, _buildDocumentsCard(c)],

              // ── 5. Emergency Contact Card ───────────────────────────────
              if (c.hasEmergencyContact) ...[
                2.2.h.vs,
                _buildEmergencyContactCard(c),
              ],

              2.2.h.vs,

              // ── 6. Care Desk Card ───────────────────────────────────────
              _buildCareDeskCard(),

              2.5.h.vs,

              // ── 7. Danger Log Out Button ────────────────────────────────
              _buildSignOutButton(c),

              4.h.vs,
            ],
          );
        }),
      ),
    );
  }

  // ── Header Card ─────────────────────────────────────────────────────────
  Widget _buildHeaderCard(ProfileController c) {
    return Container(
      padding: EdgeInsets.all(4.5.w),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ThemeColors.cardBorder),
        boxShadow: const [
          BoxShadow(
            color: ThemeColors.shadowColorDark,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar circle with initials
          Container(
            width: 15.w,
            height: 15.w,
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
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          4.w.hs,

          // Name, Staff ID & Badges
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.displayName,
                  style: TextStyle(
                    color: ThemeColors.textWhite,
                    fontSize: 16.5.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                0.5.h.vs,
                Wrap(
                  spacing: 2.w,
                  runSpacing: 0.6.h,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Role Pill
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.5.w,
                        vertical: 0.3.h,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeColors.brandBlue.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: ThemeColors.brandBlueLight.withValues(
                            alpha: 0.4,
                          ),
                        ),
                      ),
                      child: Text(
                        c.displayRole.toUpperCase(),
                        style: TextStyle(
                          color: ThemeColors.brandBlueLight,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    // Approval Pill
                    if (c.isApproved)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.2.w,
                          vertical: 0.3.h,
                        ),
                        decoration: BoxDecoration(
                          color: ThemeColors.successGreenBg,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: ThemeColors.successGreen.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              size: 10.sp,
                              color: ThemeColors.successGreen,
                            ),
                            1.w.hs,
                            Text(
                              'Approved',
                              style: TextStyle(
                                color: ThemeColors.successGreen,
                                fontSize: 9.5.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Staff Duty Indicator
                    if (c.isStaff)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.2.w,
                          vertical: 0.3.h,
                        ),
                        decoration: BoxDecoration(
                          color: c.isOnDuty
                              ? ThemeColors.successGreenBg
                              : ThemeColors.surface2,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: c.isOnDuty
                                    ? ThemeColors.dutyGreen
                                    : ThemeColors.textMuted,
                                shape: BoxShape.circle,
                              ),
                            ),
                            1.w.hs,
                            Text(
                              c.isOnDuty ? 'On Duty' : 'Off Duty',
                              style: TextStyle(
                                color: c.isOnDuty
                                    ? ThemeColors.dutyGreen
                                    : ThemeColors.textMuted,
                                fontSize: 9.5.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                if (c.displayStaffId.isNotEmpty) ...[
                  0.6.h.vs,
                  Text(
                    'ID: ${c.displayStaffId}',
                    style: TextStyle(
                      color: ThemeColors.goldenAmberLight,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Personal & Contact Details Card ─────────────────────────────────────
  Widget _buildPersonalDetailsCard(ProfileController c) {
    return Container(
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
            'Personal Details',
            style: TextStyle(
              color: ThemeColors.textWhite,
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          1.2.h.vs,
          if (c.formattedPhone.isNotEmpty)
            _buildInfoRow(
              icon: Icons.phone_android_rounded,
              label: 'Phone',
              value: c.formattedPhone,
            ),
          if (c.displayEmail.isNotEmpty)
            _buildInfoRow(
              icon: Icons.mail_outline_rounded,
              label: 'Email',
              value: c.displayEmail,
            ),
          if (c.dob.isNotEmpty)
            _buildInfoRow(
              icon: Icons.cake_outlined,
              label: 'Date of Birth',
              value: c.dob,
            ),
          if (c.formattedGender.isNotEmpty)
            _buildInfoRow(
              icon: Icons.person_outline_rounded,
              label: 'Gender',
              value: c.formattedGender,
            ),
          if (c.city.isNotEmpty)
            _buildInfoRow(
              icon: Icons.location_city_rounded,
              label: 'City',
              value: c.city,
            ),
          if (c.area.isNotEmpty)
            _buildInfoRow(
              icon: Icons.map_outlined,
              label: 'Area / Suburbs',
              value: c.area,
            ),
          if (c.address.isNotEmpty)
            _buildInfoRow(
              icon: Icons.home_outlined,
              label: 'Address',
              value: c.address,
            ),
        ],
      ),
    );
  }

  // ── Work & Professional Card ────────────────────────────────────────────
  Widget _buildWorkDetailsCard(ProfileController c) {
    return Container(
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
            'Work & Qualifications',
            style: TextStyle(
              color: ThemeColors.textWhite,
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          1.2.h.vs,
          if (c.qualification.isNotEmpty)
            _buildInfoRow(
              icon: Icons.school_outlined,
              label: 'Qualification',
              value: c.qualification,
            ),
          if (c.regNo.isNotEmpty)
            _buildInfoRow(
              icon: Icons.badge_outlined,
              label: 'Registration No.',
              value: c.regNo,
            ),
          if (c.experience.isNotEmpty)
            _buildInfoRow(
              icon: Icons.work_history_outlined,
              label: 'Experience',
              value: c.experience,
            ),

          // Skills Chips
          if (c.skills.isNotEmpty)
            _buildChipSection(
              title: 'Skills & Care Expertise',
              items: c.skills,
              chipColor: ThemeColors.brandBlueLight,
              chipBg: ThemeColors.infoBlueBg,
            ),

          // Language Chips
          if (c.languages.isNotEmpty)
            _buildChipSection(
              title: 'Languages',
              items: c.languages,
              chipColor: ThemeColors.goldenAmberLight,
              chipBg: ThemeColors.goldenAmberBg,
            ),

          // Availability Chips
          if (c.formattedAvailability.isNotEmpty)
            _buildChipSection(
              title: 'Availability',
              items: c.formattedAvailability,
              chipColor: ThemeColors.successGreen,
              chipBg: ThemeColors.successGreenBg,
            ),
        ],
      ),
    );
  }

  // ── Documents & Verification Card ───────────────────────────────────────
  Widget _buildDocumentsCard(ProfileController c) {
    return Container(
      padding: EdgeInsets.all(4.5.w),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ThemeColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Documents & KYC',
                style: TextStyle(
                  color: ThemeColors.textWhite,
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.2.w,
                  vertical: 0.3.h,
                ),
                decoration: BoxDecoration(
                  color: c.isDocsVerified
                      ? ThemeColors.successGreenBg
                      : ThemeColors.goldenAmberBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: c.isDocsVerified
                        ? ThemeColors.successGreen
                        : ThemeColors.goldenAmber,
                    width: 0.8,
                  ),
                ),
                child: Text(
                  c.isDocsVerified ? 'Verified' : 'In Review',
                  style: TextStyle(
                    color: c.isDocsVerified
                        ? ThemeColors.successGreen
                        : ThemeColors.goldenAmber,
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          1.5.h.vs,
          ...c.documents.entries.map((e) => _buildDocRow(c, e.key, e.value)),
        ],
      ),
    );
  }

  // ── Emergency Contact Card ──────────────────────────────────────────────
  Widget _buildEmergencyContactCard(ProfileController c) {
    return Container(
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
            'Emergency Contact',
            style: TextStyle(
              color: ThemeColors.textWhite,
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          1.2.h.vs,
          if (c.emergencyContactPerson.isNotEmpty)
            _buildInfoRow(
              icon: Icons.contact_emergency_rounded,
              label: 'Contact Person',
              value: c.emergencyContactPerson,
            ),
          if (c.emergencyFormattedPhone.isNotEmpty)
            _buildInfoRow(
              icon: Icons.phone_callback_rounded,
              label: 'Emergency Phone',
              value: c.emergencyFormattedPhone,
            ),
        ],
      ),
    );
  }

  // ── Care Desk Card ──────────────────────────────────────────────────────
  Widget _buildCareDeskCard() {
    return Container(
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
    );
  }

  // ── Sign Out Button ─────────────────────────────────────────────────────
  Widget _buildSignOutButton(ProfileController c) {
    return SizedBox(
      width: double.infinity,
      height: 5.6.h,
      child: OutlinedButton(
        onPressed: Helper.logOut,
        style: OutlinedButton.styleFrom(
          foregroundColor: ThemeColors.errorRedColor,
          side: BorderSide(
            color: ThemeColors.errorRedColor.withValues(alpha: 0.4),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: c.isLoading.value
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
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
              ),
      ),
    );
  }

  // ── Presentational UI Helpers ───────────────────────────────────────────
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    if (value.trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: ThemeColors.surface2,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 14.sp, color: ThemeColors.brandBlueLight),
          ),
          3.w.hs,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: ThemeColors.textMuted,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                0.2.h.vs,
                Text(
                  value,
                  style: TextStyle(
                    color: ThemeColors.textWhite,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipSection({
    required String title,
    required List<String> items,
    required Color chipColor,
    required Color chipBg,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        1.2.h.vs,
        Text(
          title,
          style: TextStyle(
            color: ThemeColors.textMuted,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        0.8.h.vs,
        Wrap(
          spacing: 2.w,
          runSpacing: 0.8.h,
          children: items.map((item) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 2.8.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: chipBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: chipColor.withValues(alpha: 0.35),
                  width: 0.8,
                ),
              ),
              child: Text(
                item,
                style: TextStyle(
                  color: chipColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDocRow(ProfileController c, String key, ProfileDocFile doc) {
    final label = c.getDocLabel(key);
    final isPdf = c.isPdfDoc(doc);

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.2.h),
      decoration: BoxDecoration(
        color: ThemeColors.surface2.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeColors.lineBorder.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: ThemeColors.cardSurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isPdf ? Icons.picture_as_pdf_rounded : Icons.image_rounded,
              size: 16.sp,
              color: isPdf
                  ? ThemeColors.errorRedColor
                  : ThemeColors.goldenAmber,
            ),
          ),
          3.w.hs,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: ThemeColors.textWhite,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (doc.name != null && doc.name!.isNotEmpty) ...[
                  0.2.h.vs,
                  Text(
                    doc.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: ThemeColors.textMuted,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          2.w.hs,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
            decoration: BoxDecoration(
              color: doc.verified
                  ? ThemeColors.successGreenBg
                  : ThemeColors.goldenAmberBg,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: doc.verified
                    ? ThemeColors.successGreen
                    : ThemeColors.goldenAmber,
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  doc.verified
                      ? Icons.check_circle_rounded
                      : Icons.pending_rounded,
                  size: 10.sp,
                  color: doc.verified
                      ? ThemeColors.successGreen
                      : ThemeColors.goldenAmber,
                ),
                1.w.hs,
                Text(
                  doc.verified ? 'Verified' : 'Pending',
                  style: TextStyle(
                    color: doc.verified
                        ? ThemeColors.successGreen
                        : ThemeColors.goldenAmber,
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
