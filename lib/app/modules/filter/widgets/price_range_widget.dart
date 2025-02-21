import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shopperz/app/modules/category/model/category_wise_product.dart';

import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/devider.dart';
import '../../../../widgets/textwidget.dart';
import '../controller/filter_controller.dart';
import 'item.dart';

class PriceRangeWidget extends StatefulWidget {
  const PriceRangeWidget({super.key, this.cateWiseProduct});
  final Data? cateWiseProduct;

  @override
  State<PriceRangeWidget> createState() => _PriceRangeWidgetState();
}

class _PriceRangeWidgetState extends State<PriceRangeWidget> {
  final filterContrller = Get.put(FilterController());
  bool isExpanded = false;
  bool select = false;

  _onExpansionChanged(bool val) {
    setState(() {
      isExpanded = val;
    });
  }

  RangeValues _currentRangeValues = RangeValues(0, 0);

  final minPriceTextController = TextEditingController();
  final maxPriceTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.cateWiseProduct != null && widget.cateWiseProduct!.maxPrice != null) {

        _currentRangeValues = RangeValues(0, widget.cateWiseProduct!.maxPrice!.toDouble());

        minPriceTextController.text = "0";
        maxPriceTextController.text = widget.cateWiseProduct!.maxPrice.toString();
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
                  controller: minPriceTextController,
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
                        minPriceTextController.clear();
                      }

                      // getting max price
                      double? enteredMinPrice = double.tryParse(value);

                      if (enteredMinPrice != null) {
                        if (enteredMinPrice > _currentRangeValues.end) {
                          _currentRangeValues = RangeValues(
                            _currentRangeValues.end,
                            _currentRangeValues.end,
                          );
                          minPriceTextController.text = _currentRangeValues.end.round().toString();
                        } else {
                          // Update RangeSlider with valid Min Price
                          _currentRangeValues = RangeValues(
                            enteredMinPrice,
                            _currentRangeValues.end,
                          );
                        }
                      }
                    }
                    setState(() {});
                  },
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: maxPriceTextController,
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
                      _currentRangeValues = RangeValues(
                        _currentRangeValues.start,
                        0,
                      );
                      return;
                    }
                    if (value.isNotEmpty) {
                      // getting max price
                      double? enteredMaxPrice = double.tryParse(value);

                      if (enteredMaxPrice != null) {
                        if (enteredMaxPrice > maxPrice) {
                          print("sam if");
                          _currentRangeValues = RangeValues(
                            _currentRangeValues.start,
                            maxPrice.round().toDouble(),
                          );
                          maxPriceTextController.text = maxPrice.toString();
                        } else if (enteredMaxPrice < _currentRangeValues.start) {

                          maxPriceTextController.text = _currentRangeValues.start.round().toString();

                          // Update RangeSlider with valid Min Price
                          _currentRangeValues = RangeValues(
                            0,
                            _currentRangeValues.start,
                          );

                          minPriceTextController.text = _currentRangeValues.start.round().toString();


                        } else {
                          // Update RangeSlider with valid Min Price
                          _currentRangeValues = RangeValues(
                            _currentRangeValues.start,
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
                    values: _currentRangeValues,
                    max: maxPrice.toDouble(),
                    //       divisions: 1,
                    labels: RangeLabels(
                      _currentRangeValues.start.round().toString(),
                      _currentRangeValues.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _currentRangeValues = values;
                      });

                      minPriceTextController.text =
                          values.start.round().toString();
                      maxPriceTextController.text =
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

class MaxValueInputFormatter extends TextInputFormatter {
  final double maxValue;

  MaxValueInputFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue; // Allow empty input

    double? value = double.tryParse(newValue.text);
    if (value == null || value > maxValue) {
      // Reject input if it exceeds maxValue
      return oldValue;
    }
    return newValue;
  }
}