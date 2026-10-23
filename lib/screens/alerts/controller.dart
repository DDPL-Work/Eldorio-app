import 'dart:convert';
import 'package:get/get.dart';
import 'package:eldoriaCare/model/client_models.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/utils/preference.dart';

class AlertsController extends GetxController {
  static AlertsController get to => Get.find();

  final RxList<ClientNotificationItem> notifications = <ClientNotificationItem>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  bool get hasUnread => notifications.any((n) => !n.read);

  int get unreadCount => notifications.where((n) => !n.read).length;

  Future<void> loadNotifications() async {
    isLoading.value = true;
    try {
      final nStr = LocalDB.clientNotificationsJson;
      if (nStr.isNotEmpty) {
        final List raw = jsonDecode(nStr);
        notifications.assignAll(
          raw.map((e) => ClientNotificationItem.fromJson(Map<String, dynamic>.from(e))),
        );
      } else {
        _loadDefaultNotifications();
        await saveNotifications();
      }
    } catch (_) {
      _loadDefaultNotifications();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadDefaultNotifications() {
    final now = DateTime.now();
    final nowMs = now.millisecondsSinceEpoch;
    int agoMin(int m) => nowMs - (m * 60 * 1000);

    notifications.assignAll([
      ClientNotificationItem(
        id: 'n1',
        to: 'client',
        title: 'Caregiver assigned',
        body: 'Anjali Patil (GNM Nurse) will visit Sunita Mehta tomorrow at 9:00 AM.',
        bookingId: 'b1',
        at: agoMin(50),
        read: false,
      ),
      ClientNotificationItem(
        id: 'n2',
        to: 'client',
        title: 'Booking confirmed',
        body: 'Your Home Nursing booking is confirmed for tomorrow, 9:00 AM.',
        bookingId: 'b1',
        at: agoMin(51),
        read: true,
      ),
      ClientNotificationItem(
        id: 'n3',
        to: 'client',
        title: 'Visit completed',
        body: 'Rahul Kadam completed the visit for Ramesh Mehta. Tap to see the visit report.',
        bookingId: 'b2',
        at: agoMin(60 * 24 * 3),
        read: true,
      ),
    ]);
  }

  Future<void> saveNotifications() async {
    try {
      await LocalDB.setClientNotificationsJson(
        jsonEncode(notifications.map((e) => e.toJson()).toList()),
      );
    } catch (_) {}
  }

  void markNotificationRead(String id) {
    final idx = notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      notifications[idx].read = true;
      notifications.refresh();
      saveNotifications();
    }
  }

  void markAllRead() {
    for (final n in notifications) {
      n.read = true;
    }
    notifications.refresh();
    saveNotifications();
  }

  void openNotification(ClientNotificationItem n) {
    markNotificationRead(n.id);

    if (n.bookingId != null && n.bookingId!.isNotEmpty) {
      Get.toNamed(AppRoutes.booking, arguments: n.bookingId);
    } else if (n.enquiryId != null && n.enquiryId!.isNotEmpty) {
      Get.toNamed(AppRoutes.helpDone, arguments: n.enquiryId);
    }
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
}
