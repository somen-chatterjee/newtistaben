import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shopperz/app/modules/search/views/search_screen.dart';
import 'package:shopperz/utils/svg_icon.dart';
import 'package:shopperz/widgets/textwidget.dart';

import '../config/theme/app_color.dart';

// ignore: must_be_immutable
class AppBarWidget4 extends StatelessWidget implements PreferredSizeWidget {
  AppBarWidget4({super.key, required this.text, /*this.showDownload, this.onTap*/});

  String? text;
  // bool? showDownload;
  // VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.primaryBackgroundColor,
      elevation: 0,
      toolbarHeight: 48.h,
      // leadingWidth: double.infinity,
      leading: Padding(
        padding: EdgeInsets.only(left: 8.w, top: 8.h),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: SvgPicture.asset(
                SvgIcon.back,
                height: 24.h,
                width: 24.w,
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            TextWidget(
              text: '$text',
              color: AppColor.textColor,
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
            )
          ],
        ),
      ),
      centerTitle: true,
      title: SvgPicture.asset(
        SvgIcon.logo,
        height: 35.h,
        width: 73.w,
      ),
      actions: [
        // if (showDownload ?? false)
        //   GestureDetector(
        //     onTap: onTap,
        //     child: Container(
        //       padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 0.h),
        //       decoration: BoxDecoration(
        //         color: AppColor.primaryColor,
        //         borderRadius: BorderRadius.all(Radius.circular(50.r)),
        //       ),
        //       child: Row(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           Column(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               TextWidget(
        //                 text: "Catalogue",
        //                 fontSize: 14,
        //                 fontWeight: FontWeight.w600,
        //                 color: AppColor.whiteColor,
        //               ),
        //               TextWidget(
        //                 text: "(Use filters)",
        //                 fontSize: 12,
        //                 color: AppColor.whiteColor,
        //               ),
        //             ],
        //           ),
        //           SizedBox(width: 10.w),
        //           SvgPicture.asset(
        //             "assets/icons/download.svg",
        //             width: 20,
        //             height: 20,
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // SizedBox(width: 10.w),
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: GestureDetector(
            onTap: () {
              Get.to(() => const SearchScreen());
            },
            child: SvgPicture.asset(
              SvgIcon.search,
              height: 24.h,
              width: 24.w,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
