import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eldoriaCare/utils/const.dart';
import 'package:eldoriaCare/widget/widgets.dart';
import 'package:get/get.dart';
import 'package:eldoriaCare/utils/helper.dart';
import 'package:eldoriaCare/values/strings.dart';

// ignore: must_be_immutable
class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  String title;
  bool enableBackButton;
  bool showBellButton;
  bool showProfileButton;
  bool enableClearButton;
  void Function(String text)? searchCallBack;
  void Function()? backCallBack;
  bool searchExpanded;
  TextEditingController? searchController;
  bool searchReadOnly;
  Function()? onSearchClick;
  Widget? trailing;
  void Function()? onMenuClick;

  MyAppBar(
    this.title, {
    super.key,
    this.enableBackButton = true,
    this.showBellButton = false,
    this.showProfileButton = false,
    this.searchCallBack,
    this.backCallBack,
    this.searchExpanded = false,
    this.enableClearButton = true,
    this.searchController,
    this.searchReadOnly = false,
    this.onSearchClick,
    this.trailing,
    this.onMenuClick,
  });

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(8.h);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: ThemeColors.transparentColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    widget.searchController =
        widget.searchController ?? TextEditingController();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      padding: EdgeInsets.only(top: 3.h),
      decoration: const BoxDecoration(color: ThemeColors.primaryColor),
      child: widget.searchExpanded
          ? _searchBar
          : Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.onMenuClick != null ? _menuButton : _backButton,
                _toolbarTitle,
                5.hs,
                _searchIcon,
                _bellIcon,
                if (widget.trailing != null) widget.trailing ?? empty(),
                8.hs,
                _userProfile,
                8.hs,
              ],
            ),
    );
  }

  Widget get _toolbarTitle {
    return Expanded(
      child: Center(
        child: Text(
          // (widget.title.placeholder(Strings.get('appName'))) +
          //     (ApiKeys.env == ApiKeys.ENV_DEV ? ' (DEV)' : ''),
          widget.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: true,
          style: MyTextStyle(
            color: ThemeColors.oldLatterLight4,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget get _searchBar => Container(
    margin: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
    decoration: BoxDecoration(
      color: ThemeColors.oldLatterLight4,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: MyFlatButton(
            onPressed: () {},
            padding: EdgeInsets.zero,
            shape: const CircleBorder(),
            child: Icon(
              Icons.search,
              color: ThemeColors.colorSecondary,
              size: 18,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            onChanged: (txt) {
              if (widget.searchCallBack != null) {
                widget.searchCallBack?.call(txt);
              }
            },
            onTap: widget.onSearchClick,
            cursorWidth: 1.4,
            readOnly: widget.searchReadOnly,
            autofocus: true,
            cursorColor: ThemeColors.colorSecondary,
            controller: widget.searchController,
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: ' ${Strings.get('search')}...',
              hintStyle: MyTextStyle(
                fontSize: 14,
                color: ThemeColors.colorSecondary,
              ),
              isDense: true,
              border: InputBorder.none,
            ),
            textInputAction: TextInputAction.search,
            // onSubmitted: (str) => searchCallBack.call(str),
            style: MyTextStyle(fontSize: 14, color: ThemeColors.colorSecondary),
          ),
        ),
        _clearButton,
      ],
    ),
  );

  Widget get _userProfile => widget.showProfileButton
      ? InkWell(
          onTap: () {
            // Get.to(() => ProfileScreen());
          },
          overlayColor: WidgetStateColor.transparent,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            child: CircleAvatar(
              backgroundColor: ThemeColors.oldLatterLight4.withAlpha(50),
              radius: 2.h,
              // backgroundImage: CachedNetworkImageProvider(
              //   Helper.getProfileImageUrl(Preference.user.image),
              // ),
            ),
          ),
        )
      : Container();

  Widget get _searchIcon => widget.searchCallBack != null
      ? Padding(
          padding: const EdgeInsets.only(right: 10),
          child: SizedBox(
            width: 30,
            height: 30,
            child: MyFlatButton(
              onPressed: () => setState(() => widget.searchExpanded = true),
              color: ThemeColors.oldLatterLight4.withAlpha(50),
              padding: EdgeInsets.zero,
              shape: const CircleBorder(),
              child: Icon(
                Icons.search,
                color: ThemeColors.oldLatterLight4,
                size: 18,
              ),
            ),
          ),
        )
      : empty();

  Widget get _bellIcon => widget.showBellButton
      ? Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 6, top: 6, bottom: 6),
              child: SizedBox(
                width: 30,
                height: 30,
                child: MyFlatButton(
                  onPressed: () {
                    Get.back();
                    // Get.to(() => NotificationScreen());
                  },
                  color: ThemeColors.oldLatterLight4.withAlpha(50),
                  padding: EdgeInsets.zero,
                  shape: const CircleBorder(),
                  child: assetImage(
                    'assets/icons/bell_bold.png',
                    color: ThemeColors.oldLatterLight4,
                    width: 18,
                    height: 18,
                  ),
                ),
              ),
            ),
            Obx(
              () => Const.notificationCount.value > 0
                  ? Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: ThemeColors.oldLatterLight4,
                          shape: BoxShape.circle,
                        ), // non-const: ThemeColors.oldLatterLight4 is a getter
                        child: Center(
                          child: Text(
                            Const.notificationCount.value.toString(),
                            style: MyTextStyle(
                              color: ThemeColors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ), // ThemeColors.red is const - OK
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(width: 18, height: 18),
            ),
          ],
        )
      : empty();

  Widget get _clearButton => SizedBox(
    width: 40,
    height: 40,
    child: MyFlatButton(
      onPressed: () {
        if (widget.searchController!.text.isNotEmpty) {
          widget.searchController?.clear();
          widget.searchCallBack?.call('');
        } else {
          setState(() => widget.searchExpanded = false);
        }
      },
      color: ThemeColors.oldLatterLight4.withAlpha(50),
      padding: EdgeInsets.zero,
      shape: const CircleBorder(),
      child: const Icon(
        Icons.close,
        color: ThemeColors.colorSecondary,
        size: 18,
      ),
    ),
  );

  Widget get _backButton => widget.enableBackButton
      ? SizedBox(
          width: 40,
          height: 40,
          child: MyFlatButton(
            onPressed: widget.backCallBack ?? Get.back,
            // onPressed: () {
            //   if (backCallBack != null) {
            //     backCallBack.call();
            //   } else {
            //     Get.back();
            //   }
            // },
            padding: EdgeInsets.zero,
            shape: const CircleBorder(),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: ThemeColors.oldLatterLight4,
              size: 18,
            ),
          ),
        )
      : Container(width: 20);

  Widget get _menuButton => SizedBox(
    width: 40,
    height: 40,
    child: MyFlatButton(
      onPressed: () {
        widget.onMenuClick?.call();
      },
      padding: EdgeInsets.zero,
      shape: const CircleBorder(),
      child: Icon(Icons.menu, color: ThemeColors.oldLatterLight4, size: 24),
    ),
  );
}

PreferredSizeWidget normalAppBar(
  String title, {
  bool enableBackButton = false,
  bool showBellButton = false,
  bool enableClearButton = false,
  void Function()? backCallBack,
  bool searchExpanded = false,
  TextEditingController? searchController,
  Widget? trailing,
  List<Widget>? actions,
}) {
  return AppBar(
    backgroundColor: ThemeColors.appBar,
    elevation: 0,
    automaticallyImplyLeading: false,
    leading: enableBackButton
        ? InkWell(
            onTap: backCallBack ?? () => Get.back(),
            overlayColor: WidgetStatePropertyAll(ThemeColors.transparentColor),
            child: Icon(Icons.arrow_back, color: ThemeColors.oldLatterLight4),
          )
        : null,

    leadingWidth: 40,

    title: searchExpanded
        ? TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
            ),
          )
        : Text(
            title,
            style: TextStyle(
              color: ThemeColors.oldLatterLight4,
              fontSize: 5.w,
              fontWeight: FontWeight.w700,
            ),
          ),

    actions: [
      ?trailing,
      // trailing != null ? 3.w.hs : 0.hs,
      if (showBellButton)
        IconButton(
          // onPressed: () => Get.toNamed(AppRoutes.notification),
          onPressed: (){},
          icon: Icon(
            Icons.notifications_none,
            color: ThemeColors.oldLatterLight4,
          ),
        ),

      if (enableClearButton)
        IconButton(
          onPressed: searchController?.clear,
          icon: Icon(Icons.clear, color: ThemeColors.oldLatterLight4),
        ),

      ...?actions,
    ],
  );
}

// PreferredSizeWidget normalAppBar(
//   String title, {
//   bool? enableBackButton,
//   bool? showBellButton,
//   bool? showProfileButton,
//   bool? enableClearButton,
//   void Function()? backCallBack,
//   bool? searchExpanded,
//   TextEditingController? searchController,
//   Widget? trailing,
//   List<Widget>? actions,
// }) {
//   return AppBar(
//     backgroundColor: ThemeColors.appBar,
//     elevation: 0,
//     title: Text(
//       title,
//       style: TextStyle(
//         color: ThemeColors.oldLatterLight4,
//         fontSize: 5.w,
//         fontWeight: FontWeight.w700,
//       ),
//     ),
//     actions: [],
//   );
// }
