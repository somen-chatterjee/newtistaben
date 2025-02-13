import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:shopperz/app/modules/auth/controller/auth_controler.dart';
import 'package:shopperz/app/modules/cart/controller/cart_controller.dart';
import 'package:shopperz/app/modules/cart/model/product_model.dart';
import 'package:shopperz/app/modules/product_details/model/children_variation.dart';
import 'package:shopperz/app/modules/product_details/model/initial_variation.dart';
import 'package:shopperz/app/modules/product_details/model/related_product.dart';
import 'package:shopperz/config/theme/app_color.dart';
import 'package:shopperz/data/remote_services/remote_services.dart';
import 'package:shopperz/data/server/app_server.dart';
import 'package:shopperz/utils/api_list.dart';
import 'package:shopperz/widgets/custom_snackbar.dart';

class ProductDetailsController extends GetxController {
  final productModel = ProductModel().obs;
  final relatedProductModel = RelatedProductModel().obs;
  final initialVariationModel = InitialVariationModel().obs;
  final childrenVariationModel1 = ChildrenVariationModel().obs;
  final childrenVariationModel2 = ChildrenVariationModel().obs;
  final childrenVariationModel3 = ChildrenVariationModel().obs;
  final childrenVariationModel4 = ChildrenVariationModel().obs;
  final childrenVariationModel5 = ChildrenVariationModel().obs;
  final childrenVariationModel6 = ChildrenVariationModel().obs;

  final initialIndex = RxInt(-1);
  final selectedIndex1 = RxInt(-1);
  final selectedIndex2 = RxInt(-1);
  final selectedIndex3 = RxInt(-1);
  final selectedIndex4 = RxInt(-1);
  final selectedIndex5 = RxInt(-1);
  final selectedIndex6 = RxInt(-1);
  final selectedIndex7 = RxInt(-1);

  final variationProductId = ''.obs;
  final variationProductPrice = ''.obs;
  final variationProductCurrencyPrice = ''.obs;
  final variationProductOldPrice = ''.obs;
  final variationProductOldCurrencyPrice = ''.obs;
  final variationsku = ''.obs;
  final variationsStock = RxInt(-1);

  final reviewLimit = 3.obs;

  final isLaoding = RxInt(1);

  String finalVariationString = "";

  resetProductState() {
    childrenVariationModel1.value.data?.clear();
    childrenVariationModel2.value.data?.clear();
    childrenVariationModel3.value.data?.clear();
    childrenVariationModel4.value.data?.clear();
    childrenVariationModel5.value.data?.clear();
    childrenVariationModel6.value.data?.clear();

    initialIndex.value = -1;
    selectedIndex1.value = -1;
    selectedIndex2.value = -1;
    selectedIndex3.value = -1;
    selectedIndex4.value = -1;
    selectedIndex5.value = -1;
    selectedIndex6.value = -1;
    selectedIndex7.value = -1;

    variationProductId.value = '';
    variationProductPrice.value = '';
    variationProductCurrencyPrice.value = '';
    variationProductOldPrice.value = '';
    variationProductOldCurrencyPrice.value = '';
    variationsku.value = '';
    variationsStock.value = -1;

    finalVariationString = '';
  }

  Future<void> fetchProductDetails({required String slug}) async {
    isLaoding.value = 1;
    final data = await RemoteServices()
        .fetchProductDetails(slug: slug, reviewLimit: reviewLimit.value);

    isLaoding.value = 0;

    data.fold((error) {}, (product) {
      productModel.value = product;
    });
  }

  Future<void> fetchRelatedProduct({required String slug}) async {
    final data = await RemoteServices().fetchRelatedProducts(slug: slug);

    data.fold((error) => error, (relatedProduct) {
      relatedProductModel.value = relatedProduct;
      refresh();
    });
  }

  Future<void> fetchInitialVariation({required String productId}) async {
    final data =
        await RemoteServices().fetchInitialVariation(productId: productId);

    data.fold((error) {}, (initialData) {
      initialVariationModel.value = initialData;
    });
  }

  Future<void> fetchChildrenVariation1(
      {required String initialVariationId}) async {
    final data = await RemoteServices()
        .fetchChildrenVariation(initialVariationId: initialVariationId);

    data.fold((error) {}, (childrenData) {
      childrenVariationModel1.value = childrenData;
      productDetailsList.clear();
      childrenVariationModel1.value.data
          ?.map((value) => productDetailsList.add(ProductDetails()))
          .toList();
    });
  }

  Future<void> fetchChildrenVariation2(
      {required String initialVariationId}) async {
    final data = await RemoteServices()
        .fetchChildrenVariation(initialVariationId: initialVariationId);

    data.fold((error) {}, (childrenData) {
      childrenVariationModel2.value = childrenData;
    });
  }

  Future<void> fetchChildrenVariation3(
      {required String initialVariationId}) async {
    final data = await RemoteServices()
        .fetchChildrenVariation(initialVariationId: initialVariationId);

    data.fold((error) {}, (childrenData) {
      childrenVariationModel3.value = childrenData;
    });
  }

  Future<void> fetchChildrenVariation4(
      {required String initialVariationId}) async {
    final data = await RemoteServices()
        .fetchChildrenVariation(initialVariationId: initialVariationId);

    data.fold((error) {}, (childrenData) {
      childrenVariationModel4.value = childrenData;
    });
  }

  Future<void> fetchChildrenVariation5(
      {required String initialVariationId}) async {
    final data = await RemoteServices()
        .fetchChildrenVariation(initialVariationId: initialVariationId);

    data.fold((error) {}, (childrenData) {
      childrenVariationModel5.value = childrenData;
    });
  }

  Future<void> fetchChildrenVariation6(
      {required String initialVariationId}) async {
    final data = await RemoteServices()
        .fetchChildrenVariation(initialVariationId: initialVariationId);

    data.fold((error) {}, (childrenData) {
      childrenVariationModel6.value = childrenData;
    });
  }

  Future<void> finalVariation({required id}) async {
    finalVariationString = "";
    final response = await AppServer().getRequest(
      endPoint: ApiList.finalVariation + id,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        "x-api-key": ApiList.licenseCode.toString(),
      },
    );
    if (response.statusCode == 200) {
      finalVariationString = response.data["data"];
    }
  }

  bool enableAddToCart = false;

  void incrementDecrementQty({required int index, required bool isIncrement}) {
    childrenVariationModel1.update((model) {
      if (model != null && model.data != null && index < model.data!.length) {
        if (isIncrement) {
          // Increase numOfItem but not exceed stock
          if (model.data![index].numOfItem < model.data![index].stock!) {
            model.data![index].numOfItem++;

            // product id
            variationProductId.value =
                childrenVariationModel1.value.data?[index].id.toString() ?? '';

            // stock
            variationsStock.value =
                childrenVariationModel1.value.data?[index].stock!.toInt() ?? 0;

            // variation sku
            variationsku.value =
                childrenVariationModel1.value.data?[index].sku.toString() ?? '';

            // variation price
            variationProductPrice.value =
                childrenVariationModel1.value.data?[index].price.toString() ??
                    '';

            // variation currency price
            variationProductCurrencyPrice.value = childrenVariationModel1
                    .value.data?[index].currencyPrice
                    .toString() ??
                '';

            // variation old price
            variationProductOldPrice.value = childrenVariationModel1
                    .value.data?[index].oldPrice
                    .toString() ??
                '';

            // variation old currency price
            variationProductOldCurrencyPrice.value = childrenVariationModel1
                    .value.data?[index].oldCurrencyPrice
                    .toString() ??
                '';

            productCalculation(index);
          }
        } else {
          // Decrease numOfItem but not go below 0
          if (model.data![index].numOfItem > 1) {
            model.data![index].numOfItem--;
            // if(model.data![index].numOfItem == 0) {
            //   variationProductId.value = '';
            //   variationProductPrice.value = '';
            //   variationProductCurrencyPrice.value = '';
            //   variationProductOldPrice.value = '';
            //   variationProductOldCurrencyPrice.value = '';
            //   variationsku.value = '';
            //   variationsStock.value = -1;
            //   productDetailsList.removeAt(index);
            // }
          }
        }
      }
    });
  }

  bool hasItemsForCart() {
    return childrenVariationModel1.value.data
            ?.any((item) => item.numOfItem > 0) ??
        false;
  }

  List<ProductDetails> productDetailsList = [];

  void productCalculation(int index) async {
    final cartController = Get.find<CartController>();
    final authController = Get.find<AuthController>();

    await finalVariation(id: variationProductId.toString());

    cartController.totalIndividualProductTax = 0.0;

    productModel.value.data!.taxes!.map((e) {
      cartController.totalIndividualProductTax +=
          double.parse(e.taxRate.toString());
    }).toList();

    var taxMap = productModel.value.data!.taxes!.map((e) {
      return {
        "id": e.id!.toInt(),
        "name": e.name.toString(),
        "code": e.code.toString(),
        "tax_rate": double.tryParse(e.taxRate.toString()),
        'tax_amount': double.tryParse(cartController.totalTax.toString()),
      };
    }).toList();

    var productDetails = ProductDetails(
      variationStock: variationsStock.value.toInt(),
      product: productModel.value,
      variationId: initialVariationModel.value.data == null ||
              initialVariationModel.value.data!.isEmpty
          ? 0
          : int.parse(variationProductId.value),
      shippingAmount: authController.settingModel?.data?.shippingSetupMethod
                      .toString() ==
                  "5" &&
              productModel.value.data?.shipping?.shippingType.toString() == "5"
          ? "0"
          : productModel.value.data!.shipping!.shippingCost,
      finalVariation: finalVariationString,
      sku: variationsku.value,
      taxJson: taxMap,
      stock: variationsStock.value,
      shipping: productModel.value.data?.shipping,
      productVariationPrice: variationProductPrice.value,
      productVariationOldPrice: variationProductOldPrice.value,
      productVariationCurrencyPrice: variationProductCurrencyPrice.value,
      productVariationOldCurrencyPrice: variationProductOldCurrencyPrice.value,
      totalTax: cartController.totalIndividualProductTax,
      flatShippingCost: authController
              .settingModel?.data?.shippingSetupFlatRateWiseCost
              .toString() ??
          "0",
      numOfItems: childrenVariationModel1.value.data![index].numOfItem,
    );

    productDetailsList[index] = productDetails;
  }

  void getOrderDetails() async {
    final cartController = Get.find<CartController>();
    final authController = Get.find<AuthController>();

    // print("somen getOrderDetails ${jsonEncode(initialVariationModel.value)}");
    log("somen getOrderDetails ${jsonEncode(productDetailsList)}");

    if (hasItemsForCart()) {
      for (var details in productDetailsList) {
        cartController.addItem(
          variationStock: details.variationStock,
          product: details.product ?? ProductModel(),
          variationId: details.variationId,
          shippingAmount: details.shippingAmount,
          finalVariation: details.finalVariation,
          sku: details.sku,
          taxJson: details.taxJson,
          stock: details.stock,
          shipping: details.shipping,
          productVariationPrice: details.productVariationPrice,
          productVariationOldPrice: details.productVariationOldPrice,
          productVariationCurrencyPrice: details.productVariationCurrencyPrice,
          productVariationOldCurrencyPrice:
              details.productVariationOldCurrencyPrice,
          totalTax: details.totalTax,
          flatShippingCost: details.flatShippingCost,
        );

        cartController.calculateShippingCharge(
            shippingMethodStatus: authController.shippingMethod,
            shippingType:
                details.product?.data?.shipping?.shippingType.toString() ?? "0",
            isProductQntyMultiply: details
                    .product?.data?.shipping?.isProductQuantityMultiply
                    .toString() ??
                "0",
            flatShippingCharge: authController
                .settingModel?.data?.shippingSetupFlatRateWiseCost);
      }

      if (cartController.isProductAdded) {
        Get.back();
        customSnackbar(
            "SUCCESS".tr, "Product added to cart".tr, AppColor.success);
      }
    }

    //
    // if (initialVariationModel.value.data != null &&
    //     initialVariationModel.value.data!.isNotEmpty) {
    //   if (variationsStock.value > 0) {
    //     // for finalVariationString
    //     await finalVariation(
    //         id: variationProductId.toString());
    //
    //     cartController.totalIndividualProductTax = 0.0;
    //
    //     productModel.value.data!.taxes!.map((e) {
    //       cartController.totalIndividualProductTax +=
    //           double.parse(e.taxRate.toString());
    //     }).toList();
    //
    //     var taxMap =
    //         productModel.value.data!.taxes!.map((e) {
    //       return {
    //         "id": e.id!.toInt(),
    //         "name": e.name.toString(),
    //         "code": e.code.toString(),
    //         "tax_rate": double.tryParse(e.taxRate.toString()),
    //         'tax_amount': double.tryParse(cartController.totalTax.toString()),
    //       };
    //     }).toList();
    //
    //     cartController.addItem(
    //         /*get*/
    //         variationStock:
    //             variationsStock.value.toInt(),
    //         product: productModel.value,
    //         /*get*/
    //         variationId: initialVariationModel.value.data == null ||
    //             initialVariationModel.value.data!.isEmpty
    //             ? 0
    //             : int.parse(variationProductId.value),
    //         shippingAmount: authController.settingModel?.data?.shippingSetupMethod.toString() == "5" &&
    //                 productModel.value.data?.shipping?.shippingType.toString() ==
    //                     "5"
    //             ? "0"
    //             : productModel.value.data!.shipping!.shippingCost,
    //         finalVariation: finalVariationString,
    //         /*get*/
    //         sku: variationsku.value,
    //         taxJson: taxMap,
    //         /*get*/
    //         stock: variationsStock.value,
    //         shipping:
    //             productModel.value.data?.shipping,
    //         /*get*/
    //         productVariationPrice:
    //             variationProductPrice.value,
    //         /*get*/
    //         productVariationOldPrice:
    //             variationProductOldPrice.value,
    //         /*get*/
    //         productVariationCurrencyPrice:
    //             variationProductCurrencyPrice.value,
    //         /*get*/
    //         productVariationOldCurrencyPrice:
    //             variationProductOldCurrencyPrice.value,
    //         totalTax: cartController.totalIndividualProductTax,
    //         flatShippingCost: authController.settingModel?.data?.shippingSetupFlatRateWiseCost.toString() ?? "0");
    //
    //     cartController.calculateShippingCharge(
    //         shippingMethodStatus: authController.shippingMethod,
    //         shippingType: productModel.value.data?.shipping?.shippingType
    //                 .toString() ??
    //             "0",
    //         isProductQntyMultiply: productModel.value
    //                 .data?.shipping?.isProductQuantityMultiply
    //                 .toString() ??
    //             "0",
    //         flatShippingCharge: authController
    //             .settingModel?.data?.shippingSetupFlatRateWiseCost);
    //
    //     if (cartController.isProductAdded) {
    //       Get.back();
    //       customSnackbar(
    //           "SUCCESS".tr, "Product added to cart".tr, AppColor.success);
    //     }
    //   } else {}
    // } else {
    //   //     variationsStock.value = productModel.value.data?.stock ?? 0;
    //   if (productModel.value.data!.stock! > 0) {
    //     cartController.totalIndividualProductTax = 0.0;
    //
    //     productModel.value.data!.taxes!.map((e) {
    //       cartController.totalIndividualProductTax +=
    //           double.parse(e.taxRate.toString());
    //     }).toList();
    //
    //     var taxMap =
    //         productModel.value.data!.taxes!.map((e) {
    //       return {
    //         "id": e.id!.toInt(),
    //         "name": e.name.toString(),
    //         "code": e.code.toString(),
    //         "tax_rate": double.tryParse(e.taxRate.toString()),
    //         'tax_amount': double.tryParse(cartController.totalTax.toString()),
    //       };
    //     }).toList();
    //
    //     cartController.addItem(
    //         variationStock:
    //             variationsStock.value.toInt(),
    //         product: productModel.value,
    //         variationId: initialVariationModel.value.data == null ||
    //                 initialVariationModel.value.data!.isEmpty
    //             ? 0
    //             : int.parse(variationProductId.value),
    //         shippingAmount: authController.settingModel?.data?.shippingSetupMethod.toString() == "5" &&
    //                 productModel.value.data?.shipping?.shippingType.toString() ==
    //                     "5"
    //             ? "0"
    //             : productModel.value.data?.shipping?.shippingCost,
    //         finalVariation: finalVariationString,
    //         sku: productModel.value.data?.sku,
    //         taxJson: taxMap,
    //         stock: productModel.value.data?.stock,
    //         shipping:
    //             productModel.value.data?.shipping,
    //         productVariationPrice:
    //             productModel.value.data?.price,
    //         productVariationOldPrice:
    //             productModel.value.data?.oldPrice,
    //         productVariationCurrencyPrice:
    //             productModel.value.data?.currencyPrice,
    //         productVariationOldCurrencyPrice:
    //             productModel.value.data?.oldCurrencyPrice,
    //         totalTax: cartController.totalIndividualProductTax,
    //         flatShippingCost: authController.settingModel?.data?.shippingSetupFlatRateWiseCost.toString() ?? "0");
    //
    //     cartController.calculateShippingCharge(
    //       shippingMethodStatus: authController.shippingMethod,
    //       shippingType: productModel.value.data?.shipping?.shippingType
    //               .toString() ??
    //           "0",
    //       isProductQntyMultiply: productModel.value.data?.shipping?.isProductQuantityMultiply
    //               .toString() ??
    //           "0",
    //       flatShippingCharge:
    //           authController.settingModel?.data?.shippingSetupFlatRateWiseCost,
    //     );
    //     if (cartController.isProductAdded) {
    //       Get.back();
    //       customSnackbar(
    //           "SUCCESS".tr, "Product added to cart".tr, AppColor.success);
    //     }
    //   } else {}
    // }
  }
}

class ProductDetails {
  final ProductModel? product;
  final int? variationId;
  final String? shippingAmount;
  final String? finalVariation;
  final String? sku;
  final dynamic taxJson;
  final dynamic stock;
  final dynamic shipping;
  final double? totalTax;
  final double? totalPrice;
  final dynamic productVariationPrice;
  final dynamic productVariationOldPrice;
  final dynamic productVariationCurrencyPrice;
  final dynamic productVariationOldCurrencyPrice;
  final int? variationStock;
  final String? flatShippingCost;
  final int? numOfItems;

  ProductDetails({
    this.product,
    this.variationId,
    this.shippingAmount,
    this.finalVariation,
    this.sku,
    this.taxJson,
    this.stock,
    this.shipping,
    this.totalTax,
    this.totalPrice,
    this.productVariationPrice,
    this.productVariationOldPrice,
    this.productVariationCurrencyPrice,
    this.productVariationOldCurrencyPrice,
    this.variationStock,
    this.flatShippingCost,
    this.numOfItems,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
      variationId: json['variationId'],
      shippingAmount: json['shippingAmount'],
      finalVariation: json['finalVariation'],
      sku: json['sku'],
      taxJson: json['taxJson'],
      stock: json['stock'],
      shipping: json['shipping'],
      totalTax: (json['totalTax'] as num?)?.toDouble(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      productVariationPrice: json['productVariationPrice'],
      productVariationOldPrice: json['productVariationOldPrice'],
      productVariationCurrencyPrice: json['productVariationCurrencyPrice'],
      productVariationOldCurrencyPrice:
          json['productVariationOldCurrencyPrice'],
      variationStock: json['variationStock'],
      flatShippingCost: json['flatShippingCost'],
      numOfItems: json['numOfItems'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product?.toJson(),
      'variationId': variationId,
      'shippingAmount': shippingAmount,
      'finalVariation': finalVariation,
      'sku': sku,
      'taxJson': taxJson,
      'stock': stock,
      'shipping': shipping,
      'totalTax': totalTax,
      'totalPrice': totalPrice,
      'productVariationPrice': productVariationPrice,
      'productVariationOldPrice': productVariationOldPrice,
      'productVariationCurrencyPrice': productVariationCurrencyPrice,
      'productVariationOldCurrencyPrice': productVariationOldCurrencyPrice,
      'variationStock': variationStock,
      'flatShippingCost': flatShippingCost,
      'numOfItems': numOfItems,
    };
  }
}
