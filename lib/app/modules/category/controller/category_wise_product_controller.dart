import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopperz/config/theme/app_color.dart';
import 'package:shopperz/data/remote_services/remote_services.dart';
import 'package:shopperz/widgets/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/category_wise_product.dart';

class CategoryWiseProductController extends GetxController {
  ScrollController scrollController = ScrollController();
  final isLaoding = false.obs;
  final categoryWiseProductModel = CategoryWiseProduct().obs;
  final categoryWiseProductList = <Product>[].obs;

  int paginate = 1;
  final page = 1.obs;
  final itemPerPage = 30.obs;
  final isLoading = false.obs;
  final lastPage = 1.obs;
  bool hasMoreData = false;

  final indexCount = RxInt(-1);
  final itemCount = 0.obs;

  Map<String, dynamic>? variationsMap;

  fetchCategoryWiseProduct({
    required String categorySlug,
    String? brands,
    sortBy,
    minPrice,
    maxPrice,
    String? name,
    variatons,
  }) async {
    isLaoding(true);
    final data = await RemoteServices().fetchCategoryWiseProduct(
      category: categorySlug,
      brands: brands,
      sortBy: sortBy,
      minPrice: minPrice,
      maxPrice: maxPrice,
      name: name ?? "",
      variations: variatons,
      page: page.value,
    );
    isLaoding(false);
    data.fold((error) {
      isLaoding.value = false;
      error.toString();
    }, (categoryWiseProduct) {
      categoryWiseProductModel.value = categoryWiseProduct;

      lastPage.value = categoryWiseProduct.data!.lastPage!.toInt();

      if (page.value < lastPage.value) {
        hasMoreData = true;
      } else if (page.value == lastPage.value) {
        hasMoreData = false;
      } else {
        hasMoreData = false;
      }

      categoryWiseProductList.value += categoryWiseProduct.data!.products!;
    });
  }

  void loadMoreData({
    required String categorySlug,
  }) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (hasMoreData) {
          page.value++;
          fetchCategoryWiseProduct(
            categorySlug: categorySlug,
          );
        }
      }
    });
  }

  var pdfLoading = false.obs;

  getSearchProductPdf({
    required String categorySlug,
    String? brands,
    sortBy,
    minPrice,
    maxPrice,
    String? name,
    variations,
  }) async {
    pdfLoading(true);
    try {
      final data = await RemoteServices().getProductsPdf(
        category: categorySlug,
        brands: brands,
        sortBy: sortBy,
        minPrice: minPrice,
        maxPrice: maxPrice,
        name: name ?? "",
        variations: variations,
        page: page.value,
      );

      openPdf(url: data);

    } catch (e) {

      customSnackbar(
        "ERROR".tr,
        "Failed to load the catalogue. Try again later.",
        AppColor.error,
      );

      debugPrint("sam $e");
      pdfLoading(false);
    }

    pdfLoading(false);
  }

  void openPdf({required String url}) async {

    Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch pdf");
      customSnackbar(
          "ERROR".tr,
          "Failed to load the catalogue. Try again later.",
          AppColor.error,
      );
    }
  }


  void resetState() {
    categoryWiseProductList.clear();
    page.value = 1;
    lastPage.value = 1;
    hasMoreData = false;
  }
}
