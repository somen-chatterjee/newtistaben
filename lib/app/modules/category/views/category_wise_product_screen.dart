import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopperz/app/modules/auth/views/sign_in.dart';
import 'package:shopperz/app/modules/category/model/category_tree.dart';
import 'package:shopperz/app/modules/filter/controller/filter_controller.dart';
import 'package:shopperz/app/modules/home/model/category_model.dart';
import 'package:shopperz/app/modules/search/controller/search_controller.dart';
import 'package:shopperz/app/modules/wishlist/controller/wishlist_controller.dart';
import 'package:shopperz/app/modules/product_details/views/product_details.dart';
import 'package:shopperz/main.dart';
import 'package:shopperz/utils/images.dart';
import 'package:shopperz/widgets/appbar4.dart';
import 'package:shopperz/widgets/shimmer/collection_shimmer.dart';
import 'package:shopperz/widgets/shimmer/trendy_collections_shimmer.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../utils/svg_icon.dart';
import '../../../../widgets/textwidget.dart';
import '../../filter/views/filter_screen.dart';
import '../../product/widgets/product.dart';
import '../controller/category_wise_product_controller.dart';

class CategoryWiseProductScreen extends StatefulWidget {
  const CategoryWiseProductScreen(
      {super.key, this.categoryTreeModel, this.categoryModel, this.brandName});

  final CategoryTreeModel? categoryTreeModel;
  final Datum? categoryModel;
  final String? brandName;
  final int index = -1;
  final int length = 0;

  @override
  State<CategoryWiseProductScreen> createState() =>
      _CategoryWiseProductScreenState();
}

class _CategoryWiseProductScreenState extends State<CategoryWiseProductScreen> {
  final filterController = Get.put(FilterController());
  final productSearchController = Get.put(ProductSearchController());
  final cateWiseProductController = Get.put(CategoryWiseProductController());

  @override
  void initState() {
    cateWiseProductController.resetCollection();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cateWiseProductController.resetState();
      cateWiseProductController.loadMoreData(
          categorySlug: widget.categoryTreeModel?.slug ??
              widget.categoryModel?.slug ??
              "");
    });
    super.initState();
  }

  @override
  void dispose() {
    filterController.resetFilter();
    cateWiseProductController.resetState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cateWiseProductController = Get.find<CategoryWiseProductController>();
    final wishlistController = Get.find<WishlistController>();
    final filterController = Get.put(FilterController());

    if (filterController.homeBrands == null) {
      cateWiseProductController.resetState();
      cateWiseProductController.fetchCategoryWiseProduct(
        categorySlug:
            widget.categoryTreeModel?.slug ?? widget.categoryModel?.slug ?? '',
        sortBy: filterController.selectedOption.value.trim(),
        brands: filterController.brands,
        variatons: filterController.encodeVaritionObject,
        name: productSearchController.searchTextController.text.toString(),
      );
    } else {
      cateWiseProductController.resetState();
      cateWiseProductController.fetchCategoryWiseProduct(
          categorySlug: widget.categoryTreeModel?.slug ??
              widget.categoryModel?.slug ??
              '',
          sortBy: filterController.selectedOption.value.trim(),
          brands: filterController.homeBrands,
          variatons: filterController.encodeVaritionObject,
          name: productSearchController.searchTextController.text.toString());
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
      child: Obx(() {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBarWidget4(
            text: '',
            // showDownload: cateWiseProductController.categoryWiseProductList
            //     .isNotEmpty,
            // onTap: () {
            //   cateWiseProductController.getSearchProductPdf(
            //     categorySlug: widget.categoryTreeModel?.slug ??
            //         widget.categoryModel?.slug ??
            //         '',
            //     sortBy: filterController.selectedOption.value.trim(),
            //     brands: filterController.homeBrands,
            //     variations: filterController.encodeVaritionObject,
            //     name: productSearchController.searchTextController.text.toString(),
            //   );
            // },
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: widget.categoryModel?.name ??
                                  widget.categoryTreeModel?.name
                                      .toString()
                                      .tr ??
                                  widget.brandName ??
                                  'Search Results'.tr,
                              color: AppColor.textColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Obx(
                              () => Row(
                                children: [
                                  TextWidget(
                                    text:
                                        '(${cateWiseProductController.categoryWiseProductList.length} Products Found)',
                                    color: AppColor.textColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            if (cateWiseProductController
                                .categoryWiseProductList.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  cateWiseProductController.getSearchProductPdf(
                                    categorySlug:
                                        widget.categoryTreeModel?.slug ??
                                            widget.categoryModel?.slug ??
                                            '',
                                    sortBy: filterController
                                        .selectedOption.value
                                        .trim(),
                                    brands: filterController.homeBrands,
                                    variations:
                                        filterController.encodeVaritionObject,
                                    name: productSearchController
                                        .searchTextController.text
                                        .toString(),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: AppColor.primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.r)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextWidget(
                                            text: "Catalogue",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.whiteColor,
                                          ),
                                          TextWidget(
                                            text: "(Use filters)",
                                            fontSize: 12,
                                            color: AppColor.whiteColor,
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10.w),
                                      SvgPicture.asset(
                                        "assets/icons/download.svg",
                                        width: 20,
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            SizedBox(width: 10.w),
                            InkWell(
                              onTap: () {
                                if (cateWiseProductController
                                        .categoryWiseProductModel.value.data !=
                                    null) {
                                  Get.to(() => FilterScreen(
                                            cateWiseProductModel:
                                                cateWiseProductController
                                                    .categoryWiseProductModel
                                                    .value
                                                    .data,
                                          ))!
                                      .then((value) {
                                    setState(() {});
                                  });
                                }
                              },
                              child: SvgPicture.asset(
                                SvgIcon.filter,
                                height: 24.h,
                                width: 24.w,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // collection Section
                  Obx(() {
                    if (!cateWiseProductController.isCollectionLoading.value &&
                        cateWiseProductController.collectionList.isNotEmpty) {
                      return SizedBox(
                        height: 132.h,
                        // Increased height to accommodate text outside the container
                        child: Obx(
                          () => ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                cateWiseProductController.collectionList.length,
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            separatorBuilder: (context, index) {
                              return SizedBox(width: 4.w);
                            },
                            itemBuilder: (context, index) {
                              var item = cateWiseProductController
                                  .collectionList[index];
                              int id = item.productAttributeOptionId ?? 0;
                              return Obx(() {
                                bool isSelected = cateWiseProductController
                                    .selectedCollections
                                    .contains(id);

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        cateWiseProductController
                                            .toggleSelection(id);

                                        cateWiseProductController
                                            .setCollectionVariation(item: item);

                                        setState(() {});
                                      },
                                      child: Container(
                                        // margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          // borderRadius: BorderRadius.circular(20),
                                          shape: BoxShape.circle,
                                          border: isSelected
                                              ? Border.all(
                                                  color: Colors.pink,
                                                  width: 1.5,
                                                )
                                              : Border.all(
                                                  color: Colors.transparent,
                                                  width: 1.5,
                                                ), // Pink border when selected
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            ClipOval(
                                              child: Image.network(
                                                item.image ?? "",
                                                width: 90.w,
                                                height: 90.h,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            if (isSelected) // Light pink overlay when selected
                                              Container(
                                                width: 90.w,
                                                height: 90.h,
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                  color: Colors.pink
                                                      .withOpacity(0.4),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            if (isSelected) // Right tick icon at bottom-right
                                              Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.pink,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  padding: EdgeInsets.all(3),
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    // Space between container and text
                                    TextWidget(
                                      text: item.attributeOptionName ?? "",
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? Colors.pink
                                          : Colors.black,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                );
                              });
                            },
                          ),
                        ),
                      );
                    } else {
                      return CollectionShimmer();
                    }
                  }),
                  // product list
                  Expanded(
                    child: RefreshIndicator(
                      color: AppColor.primaryColor,
                      onRefresh: () async {
                        if (filterController.homeBrands == null) {
                          cateWiseProductController.resetState();
                          cateWiseProductController.fetchCategoryWiseProduct(
                            categorySlug: widget.categoryTreeModel?.slug ??
                                widget.categoryModel?.slug ??
                                '',
                            sortBy:
                                filterController.selectedOption.value.trim(),
                            brands: filterController.brands,
                            variatons: filterController.encodeVaritionObject,
                            name: productSearchController
                                .searchTextController.text
                                .toString(),
                          );
                        } else {
                          cateWiseProductController.resetState();
                          cateWiseProductController.fetchCategoryWiseProduct(
                              categorySlug: widget.categoryTreeModel?.slug ??
                                  widget.categoryModel?.slug ??
                                  '',
                              sortBy:
                                  filterController.selectedOption.value.trim(),
                              brands: filterController.homeBrands,
                              variatons: filterController.encodeVaritionObject,
                              name: productSearchController
                                  .searchTextController.text
                                  .toString());
                        }
                      },
                      child: Obx(
                        () => cateWiseProductController.isLoading.value == true
                            ? const TrendyCollectionShimmer()
                            : cateWiseProductController
                                    .categoryWiseProductList.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 120.h),
                                      child: Center(
                                        child: Image.asset(
                                          AppImages.emptyIcon,
                                          height: 300.h,
                                          width: 300.w,
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                    ),
                                    child: MasonryGridView.count(
                                      controller: cateWiseProductController
                                          .scrollController,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 6.h,
                                      padding: EdgeInsets.only(bottom: 16.h),
                                      crossAxisSpacing: 6.w,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: cateWiseProductController
                                              .categoryWiseProductList.length +
                                          (cateWiseProductController
                                                      .hasMoreData ==
                                                  true
                                              ? 1
                                              : 0),
                                      itemBuilder: (context, i) {
                                        if (i ==
                                            cateWiseProductController
                                                .categoryWiseProductList
                                                .length) {
                                          return Shimmer.fromColors(
                                            baseColor: Colors.grey[200]!,
                                            highlightColor: Colors.grey[300]!,
                                            child: Container(
                                              height: 207.h,
                                              width: 156.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16.r),
                                                color: Colors.white,
                                                border: Border.all(
                                                    color:
                                                        AppColor.borderColor),
                                              ),
                                            ),
                                          );
                                        }
                                        return GestureDetector(
                                          onTap: () {
                                            Get.to(() => ProductDetailsScreen(
                                                categoryWiseProduct:
                                                    cateWiseProductController
                                                            .categoryWiseProductList[
                                                        i]));
                                          },
                                          child: Obx(
                                            () => ProductWidget(
                                              favTap: () async {
                                                if (box.read('isLogedIn') !=
                                                    false) {
                                                  if (cateWiseProductController
                                                          .categoryWiseProductList[
                                                              i]
                                                          .wishlist ==
                                                      true) {
                                                    await wishlistController
                                                        .toggleFavoriteFalse(
                                                            cateWiseProductController
                                                                .categoryWiseProductList[
                                                                    i]
                                                                .id!);

                                                    wishlistController.showFavorite(
                                                        cateWiseProductController
                                                            .categoryWiseProductList[
                                                                i]
                                                            .id!);
                                                  }
                                                  if (cateWiseProductController
                                                          .categoryWiseProductList[
                                                              i]
                                                          .wishlist ==
                                                      false) {
                                                    await wishlistController
                                                        .toggleFavoriteTrue(
                                                            cateWiseProductController
                                                                .categoryWiseProductList[
                                                                    i]
                                                                .id!);

                                                    wishlistController.showFavorite(
                                                        cateWiseProductController
                                                            .categoryWiseProductList[
                                                                i]
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
                                                              cateWiseProductController
                                                                  .categoryWiseProductList[
                                                                      i]
                                                                  .id!) ||
                                                      cateWiseProductController
                                                              .categoryWiseProductList[
                                                                  i]
                                                              .wishlist ==
                                                          true
                                                  ? true
                                                  : false,
                                              productImage:
                                                  cateWiseProductController
                                                      .categoryWiseProductList[
                                                          i]
                                                      .cover
                                                      .toString(),
                                              title: cateWiseProductController
                                                  .categoryWiseProductList[i]
                                                  .name,
                                              currentPrice:
                                                  cateWiseProductController
                                                      .categoryWiseProductList[
                                                          i]
                                                      .currencyPrice,
                                              discountPrice:
                                                  cateWiseProductController
                                                      .categoryWiseProductList[
                                                          i]
                                                      .discountedPrice,
                                              rating: cateWiseProductController
                                                  .categoryWiseProductList[i]
                                                  .ratingStar,
                                              textRating:
                                                  cateWiseProductController
                                                      .categoryWiseProductList[
                                                          i]
                                                      .ratingStarCount,
                                              flashSale:
                                                  cateWiseProductController
                                                      .categoryWiseProductList[
                                                          i]
                                                      .flashSale!,
                                              isOffer: cateWiseProductController
                                                  .categoryWiseProductList[i]
                                                  .isOffer!,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                      ),
                    ),
                  ),
                ],
              ),
              Obx(() {
                return cateWiseProductController.pdfLoading.value
                    ? Container(
                        color: AppColor.whiteColor.withValues(alpha: 0.5),
                        child: Center(
                          child: Image.asset(
                            AppImages.loading,
                            height: 35.h,
                            width: 35.w,
                          ),
                        ),
                      )
                    : SizedBox();
              }),
            ],
          ),
        );
      }),
    );
  }
}
