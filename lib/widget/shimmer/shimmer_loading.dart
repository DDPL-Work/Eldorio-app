import 'package:flutter/material.dart';
import 'package:eldoriaCare/values/size_config.dart';
import 'package:eldoriaCare/values/theme_colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  final double? width;
  final double? height;
  final int? itemCount;
  final double? radius;
  final Axis scrollDirection;

  const ShimmerList({
    super.key,
    this.width,
    this.height,
    this.itemCount,
    this.radius,
    this.scrollDirection = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final children = List.generate(
      itemCount ?? 3,
      (_) => ShimmerCard(
        width:
            width ??
            (scrollDirection == Axis.horizontal ? 80.w : double.infinity),
        height: scrollDirection != Axis.horizontal ? (height ?? 20.h) : null,
        radius: radius,
      ),
    );

    return SizedBox(
      height: scrollDirection == Axis.horizontal ? (height ?? 20.h) : null,
      child: SingleChildScrollView(
        scrollDirection: scrollDirection,
        physics: const BouncingScrollPhysics(),
        child: scrollDirection == Axis.horizontal
            ? Row(children: children)
            : Column(children: children),
      ),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  final double width;
  final double? height;
  final double? radius;
  final EdgeInsetsGeometry? margin;

  const ShimmerCard({
    super.key,
    required this.width,
    this.height,
    this.radius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ThemeColors.shimmerBaseColor,
      highlightColor: ThemeColors.shimmerHighlightColor,
      period: const Duration(milliseconds: 1200),
      child: Container(
        width: width,
        height: height ?? 20.h,
        margin: margin ?? EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h),
        decoration: BoxDecoration(
          color: ThemeColors.shimmerBaseColor,
          borderRadius: BorderRadius.circular(radius ?? 3.w),
        ),
      ),
    );
  }
}
