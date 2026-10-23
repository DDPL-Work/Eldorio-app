import 'dart:convert';
import 'package:eldoriaCare/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:eldoriaCare/data_handler/repository.dart';
import 'package:eldoriaCare/model/client_models.dart';
import 'package:eldoriaCare/model/services_model.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/screens/dashboard/controller.dart';
import 'package:eldoriaCare/utils/logger.dart';
import 'package:eldoriaCare/utils/preference.dart';
import 'package:eldoriaCare/widget/soon_bottom_sheet.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  // ── Search State ────────────────────────────────────────────────────────
  final searchQuery = ''.obs;
  final searchController = TextEditingController();

  // ── Loading & Error States ──────────────────────────────────────────────
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // ── Services & Location Data ────────────────────────────────────────────
  final Rxn<ServicesData> servicesData = Rxn<ServicesData>();
  final RxList<OperationalCategoryItem> categories =
      <OperationalCategoryItem>[].obs;
  final RxList<OperationalServiceItem> services =
      <OperationalServiceItem>[].obs;
  final Rxn<ServiceLocation> location = Rxn<ServiceLocation>();

  // ── City State ──────────────────────────────────────────────────────────
  final RxString selectedCity = 'pune'.obs;

  // ── Notifications & Upcoming Visit State ────────────────────────────────
  final RxInt unreadNotificationsCount = 0.obs;
  final Rxn<BookingItem> nextUpcomingBooking = Rxn<BookingItem>();

  @override
  void onInit() {
    super.onInit();
    _initCity();
    loadDashboardData();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // ── Initialization & Data Loading ───────────────────────────────────────
  Future<void> _initCity() async {
    try {
      final userStr = LocalDB.clientUserJson;
      if (userStr.isNotEmpty) {
        final u = jsonDecode(userStr);
        if (u['city'] != null && u['city'].toString().trim().isNotEmpty) {
          final raw = u['city'].toString().trim().toLowerCase();
          final matched = Const.cities.firstWhereOrNull(
            (c) => c.id.toLowerCase() == raw || c.name.toLowerCase() == raw,
          );
          if (matched != null) {
            selectedCity.value = matched.id;
          }
        }
      } else if (Preference.isUserAvailable) {
        final profCity =
            Preference.user.profile?.city ?? Preference.user.userInfo?.city;
        if (profCity != null && profCity.trim().isNotEmpty) {
          final raw = profCity.trim().toLowerCase();
          final matched = Const.cities.firstWhereOrNull(
            (c) => c.id.toLowerCase() == raw || c.name.toLowerCase() == raw,
          );
          if (matched != null) {
            selectedCity.value = matched.id;
          }
        }
      }
    } catch (_) {}
  }

  Future<void> loadDashboardData() async {
    await Future.wait([
      fetchServices(city: selectedCity.value),
      loadNotifications(),
      loadUpcomingBooking(),
    ]);
  }

  // ── Services Fetching ───────────────────────────────────────────────────
  Future<void> fetchServices({String? city, String category = 'all'}) async {
    final activeCity = (city ?? selectedCity.value).trim().toLowerCase();
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await Repository.instance.getServices(
        city: activeCity,
        category: category,
      );
      Logger.m(tag: 'Fetch Services Response', value: response);

      if (response != null && response is Map) {
        final parsed = ServicesResponse.fromJson(
          Map<String, dynamic>.from(response),
        );
        if (parsed.success && parsed.data != null) {
          servicesData.value = parsed.data;
          categories.assignAll(parsed.data!.categories);
          services.assignAll(parsed.data!.services);
          location.value = parsed.data!.location;
        } else {
          errorMessage.value = parsed.message.isNotEmpty
              ? parsed.message
              : 'Failed to retrieve services';
        }
      }
    } catch (e) {
      Logger.e(tag: 'Fetch Services Error', value: e);
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // ── City Actions ────────────────────────────────────────────────────────
  Future<void> onCityChanged(String? val) async {
    if (val == null || val.isEmpty) return;
    selectedCity.value = val;
    try {
      final userStr = LocalDB.clientUserJson;
      Map<String, dynamic> uMap = {};
      if (userStr.isNotEmpty) {
        uMap = Map<String, dynamic>.from(jsonDecode(userStr));
      }
      uMap['city'] = val;
      await LocalDB.setClientUserJson(jsonEncode(uMap));
    } catch (_) {}

    await fetchServices(city: val);
  }

  String cityName(String cityId) {
    final c = Const.cities.firstWhereOrNull(
      (x) =>
          x.id.toLowerCase() == cityId.toLowerCase() ||
          x.name.toLowerCase() == cityId.toLowerCase(),
    );
    return c?.name ?? cityId;
  }

  String get currentCityDisplayName {
    final locCity = location.value?.cityName;
    if (locCity != null && locCity.isNotEmpty) {
      return locCity;
    }
    return cityName(selectedCity.value);
  }

  // ── Notifications Loading ───────────────────────────────────────────────
  Future<void> loadNotifications() async {
    try {
      final nStr = LocalDB.clientNotificationsJson;
      if (nStr.isNotEmpty) {
        final List raw = jsonDecode(nStr);
        final list = raw
            .map(
              (e) =>
                  ClientNotificationItem.fromJson(Map<String, dynamic>.from(e)),
            )
            .toList();
        unreadNotificationsCount.value = list.where((n) => !n.read).length;
      } else {
        unreadNotificationsCount.value = 0;
      }
    } catch (_) {
      unreadNotificationsCount.value = 0;
    }
  }

  void onNotificationTap() {
    DashboardController.to.currentNavIndex.value = 2; // Go to Alerts tab
  }

  // ── Upcoming Booking ────────────────────────────────────────────────────
  Future<void> loadUpcomingBooking() async {
    try {
      final response = await Repository.instance.getBookings();
      if (response != null && response is Map) {
        final parsed = BookingsResponse.fromJson(
          Map<String, dynamic>.from(response),
        );
        if (parsed.success && parsed.data.isNotEmpty) {
          nextUpcomingBooking.value = parsed.data.firstWhereOrNull(
            (b) => b.isActive,
          );
          return;
        }
      }
    } catch (_) {}

    // Fallback to local stored bookings
    try {
      final bStr = LocalDB.clientBookingsJson;
      if (bStr.isNotEmpty) {
        final List raw = jsonDecode(bStr);
        final list = raw
            .map((e) => BookingItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        nextUpcomingBooking.value = list.firstWhereOrNull((b) => b.isActive);
      } else {
        nextUpcomingBooking.value = null;
      }
    } catch (_) {
      nextUpcomingBooking.value = null;
    }
  }

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

  String getStaffInitials(BookingItem b) {
    if (b.assignedStaff != null && b.assignedStaff!.initials.isNotEmpty) {
      return b.assignedStaff!.initials;
    }
    return 'ST';
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

  void onUpcomingBookingTap(BookingItem b) {
    Get.toNamed(AppRoutes.booking, arguments: b.id);
  }

  // ── Search Logic ────────────────────────────────────────────────────────
  void onSearchChanged(String val) {
    searchQuery.value = val;
  }

  void clearSearch() {
    searchQuery.value = '';
    searchController.clear();
  }

  List<OperationalServiceItem> get searchResults {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return [];
    return services.where((s) {
      final nameMatches = s.name.toLowerCase().contains(query);
      final descMatches = s.desc.toLowerCase().contains(query);
      final categoryMatches =
          s.categoryName.toLowerCase().contains(query) ||
          s.category.toLowerCase().contains(query);
      final tasksMatch = s.tasks.any((t) => t.toLowerCase().contains(query));
      return nameMatches || descMatches || categoryMatches || tasksMatch;
    }).toList();
  }

  // ── Screen Navigation Actions ───────────────────────────────────────────
  void onNotSureBannerTap() {
    Get.toNamed(AppRoutes.help);
  }

  void onCategoryTap(OperationalCategoryItem cat, BuildContext context) {
    if (cat.comingSoon) {
      SoonBottomSheet.show(context, title: cat.name, iconKey: cat.icon);
    } else {
      Get.toNamed(
        AppRoutes.category,
        arguments: cat.categoryId.isNotEmpty ? cat.categoryId : cat.id,
      );
    }
  }

  void onServiceBookTap(OperationalServiceItem s, BuildContext context) {
    if (s.comingSoon) {
      SoonBottomSheet.show(context, title: s.name, iconKey: s.icon);
    } else {
      Get.toNamed(
        AppRoutes.book,
        arguments: s.serviceId.isNotEmpty ? s.serviceId : s.id,
      );
    }
  }
}
