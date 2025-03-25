// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:get/get.dart';
import 'package:shopperz/app/modules/cart/model/product_model.dart';

class CartModel {
  final ProductModel product;
  final RxInt quantity;
  final int variationId;
  final String shippingCharge;
  final String? finalVariationString;
  final String? sku;
  dynamic taxObject;
  dynamic stock;
  dynamic shippingObject;
  double? totalProductTax;
  String? flatShippingCharge;
  dynamic variationPrice;
  dynamic variationOldPrice;
  dynamic variationCurrencyPrice;
  dynamic variationOldCurrencyPrice;
  int? variationStock;

  CartModel({
    required this.product,
    int quantity = 1,
    this.variationId = 0,
    this.shippingCharge = "0",
    this.finalVariationString,
    this.sku,
    this.taxObject,
    this.stock,
    this.shippingObject,
    this.totalProductTax,
    this.flatShippingCharge,
    this.variationPrice,
    this.variationOldPrice,
    this.variationCurrencyPrice,
    this.variationOldCurrencyPrice,
    this.variationStock,
  }) : quantity = quantity.obs;

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity.value,
      'variationId': variationId,
      'shippingCharge': shippingCharge,
      'finalVariationString': finalVariationString,
      'sku': sku,
      'taxObject': taxObject,
      'stock': stock,
      'shippingObject': shippingObject,
      'totalProductTax': totalProductTax,
      'flatShippingCharge': flatShippingCharge,
      'variationPrice': variationPrice,
      'variationOldPrice': variationOldPrice,
      'variationCurrencyPrice': variationCurrencyPrice,
      'variationOldCurrencyPrice': variationOldCurrencyPrice,
      'variationStock': variationStock,
    };
  }
}
