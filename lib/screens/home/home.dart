import 'package:eldoriaCare/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/model/services_model.dart';
import 'package:eldoriaCare/screens/home/controller.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:eldoriaCare/widget/care_desk_buttons.dart';
import 'package:eldoriaCare/widget/service_icon.dart';
import 'package:eldoriaCare/widget/status_pill.dart';
import 'package:eldoriaCare/widget/ticker_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(HomeController());

    return Scaffold(
      backgroundColor: ThemeColors.appBackground,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: c.loadDashboardData,
          color: ThemeColors.goldenAmber,
          backgroundColor: ThemeColors.cardSurface,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            children: [
              // ── Top Header Bar ──────────────────────────────────────────
              _buildTopBar(context, c),

              1.5.h.vs,

              // ── City Selector ───────────────────────────────────────────
              _buildCitySelector(context, c),

              2.h.vs,

              // ── 24×7 Care Desk Hero Scene Card ──────────────────────────
              _buildHeroSceneCard(context, c),

              2.2.h.vs,

              // ── Search Input Box ────────────────────────────────────────
              _buildSearchBox(context, c),

              2.2.h.vs,

              // ── Search Results or Normal Content ────────────────────────
              Obx(() {
                final query = c.searchQuery.value.trim();
                if (query.isNotEmpty) {
                  return _buildSearchResults(context, c);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "Not sure what care you need?" Banner Tile
                    _buildNotSureBanner(context, c),

                    2.5.h.vs,

                    // "Our services" Section with Category Grid
                    _buildOurServicesSection(context, c),

                    2.8.h.vs,

                    // "Upcoming visit" Section
                    _buildUpcomingVisitSection(context, c),

                    3.h.vs,
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ── Top Header Bar ────────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context, HomeController c) {
    return Row(
      children: [
        // App Logo
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ThemeColors.textWhite,
            boxShadow: [
              BoxShadow(
                color: ThemeColors.goldenAmber.withValues(alpha: 0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          padding: const EdgeInsets.all(3),
          child: ClipOval(
            child: Image.asset(
              'assets/icons/logo.png',
              fit: BoxFit.contain,
              errorBuilder: (ctx, err, stack) => const Icon(
                Icons.favorite_rounded,
                color: ThemeColors.brandNavy,
                size: 20,
              ),
            ),
          ),
        ),

        3.w.hs,

        // Brand Title: Eldoria+ Care at Home
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 16.5.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
                color: ThemeColors.textWhite,
              ),
              children: const [
                TextSpan(text: 'Eldoria'),
                TextSpan(
                  text: '+',
                  style: TextStyle(
                    color: ThemeColors.goldenAmber,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: ' Care at Home',
                  style: TextStyle(color: ThemeColors.textWhite),
                ),
              ],
            ),
          ),
        ),

        // Notification Icon with unread badge
        Obx(() {
          final unread = c.unreadNotificationsCount.value;
          return InkWell(
            onTap: c.onNotificationTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 10.5.w,
              height: 10.5.w,
              decoration: BoxDecoration(
                color: ThemeColors.cardSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ThemeColors.cardBorder),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    color: ThemeColors.textLight,
                    size: 22,
                  ),
                  if (unread > 0)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: ThemeColors.goldenAmber,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── City Selector ─────────────────────────────────────────────────────
  Widget _buildCitySelector(BuildContext context, HomeController c) {
    return Row(
      children: [
        const Icon(
          Icons.location_on_rounded,
          color: ThemeColors.goldenAmber,
          size: 18,
        ),
        1.5.w.hs,
        Text(
          'Care in',
          style: TextStyle(
            color: ThemeColors.textMuted,
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        2.w.hs,
        Obx(() {
          return CityDropdown(
            height: 5.h,
            selectedCity: c.selectedCity.value,
            onChanged: c.onCityChanged,
          );
        }),
      ],
    );
  }

  // ── 24×7 Care Desk Hero Scene Card ────────────────────────────────────
  Widget _buildHeroSceneCard(BuildContext context, HomeController c) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.6.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.8, -1.0),
          end: Alignment(0.8, 1.0),
          stops: [0.0, 0.45, 1.0],
          colors: [
            ThemeColors.sceneDarkNavy,
            ThemeColors.brandNavy,
            ThemeColors.brandNavySoft,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ThemeColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.sceneShadow,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Eyebrow: 24×7 care desk · City
          Obx(() {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 2.6.w, vertical: 0.4.h),
              decoration: BoxDecoration(
                color: ThemeColors.goldenAmber.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '24×7 care desk · ${c.currentCityDisplayName}',
                style: TextStyle(
                  color: ThemeColors.goldenAmberLight,
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            );
          }),

          1.4.h.vs,

          // Animated Headline Ticker
          SizedBox(
            width: double.infinity,
            height: 4.h,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TickerText(
                items: const [
                  'Need a nurse or caregiver today?',
                  'Verified nurses at your door',
                  'Elder care like family',
                  'Post-surgery care at home',
                ],
                style: TextStyle(
                  color: ThemeColors.textWhite,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                  shadows: const [
                    Shadow(
                      color: Colors.black45,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),

          0.6.h.vs,

          // Subtitle
          Text(
            'Talk to our care coordinator now',
            style: TextStyle(
              color: ThemeColors.textSoftBlue,
              fontSize: 11.5.sp,
            ),
          ),

          2.2.h.vs,

          // Care Desk Call & WhatsApp Buttons
          Obx(() {
            final desk = c.location.value?.careDesk;
            return CareDeskButtons(
              phone: desk?.phone,
              whatsapp: desk?.whatsapp,
            );
          }),
        ],
      ),
    );
  }

  // ── Search Input Box ──────────────────────────────────────────────────
  Widget _buildSearchBox(BuildContext context, HomeController c) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ThemeColors.lineBorder),
      ),
      child: TextField(
        controller: c.searchController,
        onChanged: c.onSearchChanged,
        style: TextStyle(color: ThemeColors.textWhite, fontSize: 13.sp),
        decoration: InputDecoration(
          hintText: 'Search services, e.g. dementia, wheelchair',
          hintStyle: const TextStyle(color: ThemeColors.textPlaceholder),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: ThemeColors.textMuted,
            size: 22,
          ),
          suffixIcon: Obx(
            () => c.searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: ThemeColors.textMuted,
                      size: 18,
                    ),
                    onPressed: c.clearSearch,
                  )
                : const SizedBox.shrink(),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 1.6.h,
          ),
        ),
      ),
    );
  }

  // ── Search Results List ───────────────────────────────────────────────
  Widget _buildSearchResults(BuildContext context, HomeController c) {
    final hits = c.searchResults;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${hits.length} result${hits.length == 1 ? '' : 's'} for “${c.searchQuery.value.trim()}”',
          style: TextStyle(
            color: ThemeColors.textWhite,
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        1.5.h.vs,
        if (hits.isEmpty)
          Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: ThemeColors.cardSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ThemeColors.cardBorder),
            ),
            child: Center(
              child: Text(
                'No services matched your search.',
                style: TextStyle(
                  color: ThemeColors.textMuted,
                  fontSize: 12.5.sp,
                ),
              ),
            ),
          )
        else
          ...hits.map((s) => _buildServiceCard(context, c, s)),

        2.h.vs,

        // Can't find it banner
        InkWell(
          onTap: c.onNotSureBannerTap,
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
                  decoration: const BoxDecoration(
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
                        'Can\'t find it?',
                        style: TextStyle(
                          color: ThemeColors.textWhite,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      0.3.h.vs,
                      Text(
                        'Tell us what you need and our care team will call you.',
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
      ],
    );
  }

  // ── "Not sure what care you need?" Interactive Banner ─────────────────
  Widget _buildNotSureBanner(BuildContext context, HomeController c) {
    return InkWell(
      onTap: c.onNotSureBannerTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.2.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: ThemeColors.cardSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ThemeColors.cardBorder),
          boxShadow: const [
            BoxShadow(
              color: ThemeColors.shadowColorDark,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: ThemeColors.goldenAmberBg,
                shape: BoxShape.circle,
                border: Border.all(
                  color: ThemeColors.goldenAmber.withValues(alpha: 0.4),
                ),
              ),
              child: const Icon(
                Icons.help_outline_rounded,
                color: ThemeColors.goldenAmber,
                size: 24,
              ),
            ),
            3.w.hs,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Not sure what care you need?',
                    style: TextStyle(
                      color: ThemeColors.textWhite,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  0.4.h.vs,
                  Text(
                    'Tell us about the patient and our care team will call you with the right service.',
                    style: TextStyle(
                      color: ThemeColors.textMuted,
                      fontSize: 11.sp,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            2.w.hs,
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: ThemeColors.goldenAmber,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // ── "Our services" Section with Category Grid ─────────────────────────
  Widget _buildOurServicesSection(BuildContext context, HomeController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Our services',
              style: TextStyle(
                color: ThemeColors.textWhite,
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        1.5.h.vs,
        Obx(() {
          if (c.isLoading.value && c.categories.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: const CircularProgressIndicator(
                  color: ThemeColors.goldenAmber,
                ),
              ),
            );
          }

          if (c.categories.isEmpty) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                color: ThemeColors.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ThemeColors.cardBorder),
              ),
              child: Center(
                child: Text(
                  'No services available at the moment.',
                  style: TextStyle(
                    color: ThemeColors.textMuted,
                    fontSize: 12.5.sp,
                  ),
                ),
              ),
            );
          }

          final cats = c.categories;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cats.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 1.6.h,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (ctx, index) {
              final cat = cats[index];
              return _buildCategoryTile(ctx, c, cat);
            },
          );
        }),
      ],
    );
  }

  Widget _buildCategoryTile(
    BuildContext context,
    HomeController c,
    OperationalCategoryItem cat,
  ) {
    final count = cat.servicesCount > 0
        ? cat.servicesCount
        : cat.services.length;

    return InkWell(
      onTap: () => c.onCategoryTap(cat, context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(3.5.w),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon
            ServiceIcon(iconKey: cat.icon, size: 5.5.w, containerSize: 11.w),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cat.name,
                  style: TextStyle(
                    color: ThemeColors.textWhite,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                0.4.h.vs,
                if (cat.comingSoon)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 0.2.h,
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.surface2,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Coming soon',
                      style: TextStyle(
                        color: ThemeColors.textMuted,
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                else
                  Text(
                    '$count service${count == 1 ? '' : 's'}',
                    style: TextStyle(
                      color: ThemeColors.textMuted,
                      fontSize: 10.5.sp,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── "Upcoming visit" Section ──────────────────────────────────────────
  Widget _buildUpcomingVisitSection(BuildContext context, HomeController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming visit',
          style: TextStyle(
            color: ThemeColors.textWhite,
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        1.5.h.vs,
        Obx(() {
          final next = c.nextUpcomingBooking.value;
          if (next == null) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.5.w),
              decoration: BoxDecoration(
                color: ThemeColors.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ThemeColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No upcoming visits',
                    style: TextStyle(
                      color: ThemeColors.textWhite,
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  0.5.h.vs,
                  Text(
                    'Pick a service above, or tell us what you need.',
                    style: TextStyle(
                      color: ThemeColors.textMuted,
                      fontSize: 11.5.sp,
                    ),
                  ),
                ],
              ),
            );
          }

          final staff = next.assignedStaff;
          final initials = c.getStaffInitials(next);
          final iconKey = c.getServiceIcon(next.service);

          return Container(
            decoration: BoxDecoration(
              color: ThemeColors.cardSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ThemeColors.cardBorder),
              boxShadow: const [
                BoxShadow(
                  color: ThemeColors.shadowColorDark,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => c.onUpcomingBookingTap(next),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Row(
                    children: [
                      if (staff != null)
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: ThemeColors.goldenAmberBg,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ThemeColors.goldenAmber,
                              width: 1.2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            initials,
                            style: TextStyle(
                              color: ThemeColors.goldenAmber,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        )
                      else
                        ServiceIcon(
                          iconKey: iconKey,
                          size: 5.5.w,
                          containerSize: 12.w,
                        ),

                      3.w.hs,

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${next.effectiveServiceName}${staff != null ? ' · ${staff.name.split(' ').first}' : ''}',
                              style: TextStyle(
                                color: ThemeColors.textWhite,
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            0.4.h.vs,
                            Text(
                              '${c.formatDate(next.date)}, ${next.time} · for ${next.patientName}',
                              style: TextStyle(
                                color: ThemeColors.textMuted,
                                fontSize: 11.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      2.w.hs,

                      StatusPill(status: next.status),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── Service Card (used in search results) ─────────────────────────────
  Widget _buildServiceCard(
    BuildContext context,
    HomeController c,
    OperationalServiceItem s,
  ) {
    final soon = s.comingSoon;

    return Container(
      margin: EdgeInsets.only(bottom: 1.5.h),
      padding: EdgeInsets.all(3.8.w),
      decoration: BoxDecoration(
        color: ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ServiceIcon(iconKey: s.icon, size: 5.5.w, containerSize: 12.w),
          3.w.hs,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.name,
                  style: TextStyle(
                    color: ThemeColors.textWhite,
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                0.4.h.vs,
                Text(
                  s.desc,
                  style: TextStyle(
                    color: ThemeColors.textMuted,
                    fontSize: 11.sp,
                  ),
                ),
                1.h.vs,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      soon ? 'Coming soon' : s.priceLabel,
                      style: TextStyle(
                        color: ThemeColors.goldenAmber,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => c.onServiceBookTap(s, context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: soon
                            ? ThemeColors.surface2
                            : ThemeColors.goldenAmber,
                        foregroundColor: soon
                            ? ThemeColors.textMuted
                            : ThemeColors.deepNavy,
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.5.w,
                          vertical: 0.6.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        soon
                            ? 'Coming soon'
                            : (s.kind == 'equipment' ? 'Order' : 'Book'),
                        style: TextStyle(
                          fontSize: 11.sp,
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
