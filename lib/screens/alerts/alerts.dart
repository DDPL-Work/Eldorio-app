import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/data_handler/client_data_controller.dart';
import 'package:eldoriaCare/model/client_models.dart';
import 'package:eldoriaCare/screens/alerts/controller.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AlertsController());
    final clientData = ClientDataController.to;

    return Scaffold(
      backgroundColor: ThemeColors.appBackground,
      appBar: AppBar(
        backgroundColor: ThemeColors.appBar,
        elevation: 0,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: ThemeColors.textWhite,
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          Obx(() {
            if (!c.hasUnread) return const SizedBox.shrink();

            return Padding(
              padding: EdgeInsets.only(right: 3.w),
              child: TextButton(
                onPressed: c.markAllRead,
                child: Text(
                  'Mark all read',
                  style: TextStyle(
                    color: ThemeColors.goldenAmber,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        final list = clientData.notifications;

        if (list.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: ThemeColors.cardSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ThemeColors.cardBorder),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: const BoxDecoration(
                        color: ThemeColors.surface2,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        color: ThemeColors.goldenAmber,
                        size: 26,
                      ),
                    ),
                    2.h.vs,
                    Text(
                      'You\'re all caught up',
                      style: TextStyle(
                        color: ThemeColors.textWhite,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    0.6.h.vs,
                    Text(
                      'Booking updates will show here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ThemeColors.textMuted,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final item = list[index];
            return _buildNotificationCard(context, item, c);
          },
        );
      }),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    ClientNotificationItem item,
    AlertsController c,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.4.h),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.read ? ThemeColors.cardBorder : ThemeColors.goldenAmber.withValues(alpha: 0.5),
          width: item.read ? 1 : 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.shadowColorDark,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => c.openNotification(item),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Avatar
                Container(
                  width: 11.w,
                  height: 11.w,
                  decoration: BoxDecoration(
                    color: ThemeColors.infoBlueBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.notifications_rounded,
                    color: ThemeColors.infoBlueFg,
                    size: 20,
                  ),
                ),

                3.5.w.hs,

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          color: ThemeColors.textWhite,
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      0.4.h.vs,
                      Text(
                        item.body,
                        style: TextStyle(
                          color: ThemeColors.textMuted,
                          fontSize: 11.5.sp,
                          height: 1.35,
                        ),
                      ),
                      0.8.h.vs,
                      Text(
                        _formatTimeAgo(item.at),
                        style: TextStyle(
                          color: ThemeColors.textPlaceholder,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                if (!item.read) ...[
                  2.w.hs,
                  Container(
                    width: 9,
                    height: 9,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      color: ThemeColors.goldenAmber,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(int timestamp) {
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
