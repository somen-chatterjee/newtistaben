import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shopperz/app/modules/category/model/category_wise_product.dart';
import 'package:shopperz/app/modules/home_sub_category/controller/sub_category_filter_controller.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/devider.dart';
import '../../../../widgets/textwidget.dart';

class PriceRangeWidget extends StatefulWidget {
  const PriceRangeWidget({super.key, this.cateWiseProduct});
  final Data? cateWiseProduct;

  @override
  State<PriceRangeWidget> createState() => _PriceRangeWidgetState();
}

class _PriceRangeWidgetState extends State<PriceRangeWidget> {
  final filterContrller = Get.put(SubCategoryFilterController());
  bool isExpanded = false;
  bool select = false;

  _onExpansionChanged(bool val) {
    setState(() {
      isExpanded = val;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.cateWiseProduct != null && widget.cateWiseProduct!.maxPrice != null) {

        var minPrice = filterContrller.minRange ?? 0;
        var maxPrice = filterContrller.maxRange ?? widget.cateWiseProduct!.maxPrice!;

        filterContrller.currentRangeValues = RangeValues(
            minPrice.toDouble(),
            maxPrice.toDouble(),
        );

        filterContrller.minPriceTextController.text = minPrice.toString();
        filterContrller.maxPriceTextController.text = maxPrice.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.cateWiseProduct != null && widget.cateWiseProduct?.maxPrice != null && widget.cateWiseProduct!.maxPrice! > 0) {
      var maxPrice = widget.cateWiseProduct!.maxPrice!;
      return Column(
        children: [
          Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              onExpansionChanged: _onExpansionChanged,
              trailing: SvgPicture.asset(
                isExpanded == true ? SvgIcon.up : SvgIcon.downEx,
                height: 20.h,
                width: 20.w,
              ),
              title: TextWidget(
                text: "Price".tr,
                color: AppColor.textColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextFormField(
                  controller: filterContrller.minPriceTextController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Min Price",
                    hintStyle: TextStyle(
                      color: AppColor.textColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: AppColor.redColor,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      return;
                    }

                    if (value.isNotEmpty) {
                      if(value == "0") {
                        filterContrller.minPriceTextController.clear();
                      }

                      // getting max price
                      double? enteredMinPrice = double.tryParse(value);

                      if (enteredMinPrice != null) {
                        if (enteredMinPrice > filterContrller.currentRangeValues.end) {
                          filterContrller.currentRangeValues = RangeValues(
                            filterContrller.currentRangeValues.end,
                            filterContrller.currentRangeValues.end,
                          );
                          filterContrller.minPriceTextController.text = filterContrller.currentRangeValues.end.round().toString();
                        } else {
                          // Update RangeSlider with valid Min Price
                          filterContrller.currentRangeValues = RangeValues(
                            enteredMinPrice,
                            filterContrller.currentRangeValues.end,
                          );
                        }
                      }
                    }
                    setState(() {});
                  },
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: filterContrller.maxPriceTextController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    // Allow only numbers// Max allowed value
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Max Price",
                    hintStyle: TextStyle(
                      color: AppColor.textColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppColor.textColor),
                    ),
                  ),
                  onChanged: (value) {

                    if (value.isEmpty) {
                      filterContrller.currentRangeValues = RangeValues(
                        filterContrller.currentRangeValues.start,
                        0,
                      );
                      return;
                    }

                    if(value == "0") {
                      filterContrller.maxPriceTextController.clear();
                    }

                    if (value.isNotEmpty) {
                      // getting max price
                      double? enteredMaxPrice = double.tryParse(value);

                      if (enteredMaxPrice != null) {
                        if (enteredMaxPrice > maxPrice) {
                          filterContrller.currentRangeValues = RangeValues(
                            filterContrller.currentRangeValues.start,
                            maxPrice.round().toDouble(),
                          );
                          filterContrller.maxPriceTextController.text = maxPrice.toString();
                        } else if (enteredMaxPrice < filterContrller.currentRangeValues.start) {

                          filterContrller.maxPriceTextController.text = filterContrller.currentRangeValues.start.round().toString();

                          filterContrller.currentRangeValues = RangeValues(
                            0,
                            filterContrller.currentRangeValues.start,
                          );

                          filterContrller.minPriceTextController.text = filterContrller.currentRangeValues.start.round().toString();

                        } else {
                          // Update RangeSlider with valid Min Price
                          filterContrller.currentRangeValues = RangeValues(
                            filterContrller.currentRangeValues.start,
                            enteredMaxPrice.round().toDouble(),
                          );
                        }
                      }
                    }

                    setState(() {});
                  },
                ),
                SizedBox(height: 12.h),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbColor: AppColor.whiteColor,
                    // Change the thumb color
                    activeTrackColor: AppColor.redColor,
                    // Change active track color
                    inactiveTrackColor: AppColor.grayColor,
                    // Change inactive track color
                    overlayColor: AppColor.grayColor.withValues(alpha: 0.2),
                    // Change overlay color
                    rangeThumbShape: RoundRangeSliderThumbShape(
                      elevation: 4,
                    ),
                  ),
                  child: RangeSlider(
                    values: filterContrller.currentRangeValues,
                    max: maxPrice.toDouble(),
                    //       divisions: 1,
                    labels: RangeLabels(
                      filterContrller.currentRangeValues.start.round().toString(),
                      filterContrller.currentRangeValues.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        filterContrller.currentRangeValues = values;
                      });

                      filterContrller.minPriceTextController.text =
                          values.start.round().toString();
                      filterContrller.maxPriceTextController.text =
                          values.end.round().toString();
                    },
                  ),
                ),
              ],
            ),
          ),
          const DeviderWidget()
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}