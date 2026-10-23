import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/model/staff_profile.dart';
import 'package:eldoriaCare/screens/auth/track_joining_status/controller.dart';
import 'package:eldoriaCare/utils/helper.dart';
import 'package:eldoriaCare/widget/my_button.dart';

class TrackApplicationScreen extends StatelessWidget {
  const TrackApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(JoiningStatusController());

    return Scaffold(
      backgroundColor: ThemeColors.appBackgroundDeep,
      appBar: AppBar(
        backgroundColor: ThemeColors.sceneDarkNavy,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ThemeColors.textWhite,
            size: 20.sp,
          ),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => Text(
            c.appBarTitle,
            style: TextStyle(
              color: ThemeColors.textWhite,
              fontWeight: FontWeight.w800,
              fontSize: 18.sp,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => c.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                    color: ThemeColors.goldenAmber,
                  ),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.8.w,
                    vertical: 2.h,
                  ),
                  child: c.application.value == null
                      ? _buildSearchLookupView(c)
                      : _buildApplicationDetailView(c, c.application.value!),
                ),
        ),
      ),
    );
  }

  Widget _buildSearchLookupView(JoiningStatusController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        12.vs,
        Text(
          'Track your onboarding application',
          style: TextStyle(
            color: ThemeColors.textWhite,
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        6.vs,
        Text(
          'Enter the 10-digit mobile number you used while submitting your details.',
          style: TextStyle(color: ThemeColors.textMuted, fontSize: 13.5.sp),
        ),
        20.vs,

        // Phone Input
        Container(
          decoration: BoxDecoration(
            color: ThemeColors.inputBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ThemeColors.lineBorder),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.6.w,
                  vertical: 1.6.h,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: ThemeColors.lineBorder),
                  ),
                ),
                child: Text(
                  '+91',
                  style: TextStyle(
                    color: ThemeColors.textWhite,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: c.phoneSearchCtrl,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  style: TextStyle(
                    color: ThemeColors.textWhite,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: '98765 43210',
                    hintStyle: TextStyle(
                      color: ThemeColors.textPlaceholder,
                      fontSize: 14.sp,
                    ),
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 3.6.w),
                  ),
                ),
              ),
            ],
          ),
        ),

        if (c.searchError.value != null) ...[
          10.vs,
          Container(
            padding: EdgeInsets.all(2.5.w),
            decoration: BoxDecoration(
              color: ThemeColors.errorRedBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              c.searchError.value!,
              style: TextStyle(
                color: ThemeColors.errorRedColor,
                fontSize: 13.sp,
              ),
            ),
          ),
        ],

        20.vs,

        MyButton(label: 'Find my application', onPressed: c.findApplication),
        14.vs,

        OutlinedButton(
          onPressed: c.startNewApplication,
          style: OutlinedButton.styleFrom(
            foregroundColor: ThemeColors.textWhite,
            side: const BorderSide(color: ThemeColors.whiteBorder40),
            padding: EdgeInsets.symmetric(vertical: 1.6.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Start a new application',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildApplicationDetailView(
    JoiningStatusController c,
    StaffModel app,
  ) {
    // Status Colors & Texts from Staff-app.html
    Color boxBg;
    Color boxFg;
    String boxTitle;
    String boxMessage;
    Color pillBg;
    Color pillFg;
    String pillText;

    if (app.isApproved) {
      boxBg = ThemeColors.successGreenBg;
      boxFg = ThemeColors.successGreen;
      boxTitle = 'You are approved!';
      boxMessage =
          'Welcome to Eldoria Care at Home. Sign in to the Staff app to start receiving visits.';
      pillBg = ThemeColors.successGreenBg;
      pillFg = ThemeColors.successGreen;
      pillText = 'Approved';
    } else if (app.isChanges) {
      boxBg = ThemeColors.infoBlueBg;
      boxFg = ThemeColors.infoBlueFg;
      boxTitle = 'Please update your application';
      boxMessage = 'The care desk has asked for a few changes before approval.';
      pillBg = ThemeColors.infoBlueBg;
      pillFg = ThemeColors.infoBlueFg;
      pillText = 'Changes requested';
    } else if (app.isRejected) {
      boxBg = ThemeColors.errorRedBg;
      boxFg = ThemeColors.errorRedColor;
      boxTitle = 'Application not approved';
      boxMessage = 'We are unable to approve this application right now.';
      pillBg = ThemeColors.errorRedBg;
      pillFg = ThemeColors.errorRedColor;
      pillText = 'Not approved';
    } else {
      boxBg = ThemeColors.goldenAmberBg;
      boxFg = ThemeColors.goldenAmberLight;
      boxTitle = 'Your application is under review';
      boxMessage =
          'Our care desk is checking your details and documents. We will contact you on +91 ${app.phone}.';
      pillBg = ThemeColors.goldenAmberBg;
      pillFg = ThemeColors.goldenAmberLight;
      pillText = 'Under review';
    }

    final formattedDate = app.submittedAt != null
        ? app.submittedAt!
        : 'Recently';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Profile Card
        Row(
          children: [
            CircleAvatar(
              radius: 7.2.w,
              backgroundColor: ThemeColors.skinTone,
              child: Text(
                app.initials,
                style: TextStyle(
                  color: ThemeColors.chipSelectedBg,
                  fontWeight: FontWeight.w800,
                  fontSize: 18.sp,
                ),
              ),
            ),
            14.hs,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    app.name,
                    style: TextStyle(
                      color: ThemeColors.textWhite,
                      fontWeight: FontWeight.w800,
                      fontSize: 18.sp,
                    ),
                  ),
                  2.vs,
                  Text(
                    'Applied $formattedDate',
                    style: TextStyle(
                      color: ThemeColors.textMuted,
                      fontSize: 12.5.sp,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.6.w, vertical: 0.6.h),
              decoration: BoxDecoration(
                color: pillBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                pillText,
                style: TextStyle(
                  color: pillFg,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        18.vs,

        // Status Notification Banner Box
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: boxBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                boxTitle,
                style: TextStyle(
                  color: boxFg,
                  fontWeight: FontWeight.w800,
                  fontSize: 16.sp,
                ),
              ),
              4.vs,
              Text(
                boxMessage,
                style: TextStyle(color: boxFg, fontSize: 13.5.sp, height: 1.35),
              ),

              // Care Desk Review Note (if changes requested)
              if (app.notes != null &&
                  app.notes!.isNotEmpty &&
                  !app.isApproved) ...[
                12.vs,
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: ThemeColors.infoBoxBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: ThemeColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NOTE FROM THE CARE DESK',
                        style: TextStyle(
                          color: ThemeColors.textSlateMuted,
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      4.vs,
                      Text(
                        app.notes!,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: ThemeColors.textWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        18.vs,

        // Action Buttons
        if (app.isApproved) ...[
          MyButton(
            label: 'Sign in to the Staff app',
            color: ThemeColors.goldenAmber,
            onPressed: c.signInApproved,
          ),
        ] else if (Helper.isTester) ...[
          MyButton(
            label: 'Sign in to the Staff app',
            color: ThemeColors.goldenAmber,
            onPressed: c.signInApproved,
          ),
          12.vs,
          MyButton(
            label: app.isChanges ? 'Edit & resubmit' : 'Edit my application',
            variant: ButtonVariant.secondary,
            onPressed: c.editApplication,
          ),
        ] else if (app.isChanges || app.isPending) ...[
          MyButton(
            label: app.isChanges ? 'Edit & resubmit' : 'Edit my application',
            color: app.isChanges ? ThemeColors.goldenAmber : null,
            onPressed: c.editApplication,
          ),
        ],

        18.vs,

        // History Timeline Card
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: ThemeColors.cardSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ThemeColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Application history',
                style: TextStyle(
                  color: ThemeColors.textWhite,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
        ),

        16.vs,

        // Find different application
        TextButton(
          onPressed: c.findDifferentApplication,
          child: Text(
            'Find a different application',
            style: TextStyle(
              color: ThemeColors.goldenAmber,
              fontWeight: FontWeight.w700,
              fontSize: 13.5.sp,
            ),
          ),
        ),
      ],
    );
  }
}
