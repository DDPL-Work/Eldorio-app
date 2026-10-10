import 'package:flutter/material.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/widget/shimmer/shimmer_loading.dart';

Widget applicationLoading() {
  return Column(
    crossAxisAlignment: .start,
    children: [
      2.h.vs,
      ShimmerList(scrollDirection: Axis.horizontal, width: 35.w, height: 8.h),
      1.h.vs,
      ShimmerList(scrollDirection: Axis.vertical),
    ],
  );
}

Widget profileLoading() {
  return ListView(
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.zero,
    children: [
      ShimmerCard(
        height: 25.h,
        width: double.infinity,
        radius: 0,
        margin: EdgeInsets.all(0),
      ),
      2.h.vs,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerCard(
                height: 18.sp,
                width: 18.sp,
                radius: 30,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              ShimmerCard(
                height: 18.sp,
                width: 150.sp,
                margin: EdgeInsets.all(0),
              ),
            ],
          ),
          8.sp.vs,
          ShimmerCard(height: 13.sp, width: 110.sp),
        ],
      ),
      18.sp.vs,
      ShimmerList(
        scrollDirection: Axis.vertical,
        height: 10.h,
        width: double.infinity,
        radius: 14,
        itemCount: 5,
      ),
    ],
  );
}

Widget notificationLoading() {
  return ListView(
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.zero,
    children: [
      18.sp.vs,
      ShimmerList(
        scrollDirection: Axis.vertical,
        height: 10.h,
        width: double.infinity,
        radius: 14,
        itemCount: 8,
      ),
    ],
  );
}

Widget postedJobsLoading() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      1.5.h.vs,
      ShimmerList(
        scrollDirection: Axis.horizontal,
        width: 28.w,
        height: 4.5.h,
        itemCount: 4,
        radius: 20,
      ),
      1.5.h.vs,
      Expanded(
        child: ShimmerList(
          scrollDirection: Axis.vertical,
          height: 22.h,
          width: double.infinity,
          radius: 14,
          itemCount: 5,
        ),
      ),
    ],
  );
}

Widget filterLoading() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      .4.h.vs,
      ShimmerList(
        scrollDirection: Axis.horizontal,
        width: 28.w,
        height: 4.h,
        itemCount: 3,
        radius: 14,
      ),
    ],
  );
}

Widget dashboardLoading() {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            2.h.vs,
            Row(
              mainAxisAlignment: .center,
              children: [
                ShimmerCard(
                  height: 10.h,
                  width: 44.w,
                  radius: 4.w,
                  margin: EdgeInsets.all(0),
                ),
                3.w.hs,
                ShimmerCard(
                  height: 10.h,
                  width: 44.w,
                  radius: 4.w,
                  margin: EdgeInsets.all(0),
                ),
              ],
            ),
            3.w.vs,
            Row(
              mainAxisAlignment: .center,
              children: [
                ShimmerCard(
                  height: 10.h,
                  width: 44.w,
                  radius: 4.w,
                  margin: EdgeInsets.all(0),
                ),
                3.w.hs,
                ShimmerCard(
                  height: 10.h,
                  width: 44.w,
                  radius: 4.w,
                  margin: EdgeInsets.all(0),
                ),
              ],
            ),

            2.h.vs,
            ShimmerCard(
              height: 20.h,
              width: 100.w,
              radius: 4.w,
              margin: EdgeInsets.all(0),
            ),
          ],
        ),
      ),

      2.h.vs,
      ShimmerList(
        scrollDirection: Axis.vertical,
        itemCount: 2,
        height: 10.h,
        width: 100.w,
      ),
    ],
  );
}

Widget cvHistoryLoading() {
  return Column(
    children: [
      2.h.vs,
      ShimmerList(
        scrollDirection: Axis.vertical,
        height: 10.h,
        width: double.infinity,
        radius: 14,
        itemCount: 6,
      ),
    ],
  );
}

