// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:eldoriaCare/utils/preference.dart';
// import 'package:eldoriaCare/values/theme_colors.dart';
// import 'package:eldoriaCare/widget/widgets.dart';
// import '../utils/helper.dart';
//
// class MyDrawer extends StatelessWidget {
//   const MyDrawer({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 80.w,
//       child: Drawer(
//         backgroundColor: ThemeColors.cardColorOf(context),
//         child: ListView(
//           physics: const BouncingScrollPhysics(),
//           padding: EdgeInsets.zero,
//           shrinkWrap: true,
//           children: [
//             _navHeader(),
//
//             // _navItem('assets/icons/home_outline.png', 'Home', () {
//             //   Get.back();
//             // }, selected: true),
//             _navItem('assets/icons/buildings.png', 'My Sites', () {
//               Get.back();
//               // Get.to(() => SurveyListScreen());
//             }),
//
//             _navItem('assets/icons/add_more.png', 'Create Survey', () {
//               Get.back();
//               // Get.to(() => CreateSurveyStationScreen());
//             }),
//
//             _navItem('assets/icons/logout_outline.png', 'Log Out', () {
//               Get.back();
//               Helper.logOut();
//             }),
//
//             //TODO: Comment 'Logs' & 'Tester Login' before app store submission
//             if (Helper.isTester) ...[
//               _navItem('assets/icons/hacker.png', 'TEST BUTTON', () {
//                 Get.back();
//               }),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _navHeader() {
//     return InkWell(
//       onTap: () {
//         Get.back();
//         //// Get.to(() => EditUserProfilePage());
//       },
//       child: Container(
//         decoration: const BoxDecoration(color: ThemeColors.primaryColor),
//         padding: const EdgeInsets.only(left: 15, top: 60, bottom: 10),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Welcome ${Preference.user.userInfo?.name}",
//               style: MyTextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: ThemeColors.white,
//               ),
//             ),
//             8.vs,
//             Text(
//               "SURVEYOR",
//               style: MyTextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//                 color: ThemeColors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _navItem(
//     String icon,
//     String title,
//     void Function() onTap, {
//     bool selected = false,
//     String suffix = '',
//   }) {
//     return TextButton(
//       onPressed: onTap,
//       style: TextButton.styleFrom(
//         elevation: 0,
//         shape: const RoundedRectangleBorder(),
//         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//       ),
//       child: Row(
//         children: [
//           assetImage(
//             icon,
//             color: ThemeColors.primaryColor,
//             width: 20,
//             height: 20,
//           ),
//           15.hs,
//           Expanded(
//             child: Text(
//               title,
//               style: MyTextStyle(
//                 fontSize: 16,
//                 color:
//                     // selected
//                     //     ? ThemeColors.textOnSurface(context)
//                     //     :
//                     ThemeColors.grey800,
//                 fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
//               ),
//             ),
//           ),
//           if (suffix.notEmpty)
//             Text(
//               suffix,
//               style: MyTextStyle(
//                 color:
//                     // selected
//                     // ? ThemeColors.textOnSurface(context)
//                     // :
//                     ThemeColors.grey700,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
