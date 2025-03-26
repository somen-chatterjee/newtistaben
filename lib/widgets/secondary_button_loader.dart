import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../config/theme/app_color.dart';
import 'custom_text.dart';

class SecondaryButtonLoader extends StatelessWidget {
  const SecondaryButtonLoader({
    super.key,
    required this.height,
    required this.width,
    this.buttonColor = AppColor.primaryColor,
    this.borderColor,
  });

  final double height;
  final double width;
  final Color? buttonColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: buttonColor,
          border: Border.all(color: borderColor ?? Colors.transparent)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 35.w,
              height: 35.h,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
          ),
        ],
      ),
    );
  }
}
