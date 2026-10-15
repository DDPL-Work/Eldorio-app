import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/data_handler/client_data_controller.dart';
import 'package:eldoriaCare/model/client_models.dart';
import 'package:eldoriaCare/routes/app_routes.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:eldoriaCare/widget/care_desk_buttons.dart';
import 'package:eldoriaCare/widget/service_icon.dart';
import 'package:eldoriaCare/widget/soon_bottom_sheet.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clientData = ClientDataController.to;
    final String catId = Get.arguments?.toString() ?? 'elder';
    final CategoryItem? cat = clientData.getCategory(catId);
    final List<ServiceItem> services = clientData.getServicesForCategory(catId);

    return Scaffold(
      backgroundColor: ThemeColors.appBackground,
      appBar: AppBar(
        backgroundColor: ThemeColors.appBar,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ThemeColors.textWhite),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cat?.name ?? 'Category',
              style: TextStyle(
                color: ThemeColors.textWhite,
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (cat?.desc.isNotEmpty == true) ...[
              0.2.h.vs,
              Text(
                cat!.desc,
                style: TextStyle(
                  color: ThemeColors.textMuted,
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        children: [
          // If Coming Soon Category Banner
          if (cat?.comingSoon == true) ...[
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: ThemeColors.infoBlueBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ThemeColors.brandBlue.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.health_and_safety_rounded, color: ThemeColors.goldenAmber, size: 28),
                  3.w.hs,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Coming soon',
                          style: TextStyle(
                            color: ThemeColors.textWhite,
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        0.4.h.vs,
                        Text(
                          'We\'re onboarding verified doctors. Until then, call or WhatsApp us and we\'ll help you find a doctor.',
                          style: TextStyle(
                            color: ThemeColors.textSoftBlue,
                            fontSize: 11.5.sp,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            2.h.vs,
            const CareDeskButtons(),
            2.5.h.vs,
          ],

          // Services List
          if (services.isEmpty)
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: ThemeColors.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ThemeColors.cardBorder),
              ),
              child: Center(
                child: Text(
                  'No services in this category yet. Call or WhatsApp us and we\'ll help.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: ThemeColors.textMuted, fontSize: 12.5.sp),
                ),
              ),
            )
          else
            ...services.map((s) => _buildServiceItem(context, s, cat)),

          2.h.vs,

          // "Not sure which one?" banner
          InkWell(
            onTap: () {
              Get.toNamed('${AppRoutes.dashboard}/help');
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: ThemeColors.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ThemeColors.cardBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 11.w,
                    height: 11.w,
                    decoration: BoxDecoration(
                      color: ThemeColors.goldenAmberBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.help_outline_rounded,
                      color: ThemeColors.goldenAmber,
                      size: 22,
                    ),
                  ),
                  3.w.hs,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Not sure which one?',
                          style: TextStyle(
                            color: ThemeColors.textWhite,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        0.3.h.vs,
                        Text(
                          'Describe the need and we\'ll recommend the right care.',
                          style: TextStyle(
                            color: ThemeColors.textMuted,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: ThemeColors.textMuted,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),

          3.h.vs,
        ],
      ),
    );
  }

  Widget _buildServiceItem(BuildContext context, ServiceItem s, CategoryItem? cat) {
    final bool soon = cat?.comingSoon ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 1.6.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.shadowColorDark,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ServiceIcon(
            iconKey: s.icon,
            size: 6.w,
            containerSize: 13.w,
          ),
          3.5.w.hs,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.name,
                  style: TextStyle(
                    color: ThemeColors.textWhite,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                0.4.h.vs,
                Text(
                  s.desc,
                  style: TextStyle(
                    color: ThemeColors.textMuted,
                    fontSize: 11.5.sp,
                    height: 1.35,
                  ),
                ),
                1.4.h.vs,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      soon ? 'Coming soon' : s.priceLabel,
                      style: TextStyle(
                        color: ThemeColors.goldenAmber,
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (soon) {
                          SoonBottomSheet.show(context, service: s);
                        } else {
                          Get.toNamed('${AppRoutes.dashboard}/book', arguments: s.id);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: soon ? ThemeColors.surface2 : ThemeColors.goldenAmber,
                        foregroundColor: soon ? ThemeColors.textMuted : ThemeColors.deepNavy,
                        padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 0.8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        soon
                            ? 'Coming soon'
                            : (cat?.kind == 'equipment' ? 'Order' : 'Book'),
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
