import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:shopperz/app/database/cart_db_helper.dart';
import 'package:shopperz/app/modules/auth/controller/auth_controler.dart';
import 'package:shopperz/app/modules/cart/model/product_model.dart';
import 'package:shopperz/app/modules/shipping/controller/show_address_controller.dart';
import 'package:shopperz/main.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../widgets/custom_snackbar.dart';
import '../model/cart_model.dart';

class CartController extends GetxController {
  final showAddressController = Get.put(ShowAddressController());
  final authController = Get.put(AuthController());
  final cartItems = <CartModel>[].obs;
  final numOfItems = 1.obs;
  final quantityTax = 0.0.obs;
  final taxRate = 0.0.obs;
  double productShippingCharge = 0.0;
  String shippingMethod = "0";
  final shippingAreaCost = 0.0.obs;
  double totalIndividualProductTax = 0.0;
  double flatRateShippingCost = 0.0;
  double multiplyShippingAmount = 0.0;
  bool isProductAdded = false;

  // initialize database
  final dbHelper = DatabaseHelper();

  @override
  onInit() {
    authController.getSetting();
    dbHelper.database;
    getAllCartProducts();
    super.onInit();
  }

  decrement() {
    if (numOfItems.value > 1) {
      numOfItems.value--;
    }
  }

  Future<void> addItem(
      {required ProductModel product,
      int? variationId,
      String? shippingAmount,
      String? finalVariation,
      String? sku,
      dynamic taxJson,
      dynamic stock,
      dynamic shipping,
      double? totalTax,
      double? totalPrice,
      dynamic productVariationPrice,
      dynamic productVariationOldPrice,
      dynamic productVariationCurrencyPrice,
      dynamic productVariationOldCurrencyPrice,
      int? variationStock,
      String? flatShippingCost}) async {
    isProductAdded = false;

    final maxQuantity = 10000;

    //  int.tryParse(
    //         product.data?.maximumPurchaseQuantity?.toString() ?? "0") ??
    //     0;

    for (var item in cartItems) {
      if (item.product.data?.id == product.data?.id &&
          item.variationId == variationId) {
        final newQuantity = item.quantity.value + numOfItems.value;

        if (newQuantity > maxQuantity) {
          customSnackbar("INFO".tr, "YOU_ALREADY_ADDED_THE_MAXIMUM_QUANTITY".tr,
              AppColor.redColor);
          return;
        } else {
          item.quantity.value = newQuantity;
          isProductAdded = true;
          await dbHelper.insertCartItem(item);
          return;
        }
      }
    }

    var cartData = CartModel(
      product: product,
      variationId: variationId ?? 0,
      quantity: numOfItems.value,
      shippingCharge: shippingAmount ?? "0",
      finalVariationString: finalVariation ?? "null",
      sku: sku ?? "null",
      taxObject: taxJson,
      stock: stock,
      variationPrice: productVariationPrice,
      variationOldPrice: productVariationOldPrice,
      variationCurrencyPrice: productVariationCurrencyPrice,
      variationOldCurrencyPrice: productVariationOldCurrencyPrice,
      shippingObject: shipping,
      totalProductTax: totalTax,
      flatShippingCharge: flatShippingCost,
      variationStock: variationStock,
    );

    log("somen ${cartData.quantity}");

    // for first time insert on table
    int result = await dbHelper.insertCartItem(cartData);

    if(result != -1) {
      cartItems.add(cartData);
    }

    isProductAdded = true;
  }

  void incrementItem(CartModel cartItem) async{
    if (cartItem.variationStock != -1) {
      if (cartItem.variationStock! < 0) {
      } else {
        if (cartItem.quantity.value < cartItem.variationStock!) {
          // maximum purchase quantity null
          if (cartItem.product.data!.maximumPurchaseQuantity == null) {
            cartItem.quantity.value++;
          } else {
            if (cartItem.quantity.value <
                cartItem.product.data!.maximumPurchaseQuantity!) {
              cartItem.quantity.value++;
            } else {
              customSnackbar(
                  "INFO".tr,
                  "MAXIMUM_PURCHASE_QUANTITY_LIMIT_EXCEEDED".tr,
                  AppColor.redColor);
            }
          }
        } else {}
      }
    } else {
      if (cartItem.product.data!.stock! > 0) {
        if (cartItem.quantity < cartItem.product.data!.stock!) {
          // maximum purchase qunatity null
          if (cartItem.product.data!.maximumPurchaseQuantity == null) {
            cartItem.quantity.value++;
            update();
          } else {
            if (cartItem.quantity <
                cartItem.product.data!.maximumPurchaseQuantity!) {
              cartItem.quantity.value++;
              update();
            } else {
              customSnackbar(
                  "INFO".tr,
                  "MAXIMUM_PURCHASE_QUANTITY_LIMIT_EXCEEDED".tr,
                  AppColor.redColor);
            }
          }
        }
      }
    }

    await dbHelper.insertCartItem(cartItem);
  }

  void decrementItem(CartModel cartItem) async{
    if (cartItem.quantity > 1) {
      cartItem.quantity.value--;
      decrementShippingCharge(cartItem);
    }

    await dbHelper.insertCartItem(cartItem);
  }

  int getQuantityForProduct(ProductModel product) {
    int quantity = 0;

    for (CartModel cartItem in cartItems) {
      if (cartItem.product.data?.id == product.data?.id) {
        quantity = cartItem.quantity.value;
        break;
      }
    }
    return quantity;
  }

  void removeFromCart(CartModel cartModel) async {
    var result = await dbHelper.deleteCartItem(cartModel.variationId);
    if(result != -1) {
      cartItems.remove(cartModel);
      quantityTax.value = 0.0;
      removeProductWiseShippingCharge(cartModel);
    }
  }

  int get totalItems {
    return cartItems.fold(0, (sum, item) => sum + item.quantity.value);
  }

  double get totalPrice {
    final totalPrice = 0.0.obs;
    for (var item in cartItems) {
      totalPrice.value +=
          (item.quantity * double.parse(item.variationPrice.toString()));
    }
    return totalPrice.value;
  }

  double get totalTax {
    double tTax = 0.0;
    for (var item in cartItems) {
      tTax += ((item.quantity * double.parse(item.variationPrice.toString())) /
              100) *
          item.totalProductTax!.toDouble();
    }
    return tTax;
  }

  calculateShippingCharge(
      {required String shippingMethodStatus,
      String? shippingType,
      String? isProductQntyMultiply,
      String? flatShippingCharge}) {
    productShippingCharge = 0;
    for (var item in cartItems) {
      if (shippingMethodStatus == "5") {
        shippingMethod = "5";
        if (item.product.data?.shipping?.shippingType == 10 &&
            item.product.data?.shipping?.isProductQuantityMultiply == 5) {
          productShippingCharge +=
              double.parse(item.shippingCharge) * item.quantity.value;
        }
        if (item.product.data?.shipping?.shippingType == 5) {}
        if (item.product.data?.shipping?.shippingType == 10 &&
            item.product.data?.shipping?.isProductQuantityMultiply == 10) {
          productShippingCharge += double.parse(item.shippingCharge);
        }
      }
      if (shippingMethodStatus == "10") {
        shippingMethod = "10";
        productShippingCharge =
            double.parse(item.flatShippingCharge.toString());
      }
      if (shippingMethodStatus == "15") {
        shippingMethod = "15";
      }
    }
  }

  areaWiseShippingCal() {
    if (shippingMethod == "15") {
      final selectedAddress = showAddressController.addressList.value.data?[
          showAddressController.selectedAddressIndex.value == -1
              ? 0
              : showAddressController.selectedAddressIndex.value];

      for (var area in showAddressController.areaShippingModel.value.data!) {
        if (selectedAddress!.country!.contains(area.country!) &&
            selectedAddress.state!.contains(area.state!) &&
            selectedAddress.city!.contains(area.city!)) {
          shippingAreaCost.value =
              double.parse(area.shippingCost?.toString() ?? "0");
          break;
        } else {
          shippingAreaCost.value = 0;
          shippingAreaCost.value = double.parse(authController
                  .settingModel?.data?.shippingSetupAreaWiseDefaultCost
                  .toString() ??
              "0");
        }
      }
    }
  }

  removeProductWiseShippingCharge(CartModel cartModel) {
    if (shippingMethod == "5") {
      if (cartModel.product.data?.shipping?.shippingType == 10 &&
          cartModel.product.data?.shipping?.isProductQuantityMultiply == 5) {
        productShippingCharge -=
            double.parse(cartModel.shippingCharge) * cartModel.quantity.value;
      }
      if (cartModel.product.data?.shipping?.shippingType == 5) {}
      if (cartModel.product.data?.shipping?.shippingType == 10 &&
          cartModel.product.data?.shipping?.isProductQuantityMultiply == 10) {
        productShippingCharge -= double.parse(cartModel.shippingCharge);
      }
    }
    if (shippingMethod == "10") {
      productShippingCharge -=
          double.parse(cartModel.flatShippingCharge.toString());
    }
  }

  incrementShippingCharge(CartModel cartModel) {
    if (shippingMethod == "5") {
      if (cartModel.product.data?.shipping?.shippingType == 10 &&
          cartModel.product.data?.shipping?.isProductQuantityMultiply == 5) {
        multiplyShippingAmount = double.parse(cartModel.shippingCharge);
        productShippingCharge += multiplyShippingAmount;
      }
      if (cartModel.product.data?.shipping?.shippingType == 5) {}
      if (cartModel.product.data?.shipping?.shippingType == 10 &&
          cartModel.product.data?.shipping?.isProductQuantityMultiply == 10) {}
    }
    if (shippingMethod == "10") {}
  }

  decrementShippingCharge(CartModel cartModel) {
    if (shippingMethod == "5") {
      if (cartModel.product.data?.shipping?.shippingType == 10 &&
          cartModel.product.data?.shipping?.isProductQuantityMultiply == 5) {
        productShippingCharge -= double.parse(cartModel.shippingCharge);
      }
      if (cartModel.product.data?.shipping?.shippingType == 5) {}
      if (cartModel.product.data?.shipping?.shippingType == 10 &&
          cartModel.product.data?.shipping?.isProductQuantityMultiply == 10) {}
    }
    if (shippingMethod == "10") {}
  }

  void getAllCartProducts() async {
    // if (box.read('isLogedIn') != false) {
    //   // TODO: need to implement api for cart data
    // } else {
      final allCartItems = await dbHelper.getCartItems();
      cartItems.clear();
      cartItems.addAll(allCartItems);
    // }
  }

  void removeAllCartData() async {
    await dbHelper.clearCart();
    cartItems.clear();
  }

}
