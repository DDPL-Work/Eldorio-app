import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:eldoriaCare/data_handler/repository.dart';
import 'package:eldoriaCare/model/client_models.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/screens/dashboard/controller.dart';
import 'package:eldoriaCare/utils/logger.dart';
import 'package:eldoriaCare/utils/preference.dart';

class BookingsController extends GetxController {
  static BookingsController get to => Get.find();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxList<BookingItem> bookings = <BookingItem>[].obs;
  final RxList<HelpEnquiryItem> enquiries = <HelpEnquiryItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  // ── Computed Getters ────────────────────────────────────────────────────
  List<BookingItem> get activeBookings =>
      bookings.where((b) => b.isActive).toList();

  List<BookingItem> get pastBookings =>
      bookings.where((b) => !b.isActive).toList();

  bool get hasAny =>
      activeBookings.isNotEmpty ||
      pastBookings.isNotEmpty ||
      enquiries.isNotEmpty;

  bool get isEmpty => !hasAny;

  // ── Data Fetching ───────────────────────────────────────────────────────
  Future<void> fetchBookings({bool showLoading = true}) async {
    if (showLoading && bookings.isEmpty) {
      isLoading.value = true;
    }
    errorMessage.value = '';

    try {
      final response = await Repository.instance.getBookings();
      Logger.m(tag: 'Fetch Bookings Response', value: response);

      if (response != null && response is Map) {
        final parsed = BookingsResponse.fromJson(
          Map<String, dynamic>.from(response),
        );
        if (parsed.success) {
          bookings.assignAll(parsed.data);
        } else {
          errorMessage.value = parsed.message.isNotEmpty
              ? parsed.message
              : 'Failed to retrieve bookings';
        }
      }
    } catch (e) {
      Logger.e(tag: 'Fetch Bookings Error', value: e);
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      await loadEnquiries();
    }
  }

  Future<void> loadEnquiries() async {
    try {
      final jsonStr = LocalDB.clientEnquiriesJson;
      if (jsonStr.isNotEmpty) {
        final List raw = jsonDecode(jsonStr);
        enquiries.assignAll(
          raw.map(
            (e) => HelpEnquiryItem.fromJson(Map<String, dynamic>.from(e)),
          ),
        );
      }
    } catch (e) {
      Logger.e(tag: 'Load Enquiries Error', value: e);
    }
  }

  // ── Formatting and Helper Methods ───────────────────────────────────────
  String formatDate(String iso) {
    try {
      final parts = iso.split('-');
      if (parts.length == 3) {
        final d = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final target = DateTime(d.year, d.month, d.day);
        final diff = target.difference(today).inDays;

        if (diff == 0) return 'Today';
        if (diff == 1) return 'Tomorrow';
        if (diff == -1) return 'Yesterday';
        return DateFormat('d MMM').format(d);
      }
    } catch (_) {}
    return iso;
  }

  String formatTimeAgo(int timestamp) {
    if (timestamp <= 0) return '';
    final now = DateTime.now().millisecondsSinceEpoch;
    final diffMin = ((now - timestamp) / 60000).round();
    if (diffMin < 1) return 'Just now';
    if (diffMin < 60) return '${diffMin}m ago';
    final diffHours = (diffMin / 60).round();
    if (diffHours < 24) return '${diffHours}h ago';
    final diffDays = (diffHours / 24).round();
    return '${diffDays}d ago';
  }

  String getStaffInitials(BookingItem b) {
    if (b.assignedStaff != null && b.assignedStaff!.initials.isNotEmpty) {
      return b.assignedStaff!.initials;
    }
    return 'ST';
  }

  bool hasStaffAvatar(BookingItem b) {
    return b.assignedStaff != null;
  }

  String getPriceString(BookingItem b) {
    return b.formattedPrice;
  }

  String getServiceIcon(String? serviceId) {
    if (serviceId == null || serviceId.isEmpty) return 'cross';
    final id = serviceId.toLowerCase();
    if (id.contains('senior') || id.contains('elder')) return 'heart';
    if (id.contains('caregiver') || id.contains('attendant')) return 'heart';
    if (id.contains('nursing') ||
        id.contains('injection') ||
        id.contains('wound') ||
        id.contains('catheter') ||
        id.contains('ryles')) {
      return 'cross';
    }
    if (id.contains('icu') || id.contains('pulse') || id.contains('vitals')) {
      return 'pulse';
    }
    if (id.contains('livein') || id.contains('home')) return 'home';
    if (id.contains('stroke') ||
        id.contains('dementia') ||
        id.contains('alzheimer')) {
      return 'brain';
    }
    if (id.contains('bed') ||
        id.contains('paralysis') ||
        id.contains('surgery')) {
      return 'bed';
    }
    if (id.contains('cancer') || id.contains('ribbon')) return 'ribbon';
    return 'cross';
  }

  // ── Navigation Actions ──────────────────────────────────────────────────
  void onBookingTapped(BookingItem b) {
    Get.toNamed(AppRoutes.booking, arguments: b.id);
  }

  void onEnquiryTapped(HelpEnquiryItem e) {
    Get.toNamed(AppRoutes.helpDone, arguments: e.id);
  }

  void onBookServicePressed() {
    DashboardController.to.currentNavIndex.value = 0;
  }
}
