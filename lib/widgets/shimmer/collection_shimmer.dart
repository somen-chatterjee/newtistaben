import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CollectionShimmer extends StatelessWidget {
  const CollectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: SizedBox(
            width: double.infinity,
            height: 90.h,
            child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                separatorBuilder: (context, index) {
                  return SizedBox(width: 10.w);
                },
                itemBuilder: (BuildContext context, index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[200]!,
                    highlightColor: Colors.grey[300]!,
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color:
                            Colors.pink.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          width: 60,
                          height: 12,
                          decoration: BoxDecoration(
                            color:
                            Colors.pink.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20)
                          ),
                        ),

                      ],
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
