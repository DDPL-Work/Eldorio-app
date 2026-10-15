import 'package:get/get.dart';
import 'package:eldoriaCare/data_handler/client_data_controller.dart';
import 'package:eldoriaCare/model/client_models.dart';
import 'package:eldoriaCare/routes/app_routes.dart';

class AlertsController extends GetxController {
  static AlertsController get to => Get.find();

  final clientData = ClientDataController.to;

  List<ClientNotificationItem> get notificationList => clientData.notifications;

  bool get hasUnread => clientData.unreadNotificationsCount > 0;

  void markAllRead() {
    clientData.markAllNotificationsRead();
  }

  void openNotification(ClientNotificationItem n) {
    clientData.markNotificationRead(n.id);

    if (n.bookingId != null && n.bookingId!.isNotEmpty) {
      Get.toNamed('${AppRoutes.dashboard}/booking', arguments: n.bookingId);
    } else if (n.enquiryId != null && n.enquiryId!.isNotEmpty) {
      Get.toNamed('${AppRoutes.dashboard}/helpdone', arguments: n.enquiryId);
    }
  }
}
