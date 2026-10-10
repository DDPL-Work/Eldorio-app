import 'package:get/get.dart';
import 'package:eldoriaCare/data_handler/staff_service.dart';
import 'package:eldoriaCare/model/alert_model.dart';
import 'package:eldoriaCare/model/booking_model.dart';
import 'package:eldoriaCare/model/staff_model.dart';
import 'package:eldoriaCare/utils/toasty.dart';

class DashboardController extends GetxController {
  static DashboardController get to =>
      Get.isRegistered<DashboardController>()
          ? Get.find<DashboardController>()
          : Get.put(DashboardController());

  final staffService = StaffService.instance;

  final currentNavIndex = 0.obs;
  final isLoading = true.obs;
  final currentStaff = Rxn<StaffModel>();

  final bookings = <BookingModel>[].obs;
  final alerts = <AlertModel>[].obs;
  final colleagues = <StaffModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      final staff = await staffService.getCurrentStaff();
      currentStaff.value = staff;

      final bList = await staffService.getBookings();
      bookings.assignAll(bList);

      final aList = await staffService.getAlerts();
      alerts.assignAll(aList);

      final cList = await staffService.getApprovedStaffList();
      colleagues.assignAll(cList.where((s) => s.id != staff.id));
    } catch (_) {
      // Ignored
    } finally {
      isLoading.value = false;
    }
  }

  // ── Computed Getters ────────────────────────────────────────────────
  List<BookingModel> get myVisits {
    final me = currentStaff.value;
    if (me == null) return [];
    return bookings.where((b) => b.staffId == me.id).toList();
  }

  List<BookingModel> get overdueVisits {
    return myVisits.where((b) => !b.isCompleted && (b.date.contains('Mon 5') || b.date.contains('Yesterday'))).toList();
  }

  List<BookingModel> get todayVisits {
    return myVisits.where((b) => !b.isCompleted && b.date.toLowerCase().contains('today')).toList();
  }

  List<BookingModel> get upcomingVisits {
    return myVisits.where((b) => !b.isCompleted && b.date.toLowerCase().contains('tomorrow')).toList();
  }

  List<BookingModel> get completedVisits {
    return myVisits.where((b) => b.isCompleted).toList();
  }

  List<BookingModel> get openRequests {
    return bookings.where((b) => b.isRequested || (b.isConfirmed && b.staffId.isEmpty)).toList();
  }

  int get unreadAlertsCount {
    return alerts.where((a) => !a.isRead).length;
  }

  // ── Actions ─────────────────────────────────────────────────────────

  Future<void> markAllAlertsRead() async {
    for (var a in alerts) {
      a.isRead = true;
    }
    alerts.refresh();
    await staffService.markAllAlertsRead();
    Toasty.success('All notifications marked as read');
  }

  Future<void> markAlertRead(AlertModel alert) async {
    alert.isRead = true;
    alerts.refresh();
    await staffService.saveAlerts(alerts.toList());
  }

  Future<void> acceptRequestSelf(BookingModel b) async {
    final me = currentStaff.value;
    if (me == null) return;

    b.status = 'assigned';
    b.staffId = me.id;
    b.confirmedBy = me.name;
    b.assignedBy = me.name;

    bookings.refresh();
    await staffService.updateBooking(b);
    Toasty.success('Visit confirmed and assigned to you!');
    Get.back();
  }

  Future<void> assignRequestColleague(BookingModel b, StaffModel colleague) async {
    final me = currentStaff.value;
    b.status = 'assigned';
    b.staffId = colleague.id;
    b.confirmedBy = me?.name ?? 'Admin';
    b.assignedBy = me?.name ?? 'Admin';

    bookings.refresh();
    await staffService.updateBooking(b);
    Toasty.success('Visit confirmed and assigned to ${colleague.name}!');
    Get.back();
  }

  Future<void> confirmOnlyRequest(BookingModel b) async {
    b.status = 'confirmed';
    b.confirmedBy = 'Care desk (admin)';

    bookings.refresh();
    await staffService.updateBooking(b);
    Toasty.success('Booking confirmed. Care desk will assign later.');
    Get.back();
  }

  Future<void> updateVisitStatus(BookingModel b, String newStatus) async {
    b.status = newStatus;
    if (newStatus == 'in_progress') {
      b.checkInAt = DateTime.now().millisecondsSinceEpoch;
    } else if (newStatus == 'completed') {
      b.checkOutAt = DateTime.now().millisecondsSinceEpoch;
    }

    bookings.refresh();
    await staffService.updateBooking(b);

    if (newStatus == 'on_the_way') {
      Toasty.success('Trip started. Family has been notified.');
    } else if (newStatus == 'in_progress') {
      Toasty.success('Checked in at patient\'s home.');
    } else if (newStatus == 'completed') {
      Toasty.success('Visit completed successfully!');
    }
  }

  Future<void> toggleTask(BookingModel b, int taskIndex) async {
    if (taskIndex >= 0 && taskIndex < b.tasks.length) {
      b.tasks[taskIndex].done = !b.tasks[taskIndex].done;
      bookings.refresh();
      await staffService.updateBooking(b);
    }
  }

  Future<void> saveVitals(BookingModel b, String bp, String sugar, String spo2, String note) async {
    b.visit = VisitVitals(
      bp: bp,
      sugar: sugar,
      spo2: spo2,
      note: note,
    );
    bookings.refresh();
    await staffService.updateBooking(b);
  }
}
