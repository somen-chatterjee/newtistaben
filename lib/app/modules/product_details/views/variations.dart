import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shopperz/app/modules/cart/controller/cart_controller.dart';
import 'package:shopperz/app/modules/product_details/controller/product_details_controller.dart';
import 'package:shopperz/config/theme/app_color.dart';
import 'package:shopperz/utils/svg_icon.dart';
import 'package:shopperz/widgets/custom_text.dart';

class Variations extends StatefulWidget {
  const Variations({super.key});

  @override
  State<Variations> createState() => _VariationsState();
}

class _VariationsState extends State<Variations> {
  final productDetailsController = Get.find<ProductDetailsController>();
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return productDetailsController.initialIndex.value == -1 &&
              productDetailsController.initialVariationModel.value.data == null
          ? const SizedBox()
          : Column(
              children: [
                // color list
                colorList(),
                // size list
                sizeList(),
                // pattern List
                patternList(),

                productDetailsController.selectedIndex3.value == -1 &&
                        productDetailsController
                                .childrenVariationModel3.value.data ==
                            null
                    ? const SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productDetailsController
                                          .childrenVariationModel3.value.data !=
                                      null &&
                                  productDetailsController
                                      .childrenVariationModel3
                                      .value
                                      .data!
                                      .isNotEmpty
                              ? CustomText(
                                  text:
                                      '${productDetailsController.childrenVariationModel3.value.data?[0].productAttributeName.toString().tr ?? ''}:',
                                  size: 14.sp,
                                  weight: FontWeight.w600,
                                )
                              : SizedBox(),
                          productDetailsController
                                          .childrenVariationModel3.value.data !=
                                      null &&
                                  productDetailsController
                                      .childrenVariationModel3
                                      .value
                                      .data!
                                      .isNotEmpty
                              ? SizedBox(height: 8.h)
                              : SizedBox(),
                          productDetailsController
                                          .childrenVariationModel3.value.data !=
                                      null &&
                                  productDetailsController
                                      .childrenVariationModel3
                                      .value
                                      .data!
                                      .isNotEmpty
                              ? SizedBox(
                                  height: 32.h,
                                  child: ListView.builder(
                                      itemCount: productDetailsController
                                              .childrenVariationModel3
                                              .value
                                              .data
                                              ?.length ??
                                          0,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            cartController.numOfItems.value = 1;
                                            productDetailsController
                                                .selectedIndex4.value = index;

                                            productDetailsController
                                                .selectedIndex5.value = -1;
                                            productDetailsController
                                                .selectedIndex6.value = -1;
                                            productDetailsController
                                                .selectedIndex7.value = -1;

                                            productDetailsController
                                                .childrenVariationModel4
                                                .value
                                                .data
                                                ?.clear();
                                            productDetailsController
                                                .childrenVariationModel5
                                                .value
                                                .data
                                                ?.clear();
                                            productDetailsController
                                                .childrenVariationModel6
                                                .value
                                                .data
                                                ?.clear();

                                            if (productDetailsController
                                                    .childrenVariationModel3
                                                    .value
                                                    .data![index]
                                                    .sku !=
                                                null) {
                                              productDetailsController
                                                      .variationProductId
                                                      .value =
                                                  productDetailsController
                                                          .childrenVariationModel3
                                                          .value
                                                          .data?[index]
                                                          .id
                                                          .toString() ??
                                                      '';
                                              productDetailsController
                                                      .variationProductPrice
                                                      .value =
                                                  productDetailsController
                                                          .childrenVariationModel3
                                                          .value
                                                          .data?[index]
                                                          .price
                                                          .toString() ??
                                                      '';
                                              productDetailsController
                                                  .variationProductCurrencyPrice
                                                  .value = productDetailsController
                                                      .childrenVariationModel3
                                                      .value
                                                      .data?[index]
                                                      .currencyPrice
                                                      .toString() ??
                                                  '';
                                              productDetailsController
                                                      .variationProductOldPrice
                                                      .value =
                                                  productDetailsController
                                                          .childrenVariationModel3
                                                          .value
                                                          .data?[index]
                                                          .oldPrice
                                                          .toString() ??
                                                      '';
                                              productDetailsController
                                                  .variationProductOldCurrencyPrice
                                                  .value = productDetailsController
                                                      .childrenVariationModel3
                                                      .value
                                                      .data?[index]
                                                      .oldCurrencyPrice
                                                      .toString() ??
                                                  '';
                                              productDetailsController
                                                      .variationsku.value =
                                                  productDetailsController
                                                          .childrenVariationModel3
                                                          .value
                                                          .data?[index]
                                                          .sku
                                                          .toString() ??
                                                      '';
                                              productDetailsController
                                                      .variationsStock.value =
                                                  productDetailsController
                                                          .childrenVariationModel3
                                                          .value
                                                          .data?[index]
                                                          .stock!
                                                          .toInt() ??
                                                      0;
                                            } else {
                                              productDetailsController
                                                  .variationProductId
                                                  .value = '';
                                              productDetailsController
                                                  .variationProductPrice
                                                  .value = '';
                                              productDetailsController
                                                  .variationProductCurrencyPrice
                                                  .value = '';
                                              productDetailsController
                                                  .variationProductOldPrice
                                                  .value = '';
                                              productDetailsController
                                                  .variationProductOldCurrencyPrice
                                                  .value = '';
                                              productDetailsController
                                                  .variationsku.value = '';
                                              productDetailsController
                                                  .variationsStock.value = -1;
                                            }

                                            if (productDetailsController
                                                    .childrenVariationModel3
                                                    .value
                                                    .data?[index]
                                                    .sku ==
                                                null) {
                                              await productDetailsController
                                                  .fetchChildrenVariation4(
                                                      initialVariationId:
                                                          productDetailsController
                                                              .childrenVariationModel3
                                                              .value
                                                              .data![index]
                                                              .id
                                                              .toString());
                                            }
                                          },
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.w),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: productDetailsController
                                                              .selectedIndex4
                                                              .value ==
                                                          index
                                                      ? AppColor.primaryColor
                                                      : AppColor.cartColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.r)),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 12.5.w,
                                                    right: 12.5.w),
                                                child: Center(
                                                  child: CustomText(
                                                    text: productDetailsController
                                                            .childrenVariationModel3
                                                            .value
                                                            .data?[index]
                                                            .productAttributeOptionName ??
                                                        '',
                                                    color: productDetailsController
                                                                .selectedIndex4
                                                                .value ==
                                                            index
                                                        ? Colors.white
                                                        : Colors.black,
                                                    size: 12.sp,
                                                    weight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              : SizedBox(),
                          productDetailsController
                                          .childrenVariationModel3.value.data !=
                                      null &&
                                  productDetailsController
                                      .childrenVariationModel3
                                      .value
                                      .data!
                                      .isNotEmpty
                              ? SizedBox(height: 24.h)
                              : SizedBox(),
                        ],
                      ),
                productDetailsController.selectedIndex4.value == -1 &&
                        productDetailsController
                                .childrenVariationModel4.value.data ==
                            null
                    ? const SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productDetailsController
                                          .childrenVariationModel4.value.data !=
                                      null &&
                                  productDetailsController
                                      .childrenVariationModel4
                                      .value
                                      .data!
                                      .isNotEmpty
                              ? CustomText(
                                  text:
                                      '${productDetailsController.childrenVariationModel4.value.data?[0].productAttributeName.toString().tr ?? ''}:',
                                  size: 14.sp,
                                  weight: FontWeight.w600,
                                )
                              : SizedBox(),
                          productDetailsController
                                          .childrenVariationModel4.value.data !=
                                      null &&
                                  productDetailsController
                                      .childrenVariationModel4
                                      .value
                                      .data!
                                      .isNotEmpty
                              ? SizedBox(height: 8.h)
                              : SizedBox(),
                          productDetailsController
                                          .childrenVariationModel4.value.data !=
                                      null &&
                                  productDetailsController
                                      .childrenVariationModel4
                                      .value
                                      .data!
                                      .isNotEmpty
                              ? SizedBox(
                                  height: 32.h,
                                  child: ListView.builder(
                                      itemCount: productDetailsController
                                              .childrenVariationModel4
                                              .value
                                              .data
                                              ?.length ??
                                          0,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            cartController.numOfItems.value = 1;
                                            productDetailsController
                                                .selectedIndex5.value = index;

                                            productDetailsController
                                                .selectedIndex6.value = -1;
                                            productDetailsController
                                                .selectedIndex7.value = -1;

                                            productDetailsController
                                                .childrenVariationModel5
                                                .value
                                                .data
                                                ?.clear();
                                            productDetailsController
                                                .childrenVariationModel6
                                                .value
                                                .data
                                                ?.clear();

                                            if (productDetailsController
                                                    .childrenVariationModel4
                                                    .value
                                                    .data![index]
                                                    .sku !=
                                                null) {
                                              productDetailsController
                                                      .variationProductId
                                                      .value =
                                                  productDetailsController
                                                          .childrenVariationModel4
                                                          .value
                                                          .data?[index]
                                                          .id
                                                          .toString() ??
                                                      '';
                                              productDetailsController
                                                      .variationProductPrice
                                                      .value =
                                                  productDetailsController
                                                          .childrenVariationModel4
                                                          .value
                                                          .data?[index]
                                                          .price
                                                          .toString() ??
                                                      '';
                                              productDetailsController
                                                  .variationProductCurrencyPrice
                                                  .value = productDetailsController
                                                      .childrenVariationModel4
                                                      .value
                                                      .data?[index]
                                                      .currencyPrice
                                                      .toString() ??
                                                  '';
                                              productDetailsController
                                                      .variationProductOldPrice
                                                      .value =
                                                  productDetailsController
                                                          .childrenVariationModel4
                                                          .value
                                                          .data?[index]
                                                          .oldPrice
                                                          .toString() ??
                                                      '';
                                              productDetailsController
                                                  .variationProductOldCurrencyPrice
                                                  .value = productDetailsController
                                                      .childrenVariationModel4
                                                      .value
                                                      .data?[index]
                                                      .oldCurrencyPrice
                                                      .toString() ??
                                                  '';
                                              productDetailsController
                                                      .variationsku.value =
                                                  productDetailsController
                                                          .childrenVariationModel4
                                                          .value
                                                          .data?[index]
                                                          .sku
                                                          .toString() ??
                                                      '';
                                              productDetailsController
                                                      .variationsStock.value =
                                                  productDetailsController
                                                          .childrenVariationModel4
                                                          .value
                                                          .data?[index]
                                                          .stock!
                                                          .toInt() ??
                                                      0;
                                            } else {
                                              productDetailsController
                                                  .variationProductId
                                                  .value = '';
                                              productDetailsController
                                                  .variationProductPrice
                                                  .value = '';
                                              productDetailsController
                                                  .variationProductCurrencyPrice
                                                  .value = '';
                                              productDetailsController
                                                  .variationProductOldPrice
                                                  .value = '';
                                              productDetailsController
                                                  .variationProductOldCurrencyPrice
                                                  .value = '';
                                              productDetailsController
                                                  .variationsku.value = '';
                                              productDetailsController
                                                  .variationsStock.value = -1;
                                            }

                                            if (productDetailsController
                                                    .childrenVariationModel4
                                                    .value
                                                    .data![index]
                                                    .sku ==
                                                null) {
                                              await productDetailsController
                                                  .fetchChildrenVariation5(
                                                      initialVariationId:
                                                          productDetailsController
                                                              .childrenVariationModel4
                                                              .value
                                                              .data![index]
                                                              .id
                                                              .toString());
                                            }
                                          },
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.w),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: productDetailsController
                                                              .selectedIndex5
                                                              .value ==
                                                          index
                                                      ? AppColor.primaryColor
                                                      : AppColor.cartColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.r)),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 12.5.w,
                                                    right: 12.5.w),
                                                child: Center(
                                                  child: CustomText(
                                                    text: productDetailsController
                                                            .childrenVariationModel4
                                                            .value
                                                            .data?[index]
                                                            .productAttributeOptionName ??
                                                        '',
                                                    color: productDetailsController
                                                                .selectedIndex5
                                                                .value ==
                                                            index
                                                        ? Colors.white
                                                        : Colors.black,
                                                    size: 12.sp,
                                                    weight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              : SizedBox(),
                          productDetailsController
                                          .childrenVariationModel4.value.data !=
                                      null &&
                                  productDetailsController
                                      .childrenVariationModel4
                                      .value
                                      .data!
                                      .isNotEmpty
                              ? SizedBox(height: 24.h)
                              : SizedBox(),
                        ],
                      ),
                productDetailsController.selectedIndex5.value == -1 &&
                        productDetailsController
                                .childrenVariationModel5.value.data ==
                            null
                    ? const SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productDetailsController
                                          .childrenVariationModel5.value.data !=
                                      null &&
                                  productDetailsController
                                      .childrenVariationModel5
                                      .value
                                      .data!
                                      .isNotEmpty
                              ? CustomText(
                                  text:
                                      '${productDetailsController.childrenVariationModel5.value.data?[0].productAttributeName.toString().tr ?? ''}:',
                                  size: 15.sp,
                                  weight: FontWeight.w600,
                                )
                              : SizedBox(),
                          productDetailsController
                                          .childrenVariationModel5.value.data !=
                                      null &&
                                  productDetailsController
                                      .childrenVariationModel5
                                      .value
                                      .data!
                                      .isNotEmpty
                              ? SizedBox(height: 8.h)
                              : SizedBox(),
                          productDetailsController
                                          .childrenVariationModel5.value.data !=
                                      null &&
                                  productDetailsController
                                      .childrenVariationModel5
                                      .value
                                      .data!
                                      .isNotEmpty
                              ? SizedBox(
                                  height: 32.h,
                                  child: ListView.builder(
                                      itemCount: productDetailsController
                                              .childrenVariationModel5
                                              .value
                                              .data
                                              ?.length ??
                                          0,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            cartController.numOfItems.value = 1;
                                            productDetailsController
                                                .selectedIndex6.value = index;

                                            productDetailsController
                                                .selectedIndex7.value = -1;

                                            productDetailsController
                                                .childrenVariationModel6
                                                .value
                                                .data
                                                ?.clear();

                                            if (productDetailsController
                                                    .childrenVariationModel5
                                                    .value
                                                    .data![index]
                                                    .sku !=
                                                null) {
                                              productDetailsController
                                                      .variationProductId
                                                      .value =
                                                  productDetailsController
                                                          .childrenVariationModel5
                                                          .value
                                                          .data?[index]
                                                          .id
                                                          .toString() ??
                                                      '';
                                              productDetailsController
                                                      .variationProductPrice
                                                      .value =
                                                  productDetailsController
                                                          .childrenVariationModel5
                                                          .value
                                                          .data?[index]
                                                          .price
                                                          .toString() ??
                                                      '';
                                              productDetailsController
                                                  .variationProductCurrencyPrice
                                                  .value = productDetailsController
                                                      .childrenVariationModel5
                                                      .value
                                                      .data?[index]
                                                      .currencyPrice
                                                      .toString() ??
                                                  '';
                                              productDetailsController
                                                      .variationProductOldPrice
                                                      .value =
                                                  productDetailsController
                                                          .childrenVariationModel5
                                                          .value
                                                          .data?[index]
                                                          .oldPrice
                                                          .toString() ??
                                                      '';
                                              productDetailsController
                                                  .variationProductOldCurrencyPrice
                                                  .value = productDetailsController
                                                      .childrenVariationModel5
                                                      .value
                                                      .data?[index]
                                                      .oldCurrencyPrice
                                                      .toString() ??
                                                  '';
                                              productDetailsController
                                                      .variationsku.value =
                                                  productDetailsController
                                                          .childrenVariationModel5
                                                          .value
                                                          .data?[index]
                                                          .sku
                                                          .toString() ??
                                                      '';
                                              productDetailsController
                                                      .variationsStock.value =
                                                  productDetailsController
                                                          .childrenVariationModel5
                                                          .value
                                                          .data?[index]
                                                          .stock!
                                                          .toInt() ??
                                                      0;
                                            } else {
                                              productDetailsController
                                                  .variationProductId
                                                  .value = '';
                                              productDetailsController
                                                  .variationProductPrice
                                                  .value = '';
                                              productDetailsController
                                                  .variationProductCurrencyPrice
                                                  .value = '';
                                              productDetailsController
                                                  .variationProductOldPrice
                                                  .value = '';
                                              productDetailsController
                                                  .variationProductOldCurrencyPrice
                                                  .value = '';
                                              productDetailsController
                                                  .variationsku.value = '';
                                              productDetailsController
                                                  .variationsStock.value = -1;
                                            }

                                            if (productDetailsController
                                                    .childrenVariationModel5
                                                    .value
                                                    .data![index]
                                                    .sku ==
                                                null) {
                                              await productDetailsController
                                                  .fetchChildrenVariation6(
                                                      initialVariationId:
                                                          productDetailsController
                                                              .childrenVariationModel5
                                                              .value
                                                              .data![index]
                                                              .id
                                                              .toString());
                                            }
                                          },
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.w),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: productDetailsController
                                                              .selectedIndex6
                                                              .value ==
                                                          index
                                                      ? AppColor.primaryColor
                                                      : AppColor.cartColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.r)),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 12.5.w,
                                                    right: 12.5.w),
                                                child: Center(
                                                  child: CustomText(
                                                    text: productDetailsController
                                                            .childrenVariationModel5
                                                            .value
                                                            .data?[index]
                                                            .productAttributeOptionName ??
                                                        '',
                                                    color: productDetailsController
                                                                .selectedIndex6
                                                                .value ==
                                                            index
                                                        ? Colors.white
                                                        : Colors.black,
                                                    size: 12.sp,
                                                    weight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              : SizedBox(),
                          productDetailsController
                                          .childrenVariationModel5.value.data !=
                                      null &&
                                  productDetailsController
                                      .childrenVariationModel5
                                      .value
                                      .data!
                                      .isNotEmpty
                              ? SizedBox(height: 24.h)
                              : SizedBox(),
                        ],
                      ),

                productDetailsController.selectedIndex6.value == -1 &&
                        productDetailsController
                                .childrenVariationModel6.value.data ==
                            null
                    ? const SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productDetailsController
                                          .childrenVariationModel6.value.data !=
                                      null &&
                                  productDetailsController
                                      .childrenVariationModel6
                                      .value
                                      .data!
                                      .isNotEmpty
                              ? CustomText(
                                  text:
                                      '${productDetailsController.childrenVariationModel6.value.data?[0].productAttributeName.toString().tr ?? ''}:',
                                  size: 14.sp,
                                  weight: FontWeight.w600,
                                )
                              : SizedBox(),
                          productDetailsController
                                          .childrenVariationModel6.value.data !=
                                      null &&
                                  productDetailsController
                                      .childrenVariationModel6
                                      .value
                                      .data!
                                      .isNotEmpty
                              ? SizedBox(height: 8.h)
                              : SizedBox(),
                          productDetailsController
                                          .childrenVariationModel6.value.data !=
                                      null &&
                                  productDetailsController
                                      .childrenVariationModel6
                                      .value
                                      .data!
                                      .isNotEmpty
                              ? SizedBox(
                                  height: 32.h,
                                  child: ListView.builder(
                                      itemCount: productDetailsController
                                              .childrenVariationModel6
                                              .value
                                              .data
                                              ?.length ??
                                          0,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            cartController.numOfItems.value = 1;

                                            productDetailsController
                                                .selectedIndex7.value = index;

                                            if (productDetailsController
                                                    .childrenVariationModel6
                                                    .value
                                                    .data?[index]
                                                    .sku !=
                                                null) {
                                              productDetailsController
                                                      .variationProductId
                                                      .value =
                                                  productDetailsController
                                                          .childrenVariationModel6
                                                          .value
                                                          .data?[index]
                                                          .id
                                                          .toString() ??
                                                      '';
                                              productDetailsController
                                                      .variationProductPrice
                                                      .value =
                                                  productDetailsController
                                                          .childrenVariationModel6
                                                          .value
                                                          .data?[index]
                                                          .price
                                                          .toString() ??
                                                      '';
                                              productDetailsController
                                                  .variationProductCurrencyPrice
                                                  .value = productDetailsController
                                                      .childrenVariationModel6
                                                      .value
                                                      .data?[index]
                                                      .currencyPrice
                                                      .toString() ??
                                                  '';
                                              productDetailsController
                                                      .variationProductOldPrice
                                                      .value =
                                                  productDetailsController
                                                          .childrenVariationModel6
                                                          .value
                                                          .data?[index]
                                                          .oldPrice
                                                          .toString() ??
                                                      '';
                                              productDetailsController
                                                  .variationProductOldCurrencyPrice
                                                  .value = productDetailsController
                                                      .childrenVariationModel6
                                                      .value
                                                      .data?[index]
                                                      .oldCurrencyPrice
                                                      .toString() ??
                                                  '';
                                              productDetailsController
                                                      .variationsku.value =
                                                  productDetailsController
                                                          .childrenVariationModel6
                                                          .value
                                                          .data?[index]
                                                          .sku
                                                          .toString() ??
                                                      '';
                                              productDetailsController
                                                      .variationsStock.value =
                                                  productDetailsController
                                                          .childrenVariationModel6
                                                          .value
                                                          .data?[index]
                                                          .stock!
                                                          .toInt() ??
                                                      0;
                                            } else {
                                              productDetailsController
                                                  .variationProductId
                                                  .value = '';
                                              productDetailsController
                                                  .variationProductPrice
                                                  .value = '';
                                              productDetailsController
                                                  .variationProductCurrencyPrice
                                                  .value = '';
                                              productDetailsController
                                                  .variationProductOldPrice
                                                  .value = '';
                                              productDetailsController
                                                  .variationProductOldCurrencyPrice
                                                  .value = '';
                                              productDetailsController
                                                  .variationsku.value = '';
                                              productDetailsController
                                                  .variationsStock.value = -1;
                                            }
                                          },
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.w),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: productDetailsController
                                                              .selectedIndex7
                                                              .value ==
                                                          index
                                                      ? AppColor.primaryColor
                                                      : AppColor.cartColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.r)),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 12.5.w,
                                                    right: 12.5.w),
                                                child: Center(
                                                  child: CustomText(
                                                    text: productDetailsController
                                                        .childrenVariationModel5
                                                        .value
                                                        .data![index]
                                                        .productAttributeOptionName,
                                                    color: productDetailsController
                                                                .selectedIndex7
                                                                .value ==
                                                            index
                                                        ? Colors.white
                                                        : Colors.black,
                                                    size: 12.sp,
                                                    weight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              : SizedBox(),
                          productDetailsController
                                          .childrenVariationModel5.value.data !=
                                      null &&
                                  productDetailsController
                                      .childrenVariationModel5
                                      .value
                                      .data!
                                      .isNotEmpty
                              ? SizedBox(height: 24.h)
                              : SizedBox(),
                        ],
                      ),
              ],
            );
    });
  }

  Widget colorList() {
    return productDetailsController.initialVariationModel.value.data != null &&
            productDetailsController
                .initialVariationModel.value.data!.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              productDetailsController.initialVariationModel.value.data !=
                          null &&
                      productDetailsController
                          .initialVariationModel.value.data!.isNotEmpty
                  ? CustomText(
                      text:
                          '${productDetailsController.initialVariationModel.value.data?[0].productAttributeName.toString().tr}:',
                      size: 14.sp,
                      weight: FontWeight.w600,
                    )
                  : SizedBox(),
              productDetailsController.initialVariationModel.value.data !=
                          null &&
                      productDetailsController
                          .initialVariationModel.value.data!.isNotEmpty
                  ? SizedBox(height: 8.h)
                  : SizedBox(),
              productDetailsController.initialVariationModel.value.data !=
                          null &&
                      productDetailsController
                          .initialVariationModel.value.data!.isNotEmpty
                  ? SizedBox(
                      height: 32.h,
                      child: ListView.builder(
                          itemCount: productDetailsController
                                  .initialVariationModel.value.data?.length ??
                              0,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            // color button
                            return GestureDetector(
                              onTap: () async {
                                cartController.numOfItems.value = 1;

                                productDetailsController.selectedIndex1.value =
                                    index;

                                productDetailsController.selectedIndex2.value =
                                    -1;
                                productDetailsController.selectedIndex3.value =
                                    -1;
                                productDetailsController.selectedIndex4.value =
                                    -1;
                                productDetailsController.selectedIndex5.value =
                                    -1;
                                productDetailsController.selectedIndex6.value =
                                    -1;
                                productDetailsController.selectedIndex7.value =
                                    -1;

                                productDetailsController
                                    .childrenVariationModel2.value.data
                                    ?.clear();
                                productDetailsController
                                    .childrenVariationModel3.value.data
                                    ?.clear();
                                productDetailsController
                                    .childrenVariationModel4.value.data
                                    ?.clear();
                                productDetailsController
                                    .childrenVariationModel5.value.data
                                    ?.clear();
                                productDetailsController
                                    .childrenVariationModel6.value.data
                                    ?.clear();

                                if (productDetailsController
                                        .initialVariationModel
                                        .value
                                        .data?[index]
                                        .sku !=
                                    null) {
                                  productDetailsController.variationProductId
                                      .value = productDetailsController
                                          .initialVariationModel
                                          .value
                                          .data?[index]
                                          .id
                                          .toString() ??
                                      '';
                                  productDetailsController.variationProductPrice
                                      .value = productDetailsController
                                          .initialVariationModel
                                          .value
                                          .data?[index]
                                          .price
                                          .toString() ??
                                      '';
                                  productDetailsController
                                      .variationProductCurrencyPrice
                                      .value = productDetailsController
                                          .initialVariationModel
                                          .value
                                          .data?[index]
                                          .currencyPrice
                                          .toString() ??
                                      '';
                                  productDetailsController
                                      .variationProductOldPrice
                                      .value = productDetailsController
                                          .initialVariationModel
                                          .value
                                          .data?[index]
                                          .oldPrice
                                          .toString() ??
                                      '';
                                  productDetailsController
                                      .variationProductOldCurrencyPrice
                                      .value = productDetailsController
                                          .initialVariationModel
                                          .value
                                          .data?[index]
                                          .oldCurrencyPrice
                                          .toString() ??
                                      '';
                                  productDetailsController.variationsku.value =
                                      productDetailsController
                                              .initialVariationModel
                                              .value
                                              .data?[index]
                                              .sku
                                              .toString() ??
                                          '';
                                  productDetailsController.variationsStock
                                      .value = productDetailsController
                                          .initialVariationModel
                                          .value
                                          .data?[index]
                                          .stock!
                                          .toInt() ??
                                      0;
                                } else {
                                  productDetailsController
                                      .variationProductId.value = '';
                                  productDetailsController
                                      .variationProductPrice.value = '';
                                  productDetailsController
                                      .variationProductCurrencyPrice.value = '';
                                  productDetailsController
                                      .variationProductOldPrice.value = '';
                                  productDetailsController
                                      .variationProductOldCurrencyPrice
                                      .value = '';
                                  productDetailsController.variationsku.value =
                                      '';
                                  productDetailsController
                                      .variationsStock.value = -1;
                                }

                                if (productDetailsController
                                        .initialVariationModel
                                        .value
                                        .data?[index]
                                        .sku ==
                                    null) {
                                  await productDetailsController
                                      .fetchChildrenVariation1(
                                          initialVariationId:
                                              productDetailsController
                                                  .initialVariationModel
                                                  .value
                                                  .data![index]
                                                  .id
                                                  .toString());
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: productDetailsController
                                                .selectedIndex1.value ==
                                            index
                                        ? AppColor.primaryColor
                                        : AppColor.cartColor,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 12.5.w, right: 12.5.w),
                                    child: Center(
                                      child: CustomText(
                                        text: productDetailsController
                                                .initialVariationModel
                                                .value
                                                .data?[index]
                                                .productAttributeOptionName ??
                                            '',
                                        color: productDetailsController
                                                    .selectedIndex1.value ==
                                                index
                                            ? Colors.white
                                            : Colors.black,
                                        size: 12.sp,
                                        weight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  : SizedBox(),
              productDetailsController.initialVariationModel.value.data !=
                          null &&
                      productDetailsController
                          .initialVariationModel.value.data!.isNotEmpty
                  ? SizedBox(height: 24.h)
                  : SizedBox(),
            ],
          )
        : SizedBox();
  }

  Widget sizeList() {
    return productDetailsController.selectedIndex1.value == -1 &&
            productDetailsController.childrenVariationModel1.value.data == null
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // size chart title
              productDetailsController.childrenVariationModel1.value.data !=
                          null &&
                      productDetailsController
                          .childrenVariationModel1.value.data!.isNotEmpty
                  ? CustomText(
                      text:
                          '${productDetailsController.childrenVariationModel1.value.data?[0].productAttributeName.toString().tr}:',
                      size: 14.sp,
                      weight: FontWeight.w600,
                    )
                  : SizedBox(),

              // manage height
              productDetailsController.childrenVariationModel1.value.data !=
                          null &&
                      productDetailsController
                          .childrenVariationModel1.value.data!.isNotEmpty
                  ? SizedBox(height: 8.h)
                  : SizedBox(),

              // size chart list
              productDetailsController.childrenVariationModel1.value.data !=
                          null &&
                      productDetailsController
                          .childrenVariationModel1.value.data!.isNotEmpty
                  ? ListView.separated(
                      itemCount: productDetailsController
                              .childrenVariationModel1.value.data?.length ??
                          0,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return Divider(height: 16.sp);
                      },
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {},
                          /*async {
                  cartController.numOfItems.value = 1;

                  // change to size index
                  productDetailsController.selectedIndex2.value =
                      index;

                  productDetailsController.selectedIndex3.value = -1;
                  productDetailsController.selectedIndex4.value = -1;
                  productDetailsController.selectedIndex5.value = -1;
                  productDetailsController.selectedIndex6.value = -1;
                  productDetailsController.selectedIndex7.value = -1;

                  productDetailsController
                      .childrenVariationModel2.value.data
                      ?.clear();
                  productDetailsController
                      .childrenVariationModel3.value.data
                      ?.clear();
                  productDetailsController
                      .childrenVariationModel4.value.data
                      ?.clear();
                  productDetailsController
                      .childrenVariationModel5.value.data
                      ?.clear();
                  productDetailsController
                      .childrenVariationModel6.value.data
                      ?.clear();

                  if (productDetailsController.childrenVariationModel1
                      .value.data?[index].sku !=
                      null) {
                    productDetailsController.variationProductId
                        .value = productDetailsController
                        .childrenVariationModel1
                        .value
                        .data?[index]
                        .id
                        .toString() ??
                        '';
                    productDetailsController.variationProductPrice
                        .value = productDetailsController
                        .childrenVariationModel1
                        .value
                        .data?[index]
                        .price
                        .toString() ??
                        '';
                    productDetailsController
                        .variationProductCurrencyPrice
                        .value = productDetailsController
                        .childrenVariationModel1
                        .value
                        .data?[index]
                        .currencyPrice
                        .toString() ??
                        '';
                    productDetailsController.variationProductOldPrice
                        .value = productDetailsController
                        .childrenVariationModel1
                        .value
                        .data?[index]
                        .oldPrice
                        .toString() ??
                        '';
                    productDetailsController
                        .variationProductOldCurrencyPrice
                        .value = productDetailsController
                        .childrenVariationModel1
                        .value
                        .data?[index]
                        .oldCurrencyPrice
                        .toString() ??
                        '';
                    productDetailsController.variationsku.value =
                        productDetailsController
                            .childrenVariationModel1
                            .value
                            .data?[index]
                            .sku
                            .toString() ??
                            '';
                    productDetailsController.variationsStock.value =
                        productDetailsController
                            .childrenVariationModel1
                            .value
                            .data?[index]
                            .stock!
                            .toInt() ??
                            0;
                  } else {
                    productDetailsController
                        .variationProductId.value = '';
                    productDetailsController
                        .variationProductPrice.value = '';
                    productDetailsController
                        .variationProductCurrencyPrice.value = '';
                    productDetailsController
                        .variationProductOldPrice.value = '';
                    productDetailsController
                        .variationProductOldCurrencyPrice.value = '';
                    productDetailsController.variationsku.value = '';
                    productDetailsController.variationsStock.value =
                    -1;
                  }
                  if (productDetailsController.childrenVariationModel1
                      .value.data?[index].sku ==
                      null) {
                    await productDetailsController
                        .fetchChildrenVariation2(
                        initialVariationId:
                        productDetailsController
                            .childrenVariationModel1
                            .value
                            .data![index]
                            .id
                            .toString());
                  }
                }*/
                          child: Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: /*productDetailsController
                                                      .selectedIndex2.value ==
                                                  index
                                              ? */AppColor.primaryColor,
                                              // : AppColor.cartColor,
                                          shape: BoxShape.circle),
                                      child: Padding(
                                        padding: EdgeInsets.all(12.5.w),
                                        child: Center(
                                          child: CustomText(
                                            text: productDetailsController
                                                    .childrenVariationModel1
                                                    .value
                                                    .data?[index]
                                                    .productAttributeOptionName ??
                                                '',
                                            color: /*productDetailsController
                                                        .selectedIndex2.value ==
                                                    index
                                                ?*/ Colors.white,
                                                // : Colors.black,
                                            size: 12.sp,
                                            weight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    CustomText(
                                      text: productDetailsController
                                              .childrenVariationModel1
                                              .value
                                              .data?[index]
                                              .currencyPrice ??
                                          '',
                                      size: 14.sp,
                                    ),
                                  ],
                                ),
                                // qty container
                                Container(
                                  width: 99.w,
                                  height: 36.h,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(20.r),
                                    color: AppColor.cartColor,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      // decrement button
                                      GestureDetector(
                                        onTap: () {
                                          productDetailsController.incrementDecrementQty(index: index,isIncrement: false,);
                                        },
                                        /*{
                                                                                                // Variation is not empty
                                                                                                if (productDetailsController
                                                                                                    .initialVariationModel
                                                                                                    .value
                                                                                                    .data!
                                                                                                    .isNotEmpty ||
                                                                                                    productDetailsController
                                                                                                        .initialVariationModel
                                                                                                        .value
                                                                                                        .data!.isNotEmpty) {
                                                                                                  if (productDetailsController
                                                                                                      .variationsStock
                                                                                                      .value <
                                                                                                      0) {
                                                                                                  } else {
                                                                                                    if (cartController
                                                                                                        .numOfItems.value >
                                                                                                        1) {
                                                                                                      cartController
                                                                                                          .numOfItems.value--;
                                                                                                    } else {}
                                                                                                  }
                                                                                                }
                                                                                                // Initial Variation null
                                                                                                else {
                                                                                                  if (productDetailsController
                                                                                                      .productModel
                                                                                                      .value
                                                                                                      .data!
                                                                                                      .stock! >
                                                                                                      1 &&
                                                                                                      cartController.numOfItems
                                                                                                          .value >
                                                                                                          1) {
                                                                                                    cartController
                                                                                                        .numOfItems.value--;
                                                                                                  } else {}
                                                                                                }
                                                                                              }*/
                                        child: (productDetailsController
                                            .childrenVariationModel1.value.data?[index].numOfItem ?? 0) > 0
                                            ? SvgPicture.asset(
                                          SvgIcon.decrement,
                                          color: Colors.black,
                                          height: 20.h,
                                          width: 20.w,
                                        )
                                            : SvgPicture.asset(
                                            SvgIcon.decrement,
                                            color: Colors.grey,
                                            height: 20.h,
                                            width: 20.w),
                                      ),

                                      // // Intial variation null
                                      // productDetailsController
                                      //     .initialVariationModel
                                      //     .value
                                      //     .data ==
                                      //     null ||
                                      //     productDetailsController
                                      //         .initialVariationModel
                                      //         .value
                                      //         .data!
                                      //         .isEmpty
                                      //     ? productDetailsController
                                      //     .productModel
                                      //     .value
                                      //     .data!
                                      //     .stock! >
                                      //     1 &&
                                      //     cartController
                                      //         .numOfItems
                                      //         .value >
                                      //         1
                                      //     ?
                                      // // decrement active
                                      // SvgPicture.asset(
                                      //     SvgIcon.decrement,
                                      //     color: Colors.black,
                                      //     height: 20.h,
                                      //     width: 20.w)
                                      //     :
                                      //
                                      // // decrement inActive
                                      // SvgPicture.asset(
                                      //     SvgIcon.decrement,
                                      //     color: Colors.grey,
                                      //     height: 20.h,
                                      //     width: 20.w)
                                      //     :
                                      //
                                      // // Intial variation Not null
                                      //
                                      // productDetailsController.variationsStock
                                      //     .value != -1
                                      //     ? cartController.numOfItems.value == 1 ||
                                      //     productDetailsController.variationsStock
                                      //         .value == 1
                                      //     ? SvgPicture.asset(
                                      //     SvgIcon.decrement, color: Colors.grey,
                                      //     height: 20.h,
                                      //     width: 20.w)
                                      //     : SvgPicture.asset(
                                      //     SvgIcon.decrement, height: 20.h,
                                      //     width: 20.w)
                                      //     : SvgPicture.asset(
                                      //     SvgIcon.decrement, height: 20.h,
                                      //     width: 20.w,
                                      //     color: Colors.grey),

                                      Obx(
                                            () => CustomText(
                                            text: productDetailsController
                                                .childrenVariationModel1.value.data?[index].numOfItem.toString(),
                                            size: 18.sp,
                                            weight: FontWeight.w600),
                                      ),

                                      // increment button
                                      GestureDetector(
                                        onTap: () {
                                          productDetailsController
                                              .incrementDecrementQty(
                                            index: index,
                                            isIncrement: true
                                          );
                                        },
                                        /*{
                                                                                                if (productDetailsController
                                                                                                    .initialVariationModel
                                                                                                    .value
                                                                                                    .data !=
                                                                                                    null ||
                                                                                                    productDetailsController
                                                                                                        .initialVariationModel
                                                                                                        .value
                                                                                                        .data!
                                                                                                        .isNotEmpty) {
                                                                                                  if (productDetailsController
                                                                                                      .variationsStock
                                                                                                      .value <
                                                                                                      0) {
                                                                                                  } else {
                                                                                                    if (cartController
                                                                                                        .numOfItems.value <
                                                                                                        productDetailsController
                                                                                                            .variationsStock
                                                                                                            .value) {
                                                                                                      // maximum product quantity null
                                                                                                      if (productDetailsController
                                                                                                          .productModel
                                                                                                          .value
                                                                                                          .data!
                                                                                                          .maximumPurchaseQuantity ==
                                                                                                          null) {
                                                                                                        cartController
                                                                                                            .numOfItems.value++;
                                                                                                      } else {
                                                                                                        if (cartController
                                                                                                            .numOfItems
                                                                                                            .value <
                                                                                                            productDetailsController
                                                                                                                .productModel
                                                                                                                .value
                                                                                                                .data!
                                                                                                                .maximumPurchaseQuantity!) {
                                                                                                          cartController
                                                                                                              .numOfItems
                                                                                                              .value++;
                                                                                                        } else {
                                                                                                          customSnackbar(
                                                                                                              "INFO".tr,
                                                                                                              "MAXIMUM_PURCHASE_QUANTITY_LIMIT_EXCEEDED"
                                                                                                                  .tr,
                                                                                                              AppColor
                                                                                                                  .redColor);
                                                                                                        }
                                                                                                      }
                                                                                                    } else {}
                                                                                                  }
                                                                                                }

                                                                                                // initial variaiton null

                                                                                                if (productDetailsController
                                                                                                    .productModel
                                                                                                    .value
                                                                                                    .data!
                                                                                                    .stock! >
                                                                                                    0) {
                                                                                                  // If numOfitem is less than stock - Increment

                                                                                                  if (cartController
                                                                                                      .numOfItems.value <
                                                                                                      productDetailsController
                                                                                                          .productModel
                                                                                                          .value
                                                                                                          .data!
                                                                                                          .stock!) {
                                                                                                    // Maximum purchase quantity null
                                                                                                    if (productDetailsController
                                                                                                        .productModel
                                                                                                        .value
                                                                                                        .data!
                                                                                                        .maximumPurchaseQuantity ==
                                                                                                        null) {
                                                                                                      cartController
                                                                                                          .numOfItems.value++;
                                                                                                    } else {
                                                                                                      if (cartController
                                                                                                          .numOfItems
                                                                                                          .value <
                                                                                                          productDetailsController
                                                                                                              .productModel
                                                                                                              .value
                                                                                                              .data!
                                                                                                              .maximumPurchaseQuantity!) {
                                                                                                        cartController
                                                                                                            .numOfItems.value++;
                                                                                                      } else {
                                                                                                        customSnackbar(
                                                                                                            "INFO".tr,
                                                                                                            "MAXIMUM_PURCHASE_QUANTITY_LIMIT_EXCEEDED"
                                                                                                                .tr,
                                                                                                            AppColor.redColor);
                                                                                                      }
                                                                                                    }
                                                                                                  }
                                                                                                }
                                                                                              }*/
                                        child: true
                                            ? SvgPicture.asset(
                                            SvgIcon.increment,
                                            color: AppColor
                                                .primaryColor,
                                            height: 20.h,
                                            width: 20.w)
                                            : SvgPicture.asset(
                                            SvgIcon.increment,
                                            height: 20.h,
                                            width: 20.w,
                                            color: Colors.grey),
                                      ),

                                      // // Intial variation null
                                      //         productDetailsController
                                      //                         .initialVariationModel
                                      //                         .value
                                      //                         .data ==
                                      //                     null ||
                                      //                 productDetailsController
                                      //                     .initialVariationModel
                                      //                     .value
                                      //                     .data!
                                      //                     .isEmpty
                                      //             ? productDetailsController
                                      //                             .productModel
                                      //                             .value
                                      //                             .data!
                                      //                             .stock! >
                                      //                         1 &&
                                      //                     cartController
                                      //                             .numOfItems
                                      //                             .value <
                                      //                         productDetailsController
                                      //                             .productModel
                                      //                             .value
                                      //                             .data!
                                      //                             .stock!
                                      //                 ?
                                      //                 // Iccrement active
                                      //                 SvgPicture.asset(SvgIcon.increment,
                                      //                     color: AppColor
                                      //                         .primaryColor,
                                      //                     height: 20.h,
                                      //                     width: 20.w)
                                      //                 :
                                      //
                                      //                 // Increment inActive
                                      //                 SvgPicture.asset(
                                      //                     SvgIcon.increment,
                                      //                     height: 20.h,
                                      //                     width: 20.w,
                                      //                     color: Colors.grey)
                                      //             : productDetailsController.variationsStock.value != -1
                                      //                 ? cartController.numOfItems.value == productDetailsController.variationsStock.value || productDetailsController.variationsStock.value == 0
                                      //                     ? SvgPicture.asset(SvgIcon.increment, color: Colors.grey, height: 20.h, width: 20.w)
                                      //                     : SvgPicture.asset(SvgIcon.increment, color: AppColor.primaryColor, height: 20.h, width: 20.w)
                                      //                 : SvgPicture.asset(SvgIcon.increment, height: 20.h, width: 20.w, color: Colors.grey)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                  : SizedBox(),

              // manage height
              productDetailsController.childrenVariationModel1.value.data !=
                          null &&
                      productDetailsController
                          .childrenVariationModel1.value.data!.isNotEmpty
                  ? SizedBox(height: 24.h)
                  : SizedBox(),
            ],
          );
  }

  Widget patternList() {
    return productDetailsController.selectedIndex2.value == -1 &&
            productDetailsController.childrenVariationModel2.value.data == null
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              productDetailsController.childrenVariationModel2.value.data !=
                          null &&
                      productDetailsController
                          .childrenVariationModel2.value.data!.isNotEmpty
                  ? CustomText(
                      text:
                          '${productDetailsController.childrenVariationModel2.value.data?[0].productAttributeName.toString().tr ?? ''}:',
                      size: 14.sp,
                      weight: FontWeight.w600,
                    )
                  : SizedBox(),
              productDetailsController.childrenVariationModel2.value.data !=
                          null &&
                      productDetailsController
                          .childrenVariationModel2.value.data!.isNotEmpty
                  ? SizedBox(height: 8.h)
                  : SizedBox(),
              productDetailsController.childrenVariationModel2.value.data !=
                          null &&
                      productDetailsController
                          .childrenVariationModel2.value.data!.isNotEmpty
                  ? SizedBox(
                      height: 32.h,
                      child: ListView.builder(
                          itemCount: productDetailsController
                                  .childrenVariationModel2.value.data?.length ??
                              0,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                cartController.numOfItems.value = 1;
                                productDetailsController.selectedIndex3.value =
                                    index;

                                productDetailsController.selectedIndex4.value =
                                    -1;
                                productDetailsController.selectedIndex5.value =
                                    -1;
                                productDetailsController.selectedIndex6.value =
                                    -1;
                                productDetailsController.selectedIndex7.value =
                                    -1;

                                productDetailsController
                                    .childrenVariationModel3.value.data
                                    ?.clear();
                                productDetailsController
                                    .childrenVariationModel4.value.data
                                    ?.clear();
                                productDetailsController
                                    .childrenVariationModel5.value.data
                                    ?.clear();
                                productDetailsController
                                    .childrenVariationModel6.value.data
                                    ?.clear();

                                if (productDetailsController
                                        .childrenVariationModel2
                                        .value
                                        .data![index]
                                        .sku !=
                                    null) {
                                  productDetailsController.variationProductId
                                      .value = productDetailsController
                                          .childrenVariationModel2
                                          .value
                                          .data?[index]
                                          .id
                                          .toString() ??
                                      '';
                                  productDetailsController.variationProductPrice
                                      .value = productDetailsController
                                          .childrenVariationModel2
                                          .value
                                          .data?[index]
                                          .price
                                          .toString() ??
                                      '';
                                  productDetailsController
                                      .variationProductCurrencyPrice
                                      .value = productDetailsController
                                          .childrenVariationModel2
                                          .value
                                          .data?[index]
                                          .currencyPrice
                                          .toString() ??
                                      '';
                                  productDetailsController
                                      .variationProductOldPrice
                                      .value = productDetailsController
                                          .childrenVariationModel2
                                          .value
                                          .data?[index]
                                          .oldPrice
                                          .toString() ??
                                      '';
                                  productDetailsController
                                      .variationProductOldCurrencyPrice
                                      .value = productDetailsController
                                          .childrenVariationModel2
                                          .value
                                          .data?[index]
                                          .oldCurrencyPrice
                                          .toString() ??
                                      '';
                                  productDetailsController.variationsku.value =
                                      productDetailsController
                                              .childrenVariationModel2
                                              .value
                                              .data?[index]
                                              .sku
                                              .toString() ??
                                          '';
                                  productDetailsController.variationsStock
                                      .value = productDetailsController
                                          .childrenVariationModel2
                                          .value
                                          .data?[index]
                                          .stock!
                                          .toInt() ??
                                      0;
                                } else {
                                  productDetailsController
                                      .variationProductId.value = '';
                                  productDetailsController
                                      .variationProductPrice.value = '';
                                  productDetailsController
                                      .variationProductCurrencyPrice.value = '';
                                  productDetailsController
                                      .variationProductOldPrice.value = '';
                                  productDetailsController
                                      .variationProductOldCurrencyPrice
                                      .value = '';
                                  productDetailsController.variationsku.value =
                                      '';
                                  productDetailsController
                                      .variationsStock.value = -1;
                                }

                                if (productDetailsController
                                        .childrenVariationModel2
                                        .value
                                        .data![index]
                                        .sku ==
                                    null) {
                                  await productDetailsController
                                      .fetchChildrenVariation3(
                                          initialVariationId:
                                              productDetailsController
                                                  .childrenVariationModel2
                                                  .value
                                                  .data![index]
                                                  .id
                                                  .toString());
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: productDetailsController
                                                  .selectedIndex3.value ==
                                              index
                                          ? AppColor.primaryColor
                                          : AppColor.cartColor,
                                      borderRadius:
                                          BorderRadius.circular(50.r)),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 12.5.w, right: 12.5.w),
                                    child: Center(
                                      child: CustomText(
                                        text: productDetailsController
                                                .childrenVariationModel2
                                                .value
                                                .data?[index]
                                                .productAttributeOptionName ??
                                            '',
                                        color: productDetailsController
                                                    .selectedIndex3.value ==
                                                index
                                            ? Colors.white
                                            : Colors.black,
                                        size: 12.sp,
                                        weight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  : SizedBox(),
              productDetailsController.childrenVariationModel2.value.data !=
                          null &&
                      productDetailsController
                          .childrenVariationModel2.value.data!.isNotEmpty
                  ? SizedBox(height: 24.h)
                  : SizedBox(),
            ],
          );
  }
}
