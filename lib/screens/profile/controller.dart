import 'package:eldoriaCare/data_handler/repository.dart';
import 'package:eldoriaCare/model/profile_model.dart';
import 'package:eldoriaCare/utils/logger.dart';
import 'package:eldoriaCare/utils/preference.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();

  final isLoading = false.obs;
  final isProfileLoading = false.obs;
  final Rxn<ProfileData> profileData = Rxn<ProfileData>();
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  // ── Profile and User Accessors ──────────────────────────────────────────
  ProfileUser? get user => profileData.value?.user;

  ProfileDetails? get details => profileData.value?.activeProfile;

  String get displayName {
    if (profileData.value?.displayName.isNotEmpty == true) {
      return profileData.value!.displayName;
    }
    final prefName = Preference.user.userInfo?.name;
    if (prefName != null && prefName.trim().isNotEmpty) {
      return prefName.trim();
    }
    return 'User';
  }

  String get displayPhone {
    if (profileData.value?.displayPhone.isNotEmpty == true) {
      return profileData.value!.displayPhone;
    }
    final prefPhone = Preference.user.userInfo?.phone;
    if (prefPhone != null && prefPhone.trim().isNotEmpty) {
      return prefPhone.trim();
    }
    return '';
  }

  String get formattedPhone {
    final p = displayPhone;
    if (p.isEmpty) return '';
    return p.startsWith('+') ? p : '+91 $p';
  }

  String get displayEmail {
    final email =
        profileData.value?.displayEmail ??
        Preference.user.userInfo?.email ??
        '';
    return email.trim();
  }

  String get displayRole {
    return profileData.value?.displayRole ??
        Preference.user.userInfo?.role ??
        'client';
  }

  String get displayStaffId => profileData.value?.displayStaffId ?? '';

  String get initials {
    if (profileData.value != null && profileData.value!.initials.isNotEmpty) {
      return profileData.value!.initials;
    }
    final name = displayName.trim();
    final parts = name
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'CL';
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length.clamp(0, 2)).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  bool get isStaff =>
      displayRole.toLowerCase() == 'staff' || displayStaffId.isNotEmpty;

  bool get isApproved => details?.approval?.toLowerCase() == 'approved';

  bool get isOnDuty => details?.onDuty == true;

  // ── Personal Details ────────────────────────────────────────────────────
  String get city => details?.city?.trim() ?? '';

  String get area => details?.area?.trim() ?? '';

  String get address => details?.address?.trim() ?? '';

  String get dob => details?.dob?.trim() ?? '';

  String get formattedGender {
    final g = details?.gender?.trim() ?? '';
    if (g.isEmpty) return '';
    return g[0].toUpperCase() + g.substring(1).toLowerCase();
  }

  // ── Work and Professional Qualifications ────────────────────────────────
  bool get hasWorkDetails {
    final d = details;
    if (d == null) return false;
    return (d.qualification != null && d.qualification!.trim().isNotEmpty) ||
        (d.experience != null && d.experience!.trim().isNotEmpty) ||
        (d.regNo != null && d.regNo!.trim().isNotEmpty) ||
        d.skills.isNotEmpty ||
        d.language.isNotEmpty ||
        d.availability.isNotEmpty;
  }

  String get qualification => details?.qualification?.trim() ?? '';

  String get regNo => details?.regNo?.trim() ?? '';

  String get experience => details?.experience?.trim() ?? '';

  List<String> get skills => details?.skills ?? const [];

  List<String> get languages => details?.language ?? const [];

  List<String> get formattedAvailability {
    final list = details?.availability ?? const [];
    return list.map((a) {
      if (a == '24_hour') return '24 Hour Care';
      return a.capitalizeFirst ?? a;
    }).toList();
  }

  // ── Documents and KYC ───────────────────────────────────────────────────
  bool get hasDocuments => details != null && details!.files.isNotEmpty;

  bool get isDocsVerified => details?.docs?.toLowerCase() == 'verified';

  Map<String, ProfileDocFile> get documents => details?.files ?? const {};

  String getDocLabel(String key) {
    switch (key) {
      case 'photo':
        return 'Profile Photo';
      case 'police':
        return 'Police Verification';
      case 'idProof':
        return 'ID Proof / Aadhaar';
      case 'experience':
        return 'Experience Certificate';
      case 'qualification':
        return 'Qualification Certificate';
      default:
        return key.isNotEmpty ? key[0].toUpperCase() + key.substring(1) : key;
    }
  }

  bool isPdfDoc(ProfileDocFile doc) {
    return doc.type?.contains('pdf') == true ||
        (doc.name != null && doc.name!.toLowerCase().endsWith('.pdf'));
  }

  // ── Emergency Contact ───────────────────────────────────────────────────
  bool get hasEmergencyContact {
    final d = details;
    if (d == null) return false;
    return (d.emergencyName != null && d.emergencyName!.trim().isNotEmpty) ||
        (d.emergencyPhone != null && d.emergencyPhone!.trim().isNotEmpty);
  }

  String get emergencyContactPerson {
    final name = details?.emergencyName?.trim() ?? '';
    final rel =
        details?.emergencyRelation != null &&
            details!.emergencyRelation!.trim().isNotEmpty
        ? ' (${details!.emergencyRelation!.trim()})'
        : '';
    return '$name$rel'.trim();
  }

  String get emergencyFormattedPhone {
    final p = details?.emergencyPhone?.trim() ?? '';
    if (p.isEmpty) return '';
    return p.startsWith('+') ? p : '+91 $p';
  }

  // ── API Actions & Flow Logic ────────────────────────────────────────────
  Future<void> fetchProfile({bool showLoading = true}) async {
    if (showLoading && profileData.value == null) {
      isProfileLoading.value = true;
    }
    errorMessage.value = '';

    try {
      final response = await Repository.instance.getProfile();
      Logger.m(tag: 'Fetch Profile Response', value: response);

      if (response != null && response is Map) {
        final profileResponse = ProfileResponse.fromJson(
          Map<String, dynamic>.from(response),
        );

        if (profileResponse.success && profileResponse.data != null) {
          profileData.value = profileResponse.data!;
        } else {
          errorMessage.value = profileResponse.message.isNotEmpty
              ? profileResponse.message
              : 'Failed to load profile';
        }
      }
    } catch (e) {
      Logger.e(tag: 'Fetch Profile Error', value: e);
      errorMessage.value = e.toString();
    } finally {
      isProfileLoading.value = false;
    }
  }
}
