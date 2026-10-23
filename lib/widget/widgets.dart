import 'package:eldoriaCare/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:eldoriaCare/utils/helper.dart';
import 'package:eldoriaCare/utils/logger.dart';

Widget empty() => SizedBox();

Widget assetImage(
  String? name, {
  double? width,
  double? height,
  Color? color,
  BoxFit? fit,
  Alignment alignment = Alignment.center,
  ImageErrorWidgetBuilder? errorBuilder,
}) {
  try {
    if (name.empty) throw Exception('Empty Asset!');
    return Image.asset(
      name.nullSafe,
      width: width,
      height: height,
      color: color,
      fit: fit,
      alignment: alignment,
      errorBuilder:
          errorBuilder ??
          (c, o, s) {
            Logger.e(tag: 'ASSET IMAGE : ${name.nullSafe}', value: s);
            return SizedBox(width: width, height: height);
          },
    );
  } catch (e) {
    Logger.ex(tag: 'ASSET IMAGE', value: e);
    return empty();
  }
}

class MyFlatButton extends MaterialButton {
  const MyFlatButton({
    super.key,
    required VoidCallback super.onPressed,
    required Widget super.child,
    super.onLongPress,
    super.height,
    final double? width = double.infinity,
    super.minWidth,
    final Color? color,
    super.focusColor,
    super.splashColor,
    super.textColor,
    final EdgeInsetsGeometry? padding = EdgeInsets.zero,
    super.shape,
    final double? elevation,
    final MaterialTapTargetSize? materialTapTargetSize,
  }) : super(
         color: color ?? ThemeColors.transparentColor,
         highlightElevation: elevation ?? 0,
         padding: padding ?? EdgeInsets.zero,
         elevation: elevation ?? 0,
         materialTapTargetSize:
             materialTapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
       );
}

class MyTextStyle extends TextStyle {
  const MyTextStyle({
    super.inherit,
    super.color,
    super.backgroundColor,
    double super.fontSize = 14,
    super.fontWeight,
    super.fontStyle,
    super.fontFamily,
    super.letterSpacing,
    super.wordSpacing,
    super.textBaseline,
    super.height,
    super.decoration,
  });
}

class CityDropdown extends StatelessWidget {
  final String? selectedCity;
  final ValueChanged<String?> onChanged;
  final String hintText;
  final bool enabled;
  final double? width;
  final double? height;
  final Color? color;
  final bool isExpanded;

  const CityDropdown({
    super.key,
    required this.selectedCity,
    required this.onChanged,
    this.hintText = 'Select city',
    this.enabled = true,
    this.width,
    this.height,
    this.color,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final cityList = Const.cities;
    final rawCity = selectedCity?.trim().toLowerCase();

    final matchedCity = cityList.where((city) {
      return city.id.toLowerCase() == rawCity ||
          city.name.toLowerCase() == rawCity;
    }).firstOrNull;

    final selectedValue = matchedCity?.id;
    final hasValue = matchedCity != null;

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: color ?? ThemeColors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: enabled
              ? () => _openCitySheet(context, cityList, selectedValue)
              : null,
          child: Container(
            width: width,
            height: height,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color != null
                    ? ThemeColors.lineBorder
                    : ThemeColors.cardBorder,
              ),
            ),
            child: Row(
              mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  fit: isExpanded ? FlexFit.tight : FlexFit.loose,
                  child: Text(
                    hasValue ? matchedCity.name : hintText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: hasValue
                          ? ThemeColors.textWhite
                          : ThemeColors.textWhite.withValues(alpha: 0.6),
                      fontSize: 12.sp,
                      fontWeight: hasValue ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: ThemeColors.goldenAmber,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openCitySheet(
    BuildContext context,
    List<dynamic> cityList,
    String? selectedValue,
  ) {
    final searchController = TextEditingController();
    String query = '';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ThemeColors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final filtered = cityList.where((city) {
              return city.name.toString().toLowerCase().contains(query);
            }).toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                decoration: const BoxDecoration(
                  color: ThemeColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  border: Border(
                    top: BorderSide(color: ThemeColors.cardBorder),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag handle
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 14),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: ThemeColors.lineBorder,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Title
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Select city',
                                style: TextStyle(
                                  color: ThemeColors.textLight,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => Navigator.pop(sheetContext),
                              borderRadius: BorderRadius.circular(20),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.close_rounded,
                                  color: ThemeColors.textMuted,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.4.h),

                      // Search field
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) => setSheetState(
                            () => query = value.trim().toLowerCase(),
                          ),
                          cursorColor: ThemeColors.goldenAmber,
                          style: TextStyle(
                            color: ThemeColors.textWhite,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search city',
                            hintStyle: TextStyle(
                              color: ThemeColors.textPlaceholder,
                              fontSize: 12.sp,
                            ),
                            filled: true,
                            fillColor: ThemeColors.inputBg,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.4.h,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: ThemeColors.textMuted,
                              size: 20,
                            ),
                            suffixIcon: query.isEmpty
                                ? null
                                : IconButton(
                                    icon: const Icon(
                                      Icons.cancel_rounded,
                                      color: ThemeColors.textMuted,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      searchController.clear();
                                      setSheetState(() => query = '');
                                    },
                                  ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: ThemeColors.lineBorder,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: ThemeColors.goldenAmber,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 1.2.h),

                      // City list / empty state
                      Flexible(
                        child: filtered.isEmpty
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.h),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.search_off_rounded,
                                      color: ThemeColors.textPlaceholder,
                                      size: 36,
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      'No city found',
                                      style: TextStyle(
                                        color: ThemeColors.textMuted,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.fromLTRB(
                                  4.w,
                                  0.5.h,
                                  4.w,
                                  2.h,
                                ),
                                itemCount: filtered.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 0.8.h),
                                itemBuilder: (_, index) {
                                  final city = filtered[index];
                                  final isSelected = city.id == selectedValue;

                                  return Material(
                                    color: isSelected
                                        ? ThemeColors.goldenAmberBg
                                        : ThemeColors.cardSurface,
                                    borderRadius: BorderRadius.circular(12),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () {
                                        Navigator.pop(sheetContext);
                                        onChanged(city.id);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 3.w,
                                          vertical: 1.4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: isSelected
                                                ? ThemeColors.goldenAmber
                                                : ThemeColors.cardBorder,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                city.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: ThemeColors.textWhite,
                                                  fontSize: 12.sp,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w700
                                                      : FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            if (isSelected)
                                              const Icon(
                                                Icons.check_circle_rounded,
                                                color: ThemeColors.goldenAmber,
                                                size: 20,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(searchController.dispose);
  }
}
