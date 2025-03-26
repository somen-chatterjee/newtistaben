import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shopperz/app/modules/auth/controller/auth_controler.dart';
import 'package:shopperz/app/modules/auth/views/sign_in.dart';
import 'package:shopperz/app/modules/cart/controller/cart_controller.dart';
import 'package:shopperz/app/modules/category/controller/category_wise_product_controller.dart';
import 'package:shopperz/app/modules/category/model/category_wise_product.dart'
as category_product;
import 'package:shopperz/app/modules/home/model/product_section.dart'
as section_product;
import 'package:shopperz/app/modules/home/model/popular_product.dart'
as Product;
import 'package:shopperz/app/modules/navbar/controller/navbar_controller.dart';
import 'package:shopperz/app/modules/product/widgets/product.dart';
import 'package:shopperz/app/modules/product_details/controller/product_details_controller.dart';
import 'package:shopperz/app/modules/product_details/model/related_product.dart';
import 'package:shopperz/app/modules/product_details/views/variations.dart';
import 'package:shopperz/app/modules/promotion/model/promotion_wise_product.dart';
import 'package:shopperz/app/modules/search/model/all_product.dart';
import 'package:shopperz/app/modules/wishlist/controller/wishlist_controller.dart';
import 'package:shopperz/app/modules/wishlist/model/fav_model.dart';
import 'package:shopperz/main.dart';
import 'package:shopperz/widgets/custom_snackbar.dart';
import 'package:shopperz/widgets/custom_tabbar.dart';
import 'package:shopperz/widgets/devider.dart';
import 'package:shopperz/widgets/secondary_button.dart';
import 'package:shopperz/widgets/secondary_button_loader.dart';
import 'package:shopperz/widgets/shimmer/product_details_shimmer.dart';
import 'package:shopperz/widgets/textwidget.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/custom_text.dart';
import '../../../../widgets/custom_text_with_currency.dart';
import '../../../../widgets/secondary_appbar.dart';
import '../../search/views/search_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key,
    this.productModel,
    this.sectionModel,
    this.categoryWiseProduct,
    this.allProductModel,
    this.favoriteItem,
    this.relatedProduct,
    this.product,
    this.data,
    this.individualProduct});

  final category_product.Product? categoryWiseProduct;
  final section_product.Product? productModel;
  final section_product.Datum? sectionModel;
  final Datum? allProductModel;
  final FavoriteItem? favoriteItem;
  final RelatedProduct? relatedProduct;
  final Product.Datum? product;
  final Product.Datum? individualProduct;
  final PromotionProduct? data;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final navController = Get.put(NavbarController());
  final productDetailsController = Get.put(ProductDetailsController());
  final cartController = Get.put(CartController());
  final wishlistController = Get.put(WishlistController());
  final authController = Get.put(AuthController());
  final categoryWiseProductController =
  Get.put(CategoryWiseProductController());

  int quantity = 1;
  bool isClicked = false;
  int isSelected = 0;

  @override
  void initState() {
    cartController.numOfItems.value = 1;
    initialCallMethod();
    authController.getSetting();
    super.initState();
  }

  initialCallMethod() async {
    await productDetailsController.fetchProductDetails(
        slug: widget.productModel?.slug ??
            widget.categoryWiseProduct?.slug ??
            widget.allProductModel?.slug ??
            widget.favoriteItem?.slug ??
            widget.individualProduct?.slug ??
            widget.product?.slug ??
            widget.data?.slug ??
            "");
    await productDetailsController.fetchRelatedProduct(
        slug: widget.productModel?.slug ??
            widget.categoryWiseProduct?.slug ??
            widget.allProductModel?.slug ??
            widget.favoriteItem?.slug ??
            widget.product?.slug ??
            widget.individualProduct?.slug ??
            widget.data?.slug ??
            "");

    await productDetailsController.fetchInitialVariation(
        productId: widget.productModel?.id.toString() ??
            widget.categoryWiseProduct?.id.toString() ??
            widget.allProductModel?.id.toString() ??
            widget.favoriteItem?.id.toString() ??
            widget.individualProduct?.id.toString() ??
            widget.product?.id.toString() ??
            widget.data?.id.toString() ??
            "0");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productDetailsController.resetProductState();
    });
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productDetailsController.fetchProductDetails(
          slug: widget.productModel?.slug ??
              widget.categoryWiseProduct?.slug ??
              widget.allProductModel?.slug ??
              widget.favoriteItem?.slug ??
              widget.relatedProduct?.slug ??
              widget.product?.slug ??
              widget.individualProduct?.slug ??
              widget.data?.slug ??
              "");
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
      child: GetBuilder<ProductDetailsController>(
        builder: (productDetailsController) {
          return Scaffold(
            backgroundColor: AppColor.whiteColor,
            appBar: SecondaryAppBar(onTap: () {
              Get.to(() => const SearchScreen());
            }),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: RefreshIndicator(
                color: AppColor.primaryColor,
                onRefresh: () async {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    productDetailsController.fetchProductDetails(
                        slug: widget.productModel?.slug ??
                            widget.categoryWiseProduct?.slug ??
                            widget.allProductModel?.slug ??
                            widget.favoriteItem?.slug ??
                            widget.relatedProduct?.slug ??
                            widget.individualProduct?.slug ??
                            "");

                    productDetailsController.fetchRelatedProduct(
                        slug: widget.productModel?.slug ??
                            widget.categoryWiseProduct?.slug ??
                            widget.allProductModel?.slug ??
                            widget.favoriteItem?.slug ??
                            widget.product?.slug ??
                            widget.individualProduct?.slug ??
                            "");

                    productDetailsController.fetchInitialVariation(
                        productId: widget.productModel?.id.toString() ??
                            widget.categoryWiseProduct?.id.toString() ??
                            widget.allProductModel?.id.toString() ??
                            widget.favoriteItem?.id.toString() ??
                            widget.product?.id.toString() ??
                            widget.individualProduct?.id.toString() ??
                            "0");

                    productDetailsController.variationProductId.value = '';
                    productDetailsController.variationProductPrice.value = '';
                    productDetailsController
                        .variationProductCurrencyPrice.value = '';
                    productDetailsController.variationProductOldPrice.value =
                    '';
                    productDetailsController
                        .variationProductOldCurrencyPrice.value = '';
                    productDetailsController.variationsku.value = '';
                    productDetailsController.variationsStock.value = -1;
                  });
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Obx(
                        () =>
                    productDetailsController.isLaoding.value == 1
                        ? const ProductDetailsShimmer()
                        : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: isClicked
                                ? productDetailsController
                                .productModel
                                .value
                                .data
                                ?.images![isSelected] ??
                                ""
                                : productDetailsController
                                .productModel.value.data?.image ??
                                "",
                            imageBuilder: (context, imageProvider) =>
                                Container(
                                  height: 346.h,
                                  width: 328.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill),
                                  ),
                                ),
                          ),
                          SizedBox(height: 10.h),
                          productDetailsController.productModel.value
                              .data!.images!.isEmpty
                              ? const SizedBox()
                              : SizedBox(
                            height: 80.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: productDetailsController
                                  .productModel
                                  .value
                                  .data
                                  ?.images
                                  ?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isSelected = index;
                                      isClicked = true;
                                    });
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl:
                                    productDetailsController
                                        .productModel
                                        .value
                                        .data!
                                        .images![index],
                                    imageBuilder:
                                        (context, imageProvider) =>
                                        Container(
                                          margin: EdgeInsets.only(
                                              right: 8.w),
                                          height: 76.h,
                                          width: 76.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(
                                                8.r),
                                            border: Border.all(
                                                color: isSelected ==
                                                    index
                                                    ? Colors.black
                                                    : Colors
                                                    .transparent,
                                                width: 2),
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                    errorWidget:
                                        (context, url, error) =>
                                        SizedBox(),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Column(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                textAlign: TextAlign.left,
                                text: productDetailsController
                                    .productModel.value.data!.name,
                                size: 22.sp,
                                weight: FontWeight.w700,
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Obx(() {
                                    if (productDetailsController
                                        .initialVariationModel
                                        .value
                                        .data !=
                                        null) {
                                      return CustomTextWithCurrency(
                                        text:
                                        productDetailsController
                                            .variationProductCurrencyPrice
                                            .toString() ==
                                            ''
                                            ? productDetailsController
                                            .productModel
                                            .value
                                            .data
                                            ?.currencyPrice
                                            .toString() ??
                                            ''
                                            : productDetailsController
                                            .variationProductCurrencyPrice
                                            .toString(),
                                        size: 18.sp,
                                        weight: FontWeight.w700,
                                      );
                                    }
                                    return const SizedBox();
                                  }),
                                  SizedBox(width: 16.w),
                                  Obx(() {
                                    if (productDetailsController
                                        .initialVariationModel
                                        .value
                                        .data !=
                                        null &&
                                        productDetailsController
                                            .productModel
                                            .value
                                            .data!
                                            .isOffer ==
                                            true) {
                                      return CustomTextWithCurrency(
                                        text: productDetailsController
                                            .variationProductOldCurrencyPrice
                                            .toString() ==
                                            ''
                                            ? productDetailsController
                                            .productModel
                                            .value
                                            .data
                                            ?.oldCurrencyPrice
                                            .toString()
                                            : productDetailsController
                                            .variationProductOldCurrencyPrice
                                            .toString(),
                                        textDecoration:
                                        TextDecoration.lineThrough,
                                        color: AppColor.primaryColor,
                                        size: 14.sp,
                                        weight: FontWeight.w700,
                                      );
                                    }

                                    return const SizedBox();
                                  })
                                ],
                              ),
                              SizedBox(height: 8.h),
                              // Row(
                              //   children: [
                              //     RatingBarIndicator(
                              //       rating: double.parse(
                              //           '${productDetailsController.productModel.value.data!.ratingStar.toString() == 'null' ? '0' : double.parse(productDetailsController.productModel.value.data!.ratingStar.toString()) / productDetailsController.productModel.value.data!.ratingStarCount!.toInt()}'),
                              //       itemSize: 11.h,
                              //       unratedColor: AppColor.inactiveColor,
                              //       itemBuilder: (context, index) =>
                              //           Container(
                              //         margin: EdgeInsets.symmetric(
                              //             horizontal: 1.w),
                              //         child: SvgPicture.asset(
                              //           SvgIcon.star,
                              //           colorFilter:
                              //               const ColorFilter.mode(
                              //                   AppColor.yellowColor,
                              //                   BlendMode.srcIn),
                              //         ),
                              //       ),
                              //     ),
                              //     SizedBox(width: 8.w),
                              //     SizedBox(
                              //       child: Row(
                              //         children: [
                              //           CustomText(
                              //               text:
                              //                   '${productDetailsController.productModel.value.data!.ratingStar.toString() == 'null' ? '0' : double.parse(productDetailsController.productModel.value.data!.ratingStar.toString()) / productDetailsController.productModel.value.data!.ratingStarCount!.toInt()}'),
                              //           SizedBox(
                              //             width: 5.w,
                              //           ),
                              //           CustomText(
                              //               text:
                              //                   "(${productDetailsController.productModel.value.data!.ratingStarCount} ${' Reviews'.tr})")
                              //         ],
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              CustomText(
                                text: productDetailsController
                                    .productModel.value.data!.sku
                                    .toString(),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Divider(
                            height: 1.h,
                            color: const Color(0xFFEFF0F6),
                          ),
                          SizedBox(height: 15.h),
                          Variations(),

                          /*new Ui for bulk order*/

                          // Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       CustomText(
                          //         text: "AVAILABLE SIZE (5)",
                          //         size: 14.sp,
                          //         weight: FontWeight.w700,
                          //         color: Colors.grey,
                          //       ),
                          //       SizedBox(height: 10.sp),
                          //       Column(
                          //         children: [
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               Column(
                          //                 crossAxisAlignment: CrossAxisAlignment.start,
                          //                 children: [
                          //                   CustomText(
                          //                     text: "S",
                          //                     size: 16.sp,
                          //                     weight: FontWeight.w700,
                          //                   ),
                          //                   CustomText(
                          //                     text: "₹3099",
                          //                     size: 14.sp,
                          //                   ),
                          //                 ],
                          //               ),
                          //               Container(
                          //                 width: 99.w,
                          //                 height: 36.h,
                          //                 decoration: BoxDecoration(
                          //                   borderRadius:
                          //                   BorderRadius.circular(20.r),
                          //                   color: AppColor.cartColor,
                          //                 ),
                          //                 child: Row(
                          //                   mainAxisAlignment:
                          //                   MainAxisAlignment.spaceAround,
                          //                   children: [
                          //                     GestureDetector(
                          //                         onTap: () {}
                          //                         /*{
                          //                           // Variation is not empty
                          //                           if (productDetailsController
                          //                               .initialVariationModel
                          //                               .value
                          //                               .data!
                          //                               .isNotEmpty ||
                          //                               productDetailsController
                          //                                   .initialVariationModel
                          //                                   .value
                          //                                   .data!.isNotEmpty) {
                          //                             if (productDetailsController
                          //                                 .variationsStock
                          //                                 .value <
                          //                                 0) {
                          //                             } else {
                          //                               if (cartController
                          //                                   .numOfItems.value >
                          //                                   1) {
                          //                                 cartController
                          //                                     .numOfItems.value--;
                          //                               } else {}
                          //                             }
                          //                           }
                          //                           // Initial Variation null
                          //                           else {
                          //                             if (productDetailsController
                          //                                 .productModel
                          //                                 .value
                          //                                 .data!
                          //                                 .stock! >
                          //                                 1 &&
                          //                                 cartController.numOfItems
                          //                                     .value >
                          //                                     1) {
                          //                               cartController
                          //                                   .numOfItems.value--;
                          //                             } else {}
                          //                           }
                          //                         }*/,
                          //                         child:
                          //
                          //                         // Intial variation null
                          //                         productDetailsController
                          //                             .initialVariationModel
                          //                             .value
                          //                             .data ==
                          //                             null ||
                          //                             productDetailsController
                          //                                 .initialVariationModel
                          //                                 .value
                          //                                 .data!
                          //                                 .isEmpty
                          //                             ? productDetailsController
                          //                             .productModel
                          //                             .value
                          //                             .data!
                          //                             .stock! >
                          //                             1 &&
                          //                             cartController
                          //                                 .numOfItems
                          //                                 .value >
                          //                                 1
                          //                             ?
                          //                         // decrement active
                          //                         SvgPicture.asset(SvgIcon.decrement,
                          //                             color:
                          //                             Colors.black,
                          //                             height: 20.h,
                          //                             width: 20.w)
                          //                             :
                          //
                          //                         // decrement inActive
                          //                         SvgPicture.asset(
                          //                             SvgIcon.decrement,
                          //                             color: Colors.grey,
                          //                             height: 20.h,
                          //                             width: 20.w)
                          //                             :
                          //
                          //                         // Intial variation Not null
                          //
                          //                         productDetailsController.variationsStock.value != -1
                          //                             ? cartController.numOfItems.value == 1 || productDetailsController.variationsStock.value == 1
                          //                             ? SvgPicture.asset(SvgIcon.decrement, color: Colors.grey, height: 20.h, width: 20.w)
                          //                             : SvgPicture.asset(SvgIcon.decrement, height: 20.h, width: 20.w)
                          //                             : SvgPicture.asset(SvgIcon.decrement, height: 20.h, width: 20.w, color: Colors.grey)),
                          //                     Obx(
                          //                           () => CustomText(
                          //                           text: cartController
                          //                               .numOfItems.value
                          //                               .toString(),
                          //                           size: 18.sp,
                          //                           weight: FontWeight.w600),
                          //                     ),
                          //                     GestureDetector(
                          //                         onTap: () {}
                          //                         /*{
                          //                           if (productDetailsController
                          //                               .initialVariationModel
                          //                               .value
                          //                               .data !=
                          //                               null ||
                          //                               productDetailsController
                          //                                   .initialVariationModel
                          //                                   .value
                          //                                   .data!
                          //                                   .isNotEmpty) {
                          //                             if (productDetailsController
                          //                                 .variationsStock
                          //                                 .value <
                          //                                 0) {
                          //                             } else {
                          //                               if (cartController
                          //                                   .numOfItems.value <
                          //                                   productDetailsController
                          //                                       .variationsStock
                          //                                       .value) {
                          //                                 // maximum product quantity null
                          //                                 if (productDetailsController
                          //                                     .productModel
                          //                                     .value
                          //                                     .data!
                          //                                     .maximumPurchaseQuantity ==
                          //                                     null) {
                          //                                   cartController
                          //                                       .numOfItems.value++;
                          //                                 } else {
                          //                                   if (cartController
                          //                                       .numOfItems
                          //                                       .value <
                          //                                       productDetailsController
                          //                                           .productModel
                          //                                           .value
                          //                                           .data!
                          //                                           .maximumPurchaseQuantity!) {
                          //                                     cartController
                          //                                         .numOfItems
                          //                                         .value++;
                          //                                   } else {
                          //                                     customSnackbar(
                          //                                         "INFO".tr,
                          //                                         "MAXIMUM_PURCHASE_QUANTITY_LIMIT_EXCEEDED"
                          //                                             .tr,
                          //                                         AppColor
                          //                                             .redColor);
                          //                                   }
                          //                                 }
                          //                               } else {}
                          //                             }
                          //                           }
                          //
                          //                           // initial variaiton null
                          //
                          //                           if (productDetailsController
                          //                               .productModel
                          //                               .value
                          //                               .data!
                          //                               .stock! >
                          //                               0) {
                          //                             // If numOfitem is less than stock - Increment
                          //
                          //                             if (cartController
                          //                                 .numOfItems.value <
                          //                                 productDetailsController
                          //                                     .productModel
                          //                                     .value
                          //                                     .data!
                          //                                     .stock!) {
                          //                               // Maximum purchase quantity null
                          //                               if (productDetailsController
                          //                                   .productModel
                          //                                   .value
                          //                                   .data!
                          //                                   .maximumPurchaseQuantity ==
                          //                                   null) {
                          //                                 cartController
                          //                                     .numOfItems.value++;
                          //                               } else {
                          //                                 if (cartController
                          //                                     .numOfItems
                          //                                     .value <
                          //                                     productDetailsController
                          //                                         .productModel
                          //                                         .value
                          //                                         .data!
                          //                                         .maximumPurchaseQuantity!) {
                          //                                   cartController
                          //                                       .numOfItems.value++;
                          //                                 } else {
                          //                                   customSnackbar(
                          //                                       "INFO".tr,
                          //                                       "MAXIMUM_PURCHASE_QUANTITY_LIMIT_EXCEEDED"
                          //                                           .tr,
                          //                                       AppColor.redColor);
                          //                                 }
                          //                               }
                          //                             }
                          //                           }
                          //                         }*/,
                          //                         child:
                          //
                          //                         // Intial variation null
                          //                         productDetailsController.initialVariationModel.value.data == null ||
                          //                             productDetailsController
                          //                                 .initialVariationModel
                          //                                 .value
                          //                                 .data!
                          //                                 .isEmpty
                          //                             ? productDetailsController
                          //                             .productModel
                          //                             .value
                          //                             .data!
                          //                             .stock! >
                          //                             1 &&
                          //                             cartController
                          //                                 .numOfItems
                          //                                 .value <
                          //                                 productDetailsController
                          //                                     .productModel
                          //                                     .value
                          //                                     .data!
                          //                                     .stock!
                          //                             ?
                          //                         // Iccrement active
                          //                         SvgPicture.asset(SvgIcon.increment,
                          //                             color: AppColor
                          //                                 .primaryColor,
                          //                             height: 20.h,
                          //                             width: 20.w)
                          //                             :
                          //
                          //                         // Increment inActive
                          //                         SvgPicture.asset(
                          //                             SvgIcon.increment,
                          //                             height: 20.h,
                          //                             width: 20.w,
                          //                             color: Colors.grey)
                          //                             : productDetailsController.variationsStock.value != -1
                          //                             ? cartController.numOfItems.value == productDetailsController.variationsStock.value || productDetailsController.variationsStock.value == 0
                          //                             ? SvgPicture.asset(SvgIcon.increment, color: Colors.grey, height: 20.h, width: 20.w)
                          //                             : SvgPicture.asset(SvgIcon.increment, color: AppColor.primaryColor, height: 20.h, width: 20.w)
                          //                             : SvgPicture.asset(SvgIcon.increment, height: 20.h, width: 20.w, color: Colors.grey))
                          //                   ],
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //           Divider(height: 16.sp),
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               Column(
                          //                 crossAxisAlignment: CrossAxisAlignment.start,
                          //                 children: [
                          //                   CustomText(
                          //                     text: "M",
                          //                     size: 16.sp,
                          //                     weight: FontWeight.w700,
                          //                   ),
                          //                   CustomText(
                          //                     text: "₹3099",
                          //                     size: 14.sp,
                          //                   ),
                          //                 ],
                          //               ),
                          //               Container(
                          //                 width: 99.w,
                          //                 height: 36.h,
                          //                 decoration: BoxDecoration(
                          //                   borderRadius:
                          //                   BorderRadius.circular(20.r),
                          //                   color: AppColor.cartColor,
                          //                 ),
                          //                 child: Row(
                          //                   mainAxisAlignment:
                          //                   MainAxisAlignment.spaceAround,
                          //                   children: [
                          //                     GestureDetector(
                          //                         onTap: () {},
                          //                         child:
                          //
                          //                         // Intial variation null
                          //                         productDetailsController
                          //                             .initialVariationModel
                          //                             .value
                          //                             .data ==
                          //                             null ||
                          //                             productDetailsController
                          //                                 .initialVariationModel
                          //                                 .value
                          //                                 .data!
                          //                                 .isEmpty
                          //                             ? productDetailsController
                          //                             .productModel
                          //                             .value
                          //                             .data!
                          //                             .stock! >
                          //                             1 &&
                          //                             cartController
                          //                                 .numOfItems
                          //                                 .value >
                          //                                 1
                          //                             ?
                          //                         // decrement active
                          //                         SvgPicture.asset(SvgIcon.decrement,
                          //                             color:
                          //                             Colors.black,
                          //                             height: 20.h,
                          //                             width: 20.w)
                          //                             :
                          //
                          //                         // decrement inActive
                          //                         SvgPicture.asset(
                          //                             SvgIcon.decrement,
                          //                             color: Colors.grey,
                          //                             height: 20.h,
                          //                             width: 20.w)
                          //                             :
                          //
                          //                         // Intial variation Not null
                          //
                          //                         productDetailsController.variationsStock.value != -1
                          //                             ? cartController.numOfItems.value == 1 || productDetailsController.variationsStock.value == 1
                          //                             ? SvgPicture.asset(SvgIcon.decrement, color: Colors.grey, height: 20.h, width: 20.w)
                          //                             : SvgPicture.asset(SvgIcon.decrement, height: 20.h, width: 20.w)
                          //                             : SvgPicture.asset(SvgIcon.decrement, height: 20.h, width: 20.w, color: Colors.grey)),
                          //                     Obx(
                          //                           () => CustomText(
                          //                           text: cartController
                          //                               .numOfItems.value
                          //                               .toString(),
                          //                           size: 18.sp,
                          //                           weight: FontWeight.w600),
                          //                     ),
                          //                     GestureDetector(
                          //                         onTap: () {},
                          //                         child:
                          //
                          //                         // Intial variation null
                          //                         productDetailsController.initialVariationModel.value.data == null ||
                          //                             productDetailsController
                          //                                 .initialVariationModel
                          //                                 .value
                          //                                 .data!
                          //                                 .isEmpty
                          //                             ? productDetailsController
                          //                             .productModel
                          //                             .value
                          //                             .data!
                          //                             .stock! >
                          //                             1 &&
                          //                             cartController
                          //                                 .numOfItems
                          //                                 .value <
                          //                                 productDetailsController
                          //                                     .productModel
                          //                                     .value
                          //                                     .data!
                          //                                     .stock!
                          //                             ?
                          //                         // Iccrement active
                          //                         SvgPicture.asset(SvgIcon.increment,
                          //                             color: AppColor
                          //                                 .primaryColor,
                          //                             height: 20.h,
                          //                             width: 20.w)
                          //                             :
                          //
                          //                         // Increment inActive
                          //                         SvgPicture.asset(
                          //                             SvgIcon.increment,
                          //                             height: 20.h,
                          //                             width: 20.w,
                          //                             color: Colors.grey)
                          //                             : productDetailsController.variationsStock.value != -1
                          //                             ? cartController.numOfItems.value == productDetailsController.variationsStock.value || productDetailsController.variationsStock.value == 0
                          //                             ? SvgPicture.asset(SvgIcon.increment, color: Colors.grey, height: 20.h, width: 20.w)
                          //                             : SvgPicture.asset(SvgIcon.increment, color: AppColor.primaryColor, height: 20.h, width: 20.w)
                          //                             : SvgPicture.asset(SvgIcon.increment, height: 20.h, width: 20.w, color: Colors.grey))
                          //                   ],
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //           Divider(height: 16.sp),
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               Column(
                          //                 crossAxisAlignment: CrossAxisAlignment.start,
                          //                 children: [
                          //                   CustomText(
                          //                     text: "L",
                          //                     size: 16.sp,
                          //                     weight: FontWeight.w700,
                          //                   ),
                          //                   CustomText(
                          //                     text: "₹3099",
                          //                     size: 14.sp,
                          //                   ),
                          //                 ],
                          //               ),
                          //               Container(
                          //                 width: 99.w,
                          //                 height: 36.h,
                          //                 decoration: BoxDecoration(
                          //                   borderRadius:
                          //                   BorderRadius.circular(20.r),
                          //                   color: AppColor.cartColor,
                          //                 ),
                          //                 child: Row(
                          //                   mainAxisAlignment:
                          //                   MainAxisAlignment.spaceAround,
                          //                   children: [
                          //                     GestureDetector(
                          //                         onTap: () {},
                          //                         child:
                          //
                          //                         // Intial variation null
                          //                         productDetailsController
                          //                             .initialVariationModel
                          //                             .value
                          //                             .data ==
                          //                             null ||
                          //                             productDetailsController
                          //                                 .initialVariationModel
                          //                                 .value
                          //                                 .data!
                          //                                 .isEmpty
                          //                             ? productDetailsController
                          //                             .productModel
                          //                             .value
                          //                             .data!
                          //                             .stock! >
                          //                             1 &&
                          //                             cartController
                          //                                 .numOfItems
                          //                                 .value >
                          //                                 1
                          //                             ?
                          //                         // decrement active
                          //                         SvgPicture.asset(SvgIcon.decrement,
                          //                             color:
                          //                             Colors.black,
                          //                             height: 20.h,
                          //                             width: 20.w)
                          //                             :
                          //
                          //                         // decrement inActive
                          //                         SvgPicture.asset(
                          //                             SvgIcon.decrement,
                          //                             color: Colors.grey,
                          //                             height: 20.h,
                          //                             width: 20.w)
                          //                             :
                          //
                          //                         // Intial variation Not null
                          //
                          //                         productDetailsController.variationsStock.value != -1
                          //                             ? cartController.numOfItems.value == 1 || productDetailsController.variationsStock.value == 1
                          //                             ? SvgPicture.asset(SvgIcon.decrement, color: Colors.grey, height: 20.h, width: 20.w)
                          //                             : SvgPicture.asset(SvgIcon.decrement, height: 20.h, width: 20.w)
                          //                             : SvgPicture.asset(SvgIcon.decrement, height: 20.h, width: 20.w, color: Colors.grey)),
                          //                     Obx(
                          //                           () => CustomText(
                          //                           text: cartController
                          //                               .numOfItems.value
                          //                               .toString(),
                          //                           size: 18.sp,
                          //                           weight: FontWeight.w600),
                          //                     ),
                          //                     GestureDetector(
                          //                         onTap: () {},
                          //                         child:
                          //
                          //                         // Intial variation null
                          //                         productDetailsController.initialVariationModel.value.data == null ||
                          //                             productDetailsController
                          //                                 .initialVariationModel
                          //                                 .value
                          //                                 .data!
                          //                                 .isEmpty
                          //                             ? productDetailsController
                          //                             .productModel
                          //                             .value
                          //                             .data!
                          //                             .stock! >
                          //                             1 &&
                          //                             cartController
                          //                                 .numOfItems
                          //                                 .value <
                          //                                 productDetailsController
                          //                                     .productModel
                          //                                     .value
                          //                                     .data!
                          //                                     .stock!
                          //                             ?
                          //                         // Iccrement active
                          //                         SvgPicture.asset(SvgIcon.increment,
                          //                             color: AppColor
                          //                                 .primaryColor,
                          //                             height: 20.h,
                          //                             width: 20.w)
                          //                             :
                          //
                          //                         // Increment inActive
                          //                         SvgPicture.asset(
                          //                             SvgIcon.increment,
                          //                             height: 20.h,
                          //                             width: 20.w,
                          //                             color: Colors.grey)
                          //                             : productDetailsController.variationsStock.value != -1
                          //                             ? cartController.numOfItems.value == productDetailsController.variationsStock.value || productDetailsController.variationsStock.value == 0
                          //                             ? SvgPicture.asset(SvgIcon.increment, color: Colors.grey, height: 20.h, width: 20.w)
                          //                             : SvgPicture.asset(SvgIcon.increment, color: AppColor.primaryColor, height: 20.h, width: 20.w)
                          //                             : SvgPicture.asset(SvgIcon.increment, height: 20.h, width: 20.w, color: Colors.grey))
                          //                   ],
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //           Divider(height: 16.sp),
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               Column(
                          //                 crossAxisAlignment: CrossAxisAlignment.start,
                          //                 children: [
                          //                   CustomText(
                          //                     text: "XL",
                          //                     size: 16.sp,
                          //                     weight: FontWeight.w700,
                          //                   ),
                          //                   CustomText(
                          //                     text: "₹3099",
                          //                     size: 14.sp,
                          //                   ),
                          //                 ],
                          //               ),
                          //               Container(
                          //                 width: 99.w,
                          //                 height: 36.h,
                          //                 decoration: BoxDecoration(
                          //                   borderRadius:
                          //                   BorderRadius.circular(20.r),
                          //                   color: AppColor.cartColor,
                          //                 ),
                          //                 child: Row(
                          //                   mainAxisAlignment:
                          //                   MainAxisAlignment.spaceAround,
                          //                   children: [
                          //                     GestureDetector(
                          //                         onTap: () {},
                          //                         child:
                          //
                          //                         // Intial variation null
                          //                         productDetailsController
                          //                             .initialVariationModel
                          //                             .value
                          //                             .data ==
                          //                             null ||
                          //                             productDetailsController
                          //                                 .initialVariationModel
                          //                                 .value
                          //                                 .data!
                          //                                 .isEmpty
                          //                             ? productDetailsController
                          //                             .productModel
                          //                             .value
                          //                             .data!
                          //                             .stock! >
                          //                             1 &&
                          //                             cartController
                          //                                 .numOfItems
                          //                                 .value >
                          //                                 1
                          //                             ?
                          //                         // decrement active
                          //                         SvgPicture.asset(SvgIcon.decrement,
                          //                             color:
                          //                             Colors.black,
                          //                             height: 20.h,
                          //                             width: 20.w)
                          //                             :
                          //
                          //                         // decrement inActive
                          //                         SvgPicture.asset(
                          //                             SvgIcon.decrement,
                          //                             color: Colors.grey,
                          //                             height: 20.h,
                          //                             width: 20.w)
                          //                             :
                          //
                          //                         // Intial variation Not null
                          //
                          //                         productDetailsController.variationsStock.value != -1
                          //                             ? cartController.numOfItems.value == 1 || productDetailsController.variationsStock.value == 1
                          //                             ? SvgPicture.asset(SvgIcon.decrement, color: Colors.grey, height: 20.h, width: 20.w)
                          //                             : SvgPicture.asset(SvgIcon.decrement, height: 20.h, width: 20.w)
                          //                             : SvgPicture.asset(SvgIcon.decrement, height: 20.h, width: 20.w, color: Colors.grey)),
                          //                     Obx(
                          //                           () => CustomText(
                          //                           text: cartController
                          //                               .numOfItems.value
                          //                               .toString(),
                          //                           size: 18.sp,
                          //                           weight: FontWeight.w600),
                          //                     ),
                          //                     GestureDetector(
                          //                         onTap: () {},
                          //                         child:
                          //
                          //                         // Intial variation null
                          //                         productDetailsController.initialVariationModel.value.data == null ||
                          //                             productDetailsController
                          //                                 .initialVariationModel
                          //                                 .value
                          //                                 .data!
                          //                                 .isEmpty
                          //                             ? productDetailsController
                          //                             .productModel
                          //                             .value
                          //                             .data!
                          //                             .stock! >
                          //                             1 &&
                          //                             cartController
                          //                                 .numOfItems
                          //                                 .value <
                          //                                 productDetailsController
                          //                                     .productModel
                          //                                     .value
                          //                                     .data!
                          //                                     .stock!
                          //                             ?
                          //                         // Iccrement active
                          //                         SvgPicture.asset(SvgIcon.increment,
                          //                             color: AppColor
                          //                                 .primaryColor,
                          //                             height: 20.h,
                          //                             width: 20.w)
                          //                             :
                          //
                          //                         // Increment inActive
                          //                         SvgPicture.asset(
                          //                             SvgIcon.increment,
                          //                             height: 20.h,
                          //                             width: 20.w,
                          //                             color: Colors.grey)
                          //                             : productDetailsController.variationsStock.value != -1
                          //                             ? cartController.numOfItems.value == productDetailsController.variationsStock.value || productDetailsController.variationsStock.value == 0
                          //                             ? SvgPicture.asset(SvgIcon.increment, color: Colors.grey, height: 20.h, width: 20.w)
                          //                             : SvgPicture.asset(SvgIcon.increment, color: AppColor.primaryColor, height: 20.h, width: 20.w)
                          //                             : SvgPicture.asset(SvgIcon.increment, height: 20.h, width: 20.w, color: Colors.grey))
                          //                   ],
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //           Divider(height: 16.sp),
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               Column(
                          //                 crossAxisAlignment: CrossAxisAlignment.start,
                          //                 children: [
                          //                   CustomText(
                          //                     text: "XXL",
                          //                     size: 16.sp,
                          //                     weight: FontWeight.w700,
                          //                   ),
                          //                   CustomText(
                          //                     text: "₹3099",
                          //                     size: 14.sp,
                          //                   ),
                          //                 ],
                          //               ),
                          //               Container(
                          //                 width: 99.w,
                          //                 height: 36.h,
                          //                 decoration: BoxDecoration(
                          //                   borderRadius:
                          //                   BorderRadius.circular(20.r),
                          //                   color: AppColor.cartColor,
                          //                 ),
                          //                 child: Row(
                          //                   mainAxisAlignment:
                          //                   MainAxisAlignment.spaceAround,
                          //                   children: [
                          //                     GestureDetector(
                          //                         onTap: () {},
                          //                         child:
                          //
                          //                         // Intial variation null
                          //                         productDetailsController
                          //                             .initialVariationModel
                          //                             .value
                          //                             .data ==
                          //                             null ||
                          //                             productDetailsController
                          //                                 .initialVariationModel
                          //                                 .value
                          //                                 .data!
                          //                                 .isEmpty
                          //                             ? productDetailsController
                          //                             .productModel
                          //                             .value
                          //                             .data!
                          //                             .stock! >
                          //                             1 &&
                          //                             cartController
                          //                                 .numOfItems
                          //                                 .value >
                          //                                 1
                          //                             ?
                          //                         // decrement active
                          //                         SvgPicture.asset(SvgIcon.decrement,
                          //                             color:
                          //                             Colors.black,
                          //                             height: 20.h,
                          //                             width: 20.w)
                          //                             :
                          //
                          //                         // decrement inActive
                          //                         SvgPicture.asset(
                          //                             SvgIcon.decrement,
                          //                             color: Colors.grey,
                          //                             height: 20.h,
                          //                             width: 20.w)
                          //                             :
                          //
                          //                         // Intial variation Not null
                          //
                          //                         productDetailsController.variationsStock.value != -1
                          //                             ? cartController.numOfItems.value == 1 || productDetailsController.variationsStock.value == 1
                          //                             ? SvgPicture.asset(SvgIcon.decrement, color: Colors.grey, height: 20.h, width: 20.w)
                          //                             : SvgPicture.asset(SvgIcon.decrement, height: 20.h, width: 20.w)
                          //                             : SvgPicture.asset(SvgIcon.decrement, height: 20.h, width: 20.w, color: Colors.grey)),
                          //                     Obx(
                          //                           () => CustomText(
                          //                           text: cartController
                          //                               .numOfItems.value
                          //                               .toString(),
                          //                           size: 18.sp,
                          //                           weight: FontWeight.w600),
                          //                     ),
                          //                     GestureDetector(
                          //                         onTap: () {},
                          //                         child:
                          //
                          //                         // Intial variation null
                          //                         productDetailsController.initialVariationModel.value.data == null ||
                          //                             productDetailsController
                          //                                 .initialVariationModel
                          //                                 .value
                          //                                 .data!
                          //                                 .isEmpty
                          //                             ? productDetailsController
                          //                             .productModel
                          //                             .value
                          //                             .data!
                          //                             .stock! >
                          //                             1 &&
                          //                             cartController
                          //                                 .numOfItems
                          //                                 .value <
                          //                                 productDetailsController
                          //                                     .productModel
                          //                                     .value
                          //                                     .data!
                          //                                     .stock!
                          //                             ?
                          //                         // Iccrement active
                          //                         SvgPicture.asset(SvgIcon.increment,
                          //                             color: AppColor
                          //                                 .primaryColor,
                          //                             height: 20.h,
                          //                             width: 20.w)
                          //                             :
                          //
                          //                         // Increment inActive
                          //                         SvgPicture.asset(
                          //                             SvgIcon.increment,
                          //                             height: 20.h,
                          //                             width: 20.w,
                          //                             color: Colors.grey)
                          //                             : productDetailsController.variationsStock.value != -1
                          //                             ? cartController.numOfItems.value == productDetailsController.variationsStock.value || productDetailsController.variationsStock.value == 0
                          //                             ? SvgPicture.asset(SvgIcon.increment, color: Colors.grey, height: 20.h, width: 20.w)
                          //                             : SvgPicture.asset(SvgIcon.increment, color: AppColor.primaryColor, height: 20.h, width: 20.w)
                          //                             : SvgPicture.asset(SvgIcon.increment, height: 20.h, width: 20.w, color: Colors.grey))
                          //                   ],
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),

                          /*old UI for select quantity*/

                          if ((productDetailsController
                              .initialVariationModel.value.data ??
                              [])
                              .isEmpty)
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: "QUANTITY".tr,
                                  size: 14.sp,
                                  weight: FontWeight.w600,
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
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
                                          GestureDetector(
                                              onTap: () {
                                                // Variation is not empty
                                                if (productDetailsController
                                                    .initialVariationModel
                                                    .value
                                                    .data!
                                                    .isNotEmpty ||
                                                    productDetailsController
                                                        .initialVariationModel
                                                        .value
                                                        .data!
                                                        .isNotEmpty) {
                                                  if (productDetailsController
                                                      .variationsStock
                                                      .value <
                                                      0) {} else {
                                                    if (cartController
                                                        .numOfItems
                                                        .value >
                                                        1) {
                                                      cartController
                                                          .numOfItems
                                                          .value--;
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
                                                      cartController
                                                          .numOfItems
                                                          .value >
                                                          1) {
                                                    cartController
                                                        .numOfItems
                                                        .value--;
                                                  } else {}
                                                }
                                              },
                                              child:

                                              // Intial variation null
                                              productDetailsController
                                                  .initialVariationModel
                                                  .value
                                                  .data ==
                                                  null ||
                                                  productDetailsController
                                                      .initialVariationModel
                                                      .value
                                                      .data!
                                                      .isEmpty
                                                  ? productDetailsController
                                                  .productModel
                                                  .value
                                                  .data!
                                                  .stock! >
                                                  1 &&
                                                  cartController.numOfItems
                                                      .value >
                                                      1
                                                  ?
                                              // decrement active
                                              SvgPicture.asset(
                                                  SvgIcon
                                                      .decrement,
                                                  color: Colors
                                                      .black,
                                                  height:
                                                  20.h,
                                                  width: 20.w)
                                                  :

                                              // decrement inActive
                                              SvgPicture.asset(
                                                  SvgIcon.decrement,
                                                  color: Colors.grey,
                                                  height: 20.h,
                                                  width: 20.w)
                                                  :

                                              // Intial variation Not null

                                              productDetailsController
                                                  .variationsStock.value != -1
                                                  ? cartController.numOfItems
                                                  .value == 1 ||
                                                  productDetailsController
                                                      .variationsStock.value ==
                                                      1
                                                  ? SvgPicture.asset(
                                                  SvgIcon.decrement,
                                                  color: Colors.grey,
                                                  height: 20.h,
                                                  width: 20.w)
                                                  : SvgPicture.asset(
                                                  SvgIcon.decrement,
                                                  height: 20.h, width: 20.w)
                                                  : SvgPicture.asset(
                                                  SvgIcon.decrement,
                                                  height: 20.h,
                                                  width: 20.w,
                                                  color: Colors.grey)),
                                          Obx(
                                                () =>
                                                CustomText(
                                                    text: cartController
                                                        .numOfItems.value
                                                        .toString(),
                                                    size: 18.sp,
                                                    weight: FontWeight.w600),
                                          ),
                                          GestureDetector(
                                              onTap: () {
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
                                                      0) {} else {
                                                    if (cartController
                                                        .numOfItems
                                                        .value <
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
                                                            .numOfItems
                                                            .value++;
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
                                                      .numOfItems
                                                      .value <
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
                                                          .numOfItems
                                                          .value++;
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
                                                  }
                                                }
                                              },
                                              child:

                                              // Intial variation null
                                              productDetailsController
                                                  .initialVariationModel
                                                  .value
                                                  .data ==
                                                  null ||
                                                  productDetailsController
                                                      .initialVariationModel
                                                      .value
                                                      .data!
                                                      .isEmpty
                                                  ? productDetailsController
                                                  .productModel
                                                  .value
                                                  .data!
                                                  .stock! >
                                                  1 &&
                                                  cartController
                                                      .numOfItems
                                                      .value <
                                                      productDetailsController
                                                          .productModel
                                                          .value
                                                          .data!
                                                          .stock!
                                                  ?
                                              // Iccrement active
                                              SvgPicture.asset(
                                                  SvgIcon.increment,
                                                  color: AppColor
                                                      .primaryColor,
                                                  height:
                                                  20.h,
                                                  width: 20.w)
                                                  :

                                              // Increment inActive
                                              SvgPicture.asset(
                                                  SvgIcon.increment,
                                                  height: 20.h,
                                                  width: 20.w,
                                                  color: Colors.grey)
                                                  : productDetailsController
                                                  .variationsStock.value != -1
                                                  ? cartController.numOfItems
                                                  .value ==
                                                  productDetailsController
                                                      .variationsStock.value ||
                                                  productDetailsController
                                                      .variationsStock.value ==
                                                      0
                                                  ? SvgPicture.asset(
                                                  SvgIcon.increment,
                                                  color: Colors.grey,
                                                  height: 20.h,
                                                  width: 20.w)
                                                  : SvgPicture.asset(
                                                  SvgIcon.increment,
                                                  color: AppColor.primaryColor,
                                                  height: 20.h,
                                                  width: 20.w)
                                                  : SvgPicture.asset(
                                                  SvgIcon.increment,
                                                  height: 20.h,
                                                  width: 20.w,
                                                  color: Colors.grey))
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Obx(
                                          () =>
                                      productDetailsController
                                          .initialVariationModel
                                          .value
                                          .data ==
                                          null ||
                                          productDetailsController
                                              .initialVariationModel
                                              .value
                                              .data!
                                              .isEmpty
                                          ? productDetailsController
                                          .productModel
                                          .value
                                          .data!
                                          .stock! >
                                          0
                                          ? Row(
                                        children: [
                                          TextWidget(
                                            text:
                                            "Available:".tr,
                                            fontSize: 14.sp,
                                            fontWeight:
                                            FontWeight.w400,
                                          ),
                                          TextWidget(
                                              text:
                                              " (${productDetailsController
                                                  .productModel.value.data
                                                  ?.stock}) ",
                                              fontSize: 16.sp,
                                              fontWeight:
                                              FontWeight
                                                  .w600),
                                          TextWidget(
                                            text: productDetailsController
                                                .productModel
                                                .value
                                                .data
                                                ?.unit
                                                ?.toLowerCase(),
                                            fontWeight:
                                            FontWeight.w400,
                                            fontSize: 14.sp,
                                          )
                                        ],
                                      )
                                          : productDetailsController
                                          .productModel
                                          .value
                                          .data!
                                          .stock! ==
                                          0
                                          ? TextWidget(
                                        text:
                                        "Stock Out".tr,
                                        color: AppColor
                                            .redColor,
                                        fontWeight:
                                        FontWeight.w400,
                                        fontSize: 14.sp,
                                      )
                                          : const SizedBox()

                                      // inital variation not null

                                          : productDetailsController
                                          .variationsStock
                                          .value >
                                          0
                                          ? Row(
                                        children: [
                                          TextWidget(
                                            text:
                                            "Available:".tr,
                                            fontSize: 14.sp,
                                            fontWeight:
                                            FontWeight.w400,
                                          ),
                                          TextWidget(
                                              text:
                                              " (${productDetailsController
                                                  .variationsStock.value}) ",
                                              fontSize: 16.sp,
                                              fontWeight:
                                              FontWeight
                                                  .w600),
                                          TextWidget(
                                            text: productDetailsController
                                                .productModel
                                                .value
                                                .data
                                                ?.unit
                                                ?.toLowerCase(),
                                            fontWeight:
                                            FontWeight.w400,
                                            fontSize: 14.sp,
                                          )
                                        ],
                                      )
                                          : productDetailsController
                                          .variationsStock
                                          .value ==
                                          0
                                          ? TextWidget(
                                        text:
                                        "Stock Out".tr,
                                        color: AppColor
                                            .redColor,
                                        fontWeight:
                                        FontWeight.w400,
                                        fontSize: 14.sp,
                                      )
                                          : const SizedBox(),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 32.h),
                              ],
                            ),
                          Obx(() {
                            return Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                productDetailsController
                                    .isAddToCartLoading.value ==
                                    1
                                    ? SecondaryButtonLoader(
                                  height: 48.h,
                                  width: 165.w,
                                  buttonColor: AppColor.primaryColor,
                                )
                                    : SecondaryButton(
                                  height: 48.h,
                                  width: 165.w,
                                  icon: SvgIcon.bag,
                                  text: "ADD_TO_CART".tr,
                                  buttonColor:
                                  productDetailsController
                                      .hasItemsForCart()
                                      ? AppColor.primaryColor
                                      : AppColor.grayColor,
                                  /*productDetailsController
                                                        .initialVariationModel
                                                        .value
                                                        .data ==
                                                    null ||
                                                productDetailsController
                                                    .initialVariationModel
                                                    .value
                                                    .data!
                                                    .isEmpty
                                            ? productDetailsController
                                                        .productModel
                                                        .value
                                                        .data!
                                                        .stock! >
                                                    0
                                                ? AppColor.primaryColor
                                                : AppColor.grayColor

                                            // inital variation not null

                                            : productDetailsController
                                                        .variationsStock.value >
                                                    0
                                                ? AppColor.primaryColor
                                                : AppColor.grayColor,*/
                                  onTap: () {
                                    productDetailsController
                                        .getOrderDetails();
                                  },
                                  /*async {
                                          if (productDetailsController
                                                      .initialVariationModel
                                                      .value
                                                      .data !=
                                                  null &&
                                              productDetailsController
                                                  .initialVariationModel
                                                  .value
                                                  .data!
                                                  .isNotEmpty) {
                                            if (productDetailsController
                                                    .variationsStock.value >
                                                0) {

                                              // for finalVariationString
                                              await productDetailsController
                                                  .finalVariation(
                                                      id: productDetailsController
                                                          .variationProductId
                                                          .toString());
                                              cartController
                                                      .totalIndividualProductTax =
                                                  0.0;
                                              productDetailsController
                                                  .productModel
                                                  .value
                                                  .data!
                                                  .taxes!
                                                  .map((e) {
                                                cartController
                                                        .totalIndividualProductTax +=
                                                    double.parse(
                                                        e.taxRate.toString());
                                              }).toList();

                                              var taxMap =
                                                  productDetailsController
                                                      .productModel
                                                      .value
                                                      .data!
                                                      .taxes!
                                                      .map((e) {
                                                return {
                                                  "id": e.id!.toInt(),
                                                  "name": e.name.toString(),
                                                  "code": e.code.toString(),
                                                  "tax_rate": double.tryParse(
                                                      e.taxRate.toString()),
                                                  'tax_amount': double.tryParse(
                                                      cartController.totalTax
                                                          .toString()),
                                                };
                                              }).toList();

                                              cartController.addItem(
                                                /*get*/ variationStock: productDetailsController.variationsStock.value
                                                      .toInt(),
                                                  product: productDetailsController
                                                      .productModel.value,
                                                 /*get*/ variationId: productDetailsController.initialVariationModel.value.data == null ||
                                                          productDetailsController
                                                              .initialVariationModel
                                                              .value
                                                              .data!
                                                              .isEmpty
                                                      ? 0
                                                      : int.parse(productDetailsController
                                                          .variationProductId
                                                          .value),
                                                  shippingAmount: authController.settingModel?.data?.shippingSetupMethod.toString() == "5" && productDetailsController.productModel.value.data?.shipping?.shippingType.toString() == "5"
                                                      ? "0"
                                                      : productDetailsController
                                                          .productModel
                                                          .value
                                                          .data!
                                                          .shipping!
                                                          .shippingCost,
                                                  finalVariation: productDetailsController.finalVariationString,
                                                 /*get*/ sku: productDetailsController.variationsku.value,
                                                  taxJson: taxMap,
                                                  /*get*/ stock: productDetailsController.variationsStock.value,
                                                  shipping: productDetailsController.productModel.value.data?.shipping,
                                                  /*get*/ productVariationPrice: productDetailsController.variationProductPrice.value,
                                                  /*get*/ productVariationOldPrice: productDetailsController.variationProductOldPrice.value,
                                                  /*get*/ productVariationCurrencyPrice: productDetailsController.variationProductCurrencyPrice.value,
                                                  /*get*/ productVariationOldCurrencyPrice: productDetailsController.variationProductOldCurrencyPrice.value,
                                                  totalTax: cartController.totalIndividualProductTax,
                                                  flatShippingCost: authController.settingModel?.data?.shippingSetupFlatRateWiseCost.toString() ?? "0");

                                              cartController.calculateShippingCharge(
                                                  shippingMethodStatus:
                                                      authController
                                                          .shippingMethod,
                                                  shippingType:
                                                      productDetailsController
                                                              .productModel
                                                              .value
                                                              .data
                                                              ?.shipping
                                                              ?.shippingType
                                                              .toString() ??
                                                          "0",
                                                  isProductQntyMultiply:
                                                      productDetailsController
                                                              .productModel
                                                              .value
                                                              .data
                                                              ?.shipping
                                                              ?.isProductQuantityMultiply
                                                              .toString() ??
                                                          "0",
                                                  flatShippingCharge: authController
                                                      .settingModel
                                                      ?.data
                                                      ?.shippingSetupFlatRateWiseCost);

                                              if (cartController
                                                  .isProductAdded) {
                                                Get.back();
                                                customSnackbar(
                                                    "SUCCESS".tr,
                                                    "Product added to cart".tr,
                                                    AppColor.success);
                                              }
                                            } else {}
                                          } else {
                                            //     productDetailsController.variationsStock.value = productDetailsController.productModel.value.data?.stock ?? 0;
                                            if (productDetailsController
                                                    .productModel
                                                    .value
                                                    .data!
                                                    .stock! >
                                                0) {
                                              cartController
                                                      .totalIndividualProductTax =
                                                  0.0;

                                              productDetailsController
                                                  .productModel
                                                  .value
                                                  .data!
                                                  .taxes!
                                                  .map((e) {
                                                cartController
                                                        .totalIndividualProductTax +=
                                                    double.parse(
                                                        e.taxRate.toString());
                                              }).toList();

                                              var taxMap =
                                                  productDetailsController
                                                      .productModel
                                                      .value
                                                      .data!
                                                      .taxes!
                                                      .map((e) {
                                                return {
                                                  "id": e.id!.toInt(),
                                                  "name": e.name.toString(),
                                                  "code": e.code.toString(),
                                                  "tax_rate": double.tryParse(
                                                      e.taxRate.toString()),
                                                  'tax_amount': double.tryParse(
                                                      cartController.totalTax
                                                          .toString()),
                                                };
                                              }).toList();

                                              cartController.addItem(
                                                  variationStock: productDetailsController.variationsStock.value
                                                      .toInt(),
                                                  product: productDetailsController
                                                      .productModel.value,
                                                  variationId: productDetailsController.initialVariationModel.value.data == null ||
                                                          productDetailsController
                                                              .initialVariationModel
                                                              .value
                                                              .data!
                                                              .isEmpty
                                                      ? 0
                                                      : int.parse(productDetailsController
                                                          .variationProductId
                                                          .value),
                                                  shippingAmount: authController.settingModel?.data?.shippingSetupMethod.toString() == "5" && productDetailsController.productModel.value.data?.shipping?.shippingType.toString() == "5"
                                                      ? "0"
                                                      : productDetailsController
                                                          .productModel
                                                          .value
                                                          .data
                                                          ?.shipping
                                                          ?.shippingCost,
                                                  finalVariation: productDetailsController.finalVariationString,
                                                  sku: productDetailsController.productModel.value.data?.sku,
                                                  taxJson: taxMap,
                                                  stock: productDetailsController.productModel.value.data?.stock,
                                                  shipping: productDetailsController.productModel.value.data?.shipping,
                                                  productVariationPrice: productDetailsController.productModel.value.data?.price,
                                                  productVariationOldPrice: productDetailsController.productModel.value.data?.oldPrice,
                                                  productVariationCurrencyPrice: productDetailsController.productModel.value.data?.currencyPrice,
                                                  productVariationOldCurrencyPrice: productDetailsController.productModel.value.data?.oldCurrencyPrice,
                                                  totalTax: cartController.totalIndividualProductTax,
                                                  flatShippingCost: authController.settingModel?.data?.shippingSetupFlatRateWiseCost.toString() ?? "0");

                                              cartController
                                                  .calculateShippingCharge(
                                                shippingMethodStatus:
                                                    authController
                                                        .shippingMethod,
                                                shippingType:
                                                    productDetailsController
                                                            .productModel
                                                            .value
                                                            .data
                                                            ?.shipping
                                                            ?.shippingType
                                                            .toString() ??
                                                        "0",
                                                isProductQntyMultiply:
                                                    productDetailsController
                                                            .productModel
                                                            .value
                                                            .data
                                                            ?.shipping
                                                            ?.isProductQuantityMultiply
                                                            .toString() ??
                                                        "0",
                                                flatShippingCharge: authController
                                                    .settingModel
                                                    ?.data
                                                    ?.shippingSetupFlatRateWiseCost,
                                              );
                                              if (cartController
                                                  .isProductAdded) {
                                                Get.back();
                                                customSnackbar(
                                                    "SUCCESS".tr,
                                                    "Product added to cart".tr,
                                                    AppColor.success);
                                              }
                                            } else {}
                                          }
                                        },*/
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (box.read('isLogedIn') != false) {
                                      if (productDetailsController
                                          .productModel
                                          .value
                                          .data!
                                          .wishlist ==
                                          true) {
                                        await wishlistController
                                            .toggleFavoriteFalse(
                                            productDetailsController
                                                .productModel
                                                .value
                                                .data!
                                                .id!);

                                        wishlistController.showFavorite(
                                            productDetailsController
                                                .productModel
                                                .value
                                                .data!
                                                .id!);
                                      }
                                      if (productDetailsController
                                          .productModel
                                          .value
                                          .data!
                                          .wishlist ==
                                          false) {
                                        await wishlistController
                                            .toggleFavoriteTrue(
                                            productDetailsController
                                                .productModel
                                                .value
                                                .data!
                                                .id!);

                                        wishlistController.showFavorite(
                                            productDetailsController
                                                .productModel
                                                .value
                                                .data!
                                                .id!);
                                      }
                                    } else {
                                      Get.to(() => const SignInScreen());
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(24.r),
                                  child: Ink(
                                    height: 48.h,
                                    width: 139.w,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(24.r),
                                        color: AppColor.whiteColor,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.04),
                                              blurRadius: 8.r,
                                              offset: const Offset(0, 4))
                                        ]),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          wishlistController.favList.contains(
                                              productDetailsController
                                                  .productModel
                                                  .value
                                                  .data!
                                                  .id!) ||
                                              productDetailsController
                                                  .productModel
                                                  .value
                                                  .data!
                                                  .wishlist ==
                                                  true
                                              ? SvgIcon.filledHeart
                                              : SvgIcon.heart,
                                          height: 24.h,
                                          width: 24.w,
                                        ),
                                        SizedBox(width: 8.w),
                                        CustomText(
                                          text: "FAVORITE".tr,
                                          size: 16.sp,
                                          weight: FontWeight.w700,
                                          color: AppColor.textColor,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          }),
                          SizedBox(height: 20.h),
                          const DeviderWidget(),
                          SizedBox(height: 20.h),
                          Obx(
                                () =>
                            productDetailsController
                                .productModel.value.data !=
                                null
                                ? CustomTabBar(
                              allProductModel:
                              widget.allProductModel,
                              categoryWiseProduct:
                              widget.categoryWiseProduct,
                              favoriteItem: widget.favoriteItem,
                              productModel: widget.productModel,
                              relatedProduct: widget.relatedProduct,
                              sectionModel: widget.sectionModel,
                            )
                                : const SizedBox(),
                          ),
                          SizedBox(height: 30.h),
                          CustomText(
                            text: "RELATED_PRODUCTS".tr,
                            size: 26.sp,
                            weight: FontWeight.w700,
                          ),
                          SizedBox(height: 20.h),
                          Obx(
                                () =>
                            productDetailsController
                                .relatedProductModel.value.data ==
                                null
                                ? const SizedBox()
                                : StaggeredGrid.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16.h,
                              crossAxisSpacing: 16.w,
                              children: [
                                for (int i = 0;
                                i <
                                    productDetailsController
                                        .relatedProductModel
                                        .value
                                        .data!
                                        .length;
                                i++)
                                  ProductWidget(
                                    onTap: () async {
                                      productDetailsController
                                          .resetProductState();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailsScreen(
                                                  relatedProduct:
                                                  productDetailsController
                                                      .relatedProductModel
                                                      .value
                                                      .data?[i]),
                                        ),
                                      );
                                    },
                                    favTap: () async {
                                      if (box.read('isLogedIn') !=
                                          false) {
                                        if (productDetailsController
                                            .relatedProductModel
                                            .value
                                            .data?[i]
                                            .wishlist ==
                                            true) {
                                          await wishlistController
                                              .toggleFavoriteFalse(
                                              productDetailsController
                                                  .relatedProductModel
                                                  .value
                                                  .data![i]
                                                  .id!);

                                          wishlistController.showFavorite(
                                              productDetailsController
                                                  .relatedProductModel
                                                  .value
                                                  .data![i]
                                                  .id!);
                                        }
                                        if (productDetailsController
                                            .relatedProductModel
                                            .value
                                            .data?[i]
                                            .wishlist ==
                                            false) {
                                          await wishlistController
                                              .toggleFavoriteTrue(
                                              productDetailsController
                                                  .relatedProductModel
                                                  .value
                                                  .data![i]
                                                  .id!);

                                          wishlistController.showFavorite(
                                              productDetailsController
                                                  .relatedProductModel
                                                  .value
                                                  .data![i]
                                                  .id!);
                                        }
                                      } else {
                                        Get.to(() =>
                                        const SignInScreen());
                                      }
                                    },
                                    wishlist: wishlistController
                                        .favList
                                        .contains(
                                        productDetailsController
                                            .relatedProductModel
                                            .value
                                            .data![i]
                                            .id!) ||
                                        productDetailsController
                                            .relatedProductModel
                                            .value
                                            .data?[i]
                                            .wishlist ==
                                            true
                                        ? true
                                        : false,
                                    productImage:
                                    productDetailsController
                                        .relatedProductModel
                                        .value
                                        .data?[i]
                                        .cover,
                                    title: productDetailsController
                                        .relatedProductModel
                                        .value
                                        .data?[i]
                                        .name,
                                    rating: productDetailsController
                                        .relatedProductModel
                                        .value
                                        .data?[i]
                                        .ratingStar,
                                    currentPrice:
                                    productDetailsController
                                        .relatedProductModel
                                        .value
                                        .data?[i]
                                        .currencyPrice,
                                    discountPrice:
                                    productDetailsController
                                        .relatedProductModel
                                        .value
                                        .data?[i]
                                        .discountedPrice,
                                    textRating:
                                    productDetailsController
                                        .relatedProductModel
                                        .value
                                        .data?[i]
                                        .ratingStarCount,
                                    flashSale:
                                    productDetailsController
                                        .relatedProductModel
                                        .value
                                        .data![i]
                                        .flashSale!,
                                    isOffer:
                                    productDetailsController
                                        .relatedProductModel
                                        .value
                                        .data![i]
                                        .isOffer!,
                                  ),
                                SizedBox(height: 12.h),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
            floatingActionButton: authController.whatAppIcon(),
          );
        },
      ),
    );
  }
}
