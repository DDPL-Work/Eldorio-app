import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/model/services_model.dart';
import 'package:eldoriaCare/screens/category/controller.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:eldoriaCare/widget/care_desk_buttons.dart';
import 'package:eldoriaCare/widget/service_icon.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(CategoryController());

    return Scaffold(
      backgroundColor: ThemeColors.appBackground,
      appBar: AppBar(
        backgroundColor: ThemeColors.appBar,
        elevation: 0,
        leading: InkWell(
          overlayColor: WidgetStatePropertyAll(ThemeColors.transparent),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ThemeColors.textWhite,
          ),
          onTap: () => Get.back(),
        ),
        title: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                c.categoryName,
                style: TextStyle(
                  color: ThemeColors.textWhite,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (c.categoryDesc.isNotEmpty) ...[
                0.2.h.vs,
                Text(
                  c.categoryDesc,
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
      ),
      body: RefreshIndicator(
        color: ThemeColors.goldenAmber,
        backgroundColor: ThemeColors.cardSurface,
        onRefresh: () => c.fetchCategoryServices(showLoading: false),
        child: Obx(() {
          if (c.isLoading.value && c.category.value == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: ThemeColors.goldenAmber,
                  ),
                  2.h.vs,
                  Text(
                    'Loading services...',
                    style: TextStyle(
                      color: ThemeColors.textMuted,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              // ── If Coming Soon Category Banner ────────────────────────────
              if (c.isComingSoon) ...[
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: ThemeColors.infoBlueBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: ThemeColors.brandBlue.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.health_and_safety_rounded,
                        color: ThemeColors.goldenAmber,
                        size: 28,
                      ),
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
                              'We\'re onboarding verified care partners. Until then, call or WhatsApp us and we\'ll help you.',
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

              // ── Services List ─────────────────────────────────────────────
              if (!c.hasServices)
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
                      style: TextStyle(
                        color: ThemeColors.textMuted,
                        fontSize: 12.5.sp,
                      ),
                    ),
                  ),
                )
              else
                ...c.services.map((s) => _buildServiceItem(context, c, s)),

              2.h.vs,

              // ── "Not sure which one?" Banner ──────────────────────────────
              InkWell(
                onTap: c.onHelpPressed,
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
          );
        }),
      ),
    );
  }

  // ── Presentational Service Item ───────────────────────────────────────────
  Widget _buildServiceItem(
    BuildContext context,
    CategoryController c,
    OperationalServiceItem s,
  ) {
    final bool soon = s.comingSoon || c.isComingSoon;

    return Container(
      margin: EdgeInsets.only(bottom: 1.6.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColors.cardBorder),
        boxShadow: const [
          BoxShadow(
            color: ThemeColors.shadowColorDark,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ServiceIcon(iconKey: s.icon, size: 6.w, containerSize: 13.w),
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
                      onPressed: () => c.onServiceAction(context, s),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: soon
                            ? ThemeColors.surface2
                            : ThemeColors.goldenAmber,
                        foregroundColor: soon
                            ? ThemeColors.textMuted
                            : ThemeColors.deepNavy,
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.5.w,
                          vertical: 0.8.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        soon
                            ? 'Coming soon'
                            : (c.isEquipment ? 'Order' : 'Book'),
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
