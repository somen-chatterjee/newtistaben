import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shopperz/app/modules/home_sub_category/controller/sub_category_wise_product_controller.dart';
import 'package:shopperz/app/modules/category/model/category_wise_product.dart';
import 'package:shopperz/app/modules/home_sub_category/widgets/price_range_widget.dart';
import 'package:shopperz/app/modules/home_sub_category/widgets/sort_by_widget.dart';
import 'package:shopperz/app/modules/home_sub_category/controller/sub_category_filter_controller.dart';
import 'package:shopperz/utils/svg_icon.dart';
import 'package:shopperz/widgets/custom_text.dart';
import 'package:shopperz/widgets/primary_button.dart';
import 'package:shopperz/widgets/textwidget.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../widgets/devider.dart';

class SubCategoryFilterScreen extends StatefulWidget {
  const SubCategoryFilterScreen({super.key, this.cateWiseProductModel});
  final Data? cateWiseProductModel;
  @override
  State<SubCategoryFilterScreen> createState() => _SubCategoryFilterScreenState();
}

class _SubCategoryFilterScreenState extends State<SubCategoryFilterScreen> {
  final cateWiseProductController = Get.find<SubCategoryWiseProductController>();
  final filterController = Get.find<SubCategoryFilterController>();
  var isExpanded = <int?>[];


  @override
  void initState() {
    super.initState();
    filterController.updateVariationList();
  }

  bool select = false;

  @override
  void dispose() {
    // filterController.resetFilter();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attributeKey = cateWiseProductController.variationsMap!.keys.toList();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.primaryBackgroundColor,
          elevation: 0,
          toolbarHeight: 48.h,
          leadingWidth: double.infinity,
          leading: Padding(
              padding: EdgeInsets.only(left: 16.w, top: 10.h, bottom: 10.h),
              child: TextWidget(
                text: 'Filter & Sorting'.tr,
                textAlign: TextAlign.left,
                color: AppColor.textColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              )),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: InkWell(
                onTap: () {

                  // var copyVariationIndexList = filterController.copyVariationIndexList;
                  // var variationIndexList = filterController.variationIndexList;
                  //
                  // // print("sam $copyVariationIndexList");
                  // // print("sam $variationIndexList");
                  //
                  // List<String> uncommonElements = (copyVariationIndexList.toSet().difference(variationIndexList.toSet()))
                  //     .union(variationIndexList.toSet().difference(copyVariationIndexList.toSet()))
                  //     .toList();
                  //
                  // // print("sam ${uncommonElements}");
                  //
                  // for(var element in uncommonElements) {
                  //   filterController.variationIndexList.remove(element);
                  // }
                  // // print("sam ${filterController.variationIndexList}");

                  Get.back();
                },
                child: SvgPicture.asset(
                  SvgIcon.closeOutline,
                  height: 24.h,
                  width: 24.w,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, top: 16.h, right: 16.w),
            child: Column(
              children: [
                const SortByWidget(),
                const DeviderWidget(),
                PriceRangeWidget(cateWiseProduct: widget.cateWiseProductModel),
                // BrandListWidget(cateWiseProduct: widget.cateWiseProductModel),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: attributeKey.length,
                  itemBuilder: (context, index) {
                    final attributeName = attributeKey[index];
                    final attributeOptions = cateWiseProductController
                        .variationsMap![attributeName] as List<dynamic>;

                    return Theme(
                      data: ThemeData()
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        childrenPadding: EdgeInsets.zero,
                          tilePadding: EdgeInsets.zero,
                          onExpansionChanged: (value) {
                            if (isExpanded.contains(index)) {
                              isExpanded.remove(index);
                            } else {
                              isExpanded.add(index);
                            }

                            setState(() {});
                          },
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "${attributeName.capitalize} ${attributeName == 'size' ? '(Search Setwise)': ''}",
                                color: AppColor.textColor,
                                size: 18.sp,
                                weight: FontWeight.w600,
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              const DeviderWidget(),
                            ],
                          ),
                          trailing: SvgPicture.asset(
                            isExpanded.contains(index)
                                ? SvgIcon.up
                                : SvgIcon.downEx,
                            height: 20.h,
                            width: 20.w,
                          ),
                          children: attributeOptions.map<Widget>((value) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {

                                          var variationObject = {
                                            "attribute":
                                                value["product_attribute_id"],
                                            "option": value[
                                                "product_attribute_option_id"],
                                          };

                                          // filterController.addVariationId(variationObject);

                                          // filterController.addVariationId(value[
                                          //         "product_attribute_option_id"]
                                          //     .toString());

                                          filterController.addVariationObject(
                                              variationObject);

                                          setState(() {});

                                        },
                                        child: SvgPicture.asset(
                                          filterController.checkVariationId({
                                            "attribute":
                                            value["product_attribute_id"],
                                            "option": value[
                                            "product_attribute_option_id"],
                                          })
                                              ? SvgIcon.checkActive
                                              : SvgIcon.check,
                                          height: 20.h,
                                          width: 20.w,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12.w,
                                      ),
                                      TextWidget(
                                        text: value['attribute_option_name']
                                            .toString(),
                                        color: AppColor.textColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      )
                                    ],
                                  ),
                                ),
                                isExpanded.contains(index)
                                    ? const SizedBox()
                                    : const DeviderWidget(),
                              ],
                            );
                          }).toList()),
                    );
                  },
                ),
                const DeviderWidget(),

              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  width: double.infinity,
                  height: 48,
                  text: 'Reset'.tr,
                    onTap: () {
                      filterController.resetFilter();

                      setState(() {});
                    }
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: PrimaryButton(
                  width: double.infinity,
                  height: 48,
                  text: 'Apply'.tr,
                  onTap: () {
                    if(filterController.variationObjectList.isNotEmpty) {
                      filterController.setVariations();
                    }

                    // filterController.variationObjectList.clear();
                    // filterController.copyVariationIndexList.clear();
                    //
                    // // loop for set filter data
                    // for (int i = 0; i < attributeKey.length; i++) {
                    //   final attributeOptions = cateWiseProductController
                    //       .variationsMap![attributeKey[i]] as List<dynamic>;
                    //
                    //   for (var variation in attributeOptions) {
                    //     var productAttributeId = variation["product_attribute_id"];
                    //     var productAttributeOptionId = variation['product_attribute_option_id'];
                    //
                    //
                    //     if (filterController.variationIndexList.contains(
                    //         productAttributeOptionId.toString())) {
                    //       var variationObject = {
                    //         "attribute": productAttributeId,
                    //         "option": productAttributeOptionId,
                    //       };
                    //
                    //       filterController.addVariationObject(variationObject);
                    //
                    //     }
                    //   }
                    // }

                    if((filterController.currentRangeValues.start > 0 || filterController.currentRangeValues.end.round() < widget.cateWiseProductModel!.maxPrice!)) {
                      filterController.setRange();
                    }

                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
