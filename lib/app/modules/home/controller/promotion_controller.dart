import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopperz/app/modules/home/model/promotion_model.dart';
import 'package:shopperz/app/modules/promotion/model/promotion_wise_product.dart';
import 'package:shopperz/config/theme/app_color.dart';
import 'package:shopperz/data/remote_services/remote_services.dart';
import 'package:shopperz/widgets/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class PromotionalController extends GetxController {
  ScrollController scrollController = ScrollController();
  final isLoading = false.obs;
  final loading = false.obs;
  final promotionModel = PromotionModel().obs;
  final multiPromotionModel = PromotionModel().obs;
  final promotionProductModel = <PromotionProduct>[].obs;
  final promotionProductLoader = false.obs;

  int paginate = 1;
  final page = 1.obs;
  final itemPerPage = 30.obs;
  final lastPage = 1.obs;
  bool hasMoreData = false;

  Future<void> fetchPromotion() async {
    isLoading(true);
    final data = await RemoteServices().fetchPromotion();
    isLoading(false);
    data.fold((error) => error.toString(), (promotion) {
      promotionModel.value = promotion;
    });
  }

  Future<void> fetchMultiPromotion() async {
    loading(true);
    final data = await RemoteServices().fetchMultiPromotion();
    loading(false);
    data.fold((error) => error.toString(), (promotion) {
      multiPromotionModel.value = promotion;
    });
  }

  Future<void> fetchPromotionWiseProduct(
      {required String promotionSlug}) async {
    promotionProductLoader.value = true;
    final result = await RemoteServices().fetchPromotionWiseProduct(
        promotionSlug: promotionSlug,
        page: page.value,
        paginate: paginate,
        perPage: itemPerPage.value);

    promotionProductLoader.value = false;

    result.fold((error) {
      promotionProductLoader.value = false;
    }, (data) {
      promotionProductLoader.value = false;

      lastPage.value = data.meta!.lastPage!.toInt();

      if (page.value < lastPage.value) {
        hasMoreData = true;
      } else if (page.value == lastPage.value) {
        hasMoreData = false;
      } else {
        hasMoreData = false;
      }

      promotionProductModel.value += data.data!;
    });
  }

  var pdfLoading = false.obs;

  getPromotionProductPdf({required String promotionSlug}) async {
    pdfLoading(true);
    try {
      final data = await RemoteServices().fetchPromotionPdfProduct(
          promotionSlug: promotionSlug,
          page: page.value,
          paginate: paginate,
          perPage: itemPerPage.value
      );

      openPdf(url: data);

    } catch (e) {

      customSnackbar(
        "ERROR".tr,
        "Failed to load the catalogue. Try again later.",
        AppColor.error,
      );

      // debugPrint("sam $e");
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

  void loadMoreData({
    required String categorySlug,
  }) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (hasMoreData) {
          page.value++;
          fetchPromotionWiseProduct(
            promotionSlug: categorySlug,
          );
        }
      }
    });
  }

  void resetState() {
    promotionProductModel.clear();
    page.value = 1;
    lastPage.value = 1;
    hasMoreData = false;
  }

  @override
  void onInit() {
    fetchPromotion();
    fetchMultiPromotion();
    super.onInit();
  }
}
