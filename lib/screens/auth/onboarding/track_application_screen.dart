import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:eldoriaCare/data_handler/staff_service.dart';
import 'package:eldoriaCare/model/staff_model.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/utils/toasty.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:eldoriaCare/widget/my_button.dart';

class TrackApplicationScreen extends StatefulWidget {
  const TrackApplicationScreen({super.key});

  @override
  State<TrackApplicationScreen> createState() => _TrackApplicationScreenState();
}

class _TrackApplicationScreenState extends State<TrackApplicationScreen> {
  final staffService = StaffService.instance;
  final phoneSearchCtrl = TextEditingController();

  StaffModel? application;
  bool isLoading = true;
  String? searchError;

  static const Color bgColor = ThemeColors.appBackgroundDeep;
  static const Color appBarColor = ThemeColors.sceneDarkNavy;
  static const Color cardColor = ThemeColors.cardSurface;
  static const Color cardBorderColor = ThemeColors.cardBorder;
  static const Color inputBgColor = ThemeColors.inputBg;
  static const Color inputBorderColor = ThemeColors.lineBorder;
  static const Color textMutedColor = ThemeColors.textMuted;
  static const Color textLabelColor = ThemeColors.textSlateMuted;

  @override
  void initState() {
    super.initState();
    _loadInitialApplication();
  }

  @override
  void dispose() {
    phoneSearchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadInitialApplication() async {
    setState(() => isLoading = true);
    try {
      final args = Get.arguments;
      String? trackId;
      if (args is Map) {
        trackId = args['trackId']?.toString();
      }

      if (trackId != null && trackId.isNotEmpty) {
        application = await staffService.getApplicationById(trackId);
      } else {
        application = await staffService.getCurrentApplicant();
      }
    } catch (_) {
      // Ignored
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _findApplication() async {
    final rawPhone = phoneSearchCtrl.text.trim();
    if (rawPhone.replaceAll(RegExp(r'\D'), '').length != 10) {
      setState(() => searchError = 'Enter a valid 10-digit mobile number');
      return;
    }

    setState(() {
      isLoading = true;
      searchError = null;
    });

    try {
      final found = await staffService.findApplicationByPhone(rawPhone);
      if (found != null) {
        setState(() => application = found);
      } else {
        setState(() {
          searchError = 'No application found with this mobile number.';
        });
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _editApplication() {
    if (application == null) return;
    Get.toNamed(
      AppRoutes.joinStaff,
      arguments: {'application': application, 'editId': application!.id},
    );
  }

  Future<void> _signInApproved() async {
    if (application == null) return;
    setState(() => isLoading = true);
    try {
      await staffService.loginAsStaff(application!);
      Toasty.success('Welcome to Eldoria Care, ${application!.name}!');
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Toasty.failed('Sign in error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.initWithContext(context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: ThemeColors.textWhite, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        title: Text(
          application != null ? 'My application' : 'Track application',
          style: TextStyle(
            color: ThemeColors.textWhite,
            fontWeight: FontWeight.w800,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: ThemeColors.goldenAmber),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 4.8.w, vertical: 2.h),
                child: application == null
                    ? _buildSearchLookupView()
                    : _buildApplicationDetailView(),
              ),
      ),
    );
  }

  // ── 1. Lookup View (Search by Mobile) ────────────────────────────────
  Widget _buildSearchLookupView() {
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
          style: TextStyle(
            color: textMutedColor,
            fontSize: 13.5.sp,
          ),
        ),
        20.vs,

        // Phone Input
        Container(
          decoration: BoxDecoration(
            color: inputBgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: inputBorderColor),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.6.w, vertical: 1.6.h),
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: inputBorderColor),
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
                  controller: phoneSearchCtrl,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  style: TextStyle(
                    color: ThemeColors.textWhite,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: '98765 43210',
                    hintStyle: TextStyle(color: ThemeColors.textPlaceholder, fontSize: 14.sp),
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 3.6.w),
                  ),
                ),
              ),
            ],
          ),
        ),

        if (searchError != null) ...[
          10.vs,
          Container(
            padding: EdgeInsets.all(2.5.w),
            decoration: BoxDecoration(
              color: ThemeColors.errorRedBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              searchError!,
              style: TextStyle(color: ThemeColors.errorRedColor, fontSize: 13.sp),
            ),
          ),
        ],

        20.vs,

        MyButton(
          label: 'Find my application',
          onPressed: _findApplication,
        ),
        14.vs,

        OutlinedButton(
          onPressed: () => Get.toNamed(AppRoutes.joinStaff),
          style: OutlinedButton.styleFrom(
            foregroundColor: ThemeColors.textWhite,
            side: const BorderSide(color: ThemeColors.whiteBorder40),
            padding: EdgeInsets.symmetric(vertical: 1.6.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            'Start a new application',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp),
          ),
        ),
      ],
    );
  }

  // ── 2. Detailed Status View ─────────────────────────────────────────
  Widget _buildApplicationDetailView() {
    final app = application!;

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
      boxMessage = 'Welcome to Eldoria Care at Home. Sign in to the Staff app to start receiving visits.';
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
      boxMessage = 'Our care desk is checking your details and documents. We will contact you on +91 ${app.phone}.';
      pillBg = ThemeColors.goldenAmberBg;
      pillFg = ThemeColors.goldenAmberLight;
      pillText = 'Under review';
    }

    final formattedDate = app.submittedAt != null
        ? DateFormat('dd MMM yyyy, h:mm a').format(
            DateTime.fromMillisecondsSinceEpoch(app.submittedAt!),
          )
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
                      color: textMutedColor,
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
                style: TextStyle(
                  color: boxFg,
                  fontSize: 13.5.sp,
                  height: 1.35,
                ),
              ),

              // Care Desk Review Note (if changes requested)
              if (app.reviewNote != null && app.reviewNote!.isNotEmpty && !app.isApproved) ...[
                12.vs,
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: ThemeColors.infoBoxBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: cardBorderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NOTE FROM THE CARE DESK',
                        style: TextStyle(
                          color: textLabelColor,
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      4.vs,
                      Text(
                        app.reviewNote!,
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
        if (app.isApproved)
          MyButton(
            label: 'Sign in to the Staff app',
            color: ThemeColors.goldenAmber,
            onPressed: _signInApproved,
          )
        else if (app.isChanges || app.isPending)
          MyButton(
            label: app.isChanges ? 'Edit & resubmit' : 'Edit my application',
            color: app.isChanges ? ThemeColors.goldenAmber : null,
            onPressed: _editApplication,
          ),

        18.vs,

        // History Timeline Card
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cardBorderColor),
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
              14.vs,
              if (app.appHistory.isEmpty)
                Text(
                  'No events recorded yet.',
                  style: TextStyle(color: textMutedColor, fontSize: 13.sp),
                )
              else
                ...app.appHistory.map(_buildTimelineItem),
            ],
          ),
        ),

        16.vs,

        // Find different application
        TextButton(
          onPressed: () {
            setState(() {
              application = null;
              phoneSearchCtrl.clear();
            });
          },
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

  Widget _buildTimelineItem(Map<String, dynamic> item) {
    final status = item['status']?.toString() ?? 'pending';
    final by = item['by']?.toString() ?? '';
    final note = item['note']?.toString() ?? '';
    final at = item['at'] is int
        ? DateFormat('dd MMM yyyy, h:mm a').format(
            DateTime.fromMillisecondsSinceEpoch(item['at'] as int),
          )
        : '';

    Color dotColor = ThemeColors.goldenAmber;
    String statusTitle = 'Under review';

    if (status == 'approved') {
      dotColor = ThemeColors.successGreenBorder;
      statusTitle = 'Approved';
    } else if (status == 'changes') {
      dotColor = ThemeColors.statusSkyBlue;
      statusTitle = 'Changes requested';
    } else if (status == 'rejected') {
      dotColor = ThemeColors.statusRed;
      statusTitle = 'Not approved';
    }

    if (by == 'admin') {
      statusTitle += ' · Care Desk';
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 0.6.h),
            width: 2.4.w,
            height: 2.4.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor,
            ),
          ),
          12.hs,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusTitle,
                  style: TextStyle(
                    color: ThemeColors.textWhite,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5.sp,
                  ),
                ),
                if (note.isNotEmpty) ...[
                  2.vs,
                  Text(
                    note,
                    style: TextStyle(
                      color: textMutedColor,
                      fontSize: 12.5.sp,
                    ),
                  ),
                ],
                if (at.isNotEmpty) ...[
                  2.vs,
                  Text(
                    at,
                    style: TextStyle(color: ThemeColors.textPlaceholder, fontSize: 11.5.sp),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
