// To parse this JSON data, do
//
//     final applyCoupon = applyCouponFromJson(jsonString);

import 'dart:convert';

import 'package:shopperz/app/modules/cart/model/cart_model.dart';

ApplyCoupon applyCouponFromJson(String str) =>
    ApplyCoupon.fromJson(json.decode(str));

String applyCouponToJson(ApplyCoupon data) => json.encode(data.toJson());

class ApplyCoupon {
  final Data? data;

  ApplyCoupon({
    this.data,
  });

  factory ApplyCoupon.fromJson(Map<String, dynamic> json) => ApplyCoupon(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  final int? id;
  final String? code;
  dynamic discount;
  final String? flatDiscount;
  dynamic convertDiscount;
  final String? currencyDiscount;
  final Product? product;


  Data({
    this.id,
    this.code,
    this.discount,
    this.flatDiscount,
    this.convertDiscount,
    this.currencyDiscount,
    this.product
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        code: json["code"],
        discount: json["discount"],
        flatDiscount: json["flat_discount"],
        convertDiscount: json["convert_discount"],
        currencyDiscount: json["currency_discount"],
      product: json["product"] == null ? null : Product.fromJson(json["product"]),
   );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "discount": discount,
        "flat_discount": flatDiscount,
        "convert_discount": convertDiscount,
        "currency_discount": currencyDiscount,
    "product": product?.toJson(),
      };
}

class Product {
  int? id;
  String? name;
  dynamic price;
  String? image;
  String? variationNames;
  int? variationId;
  String? sku;
  int? stock;
  List<dynamic>? taxes;
  Shipping? shipping;
  int? quantity;
  dynamic discount;
  dynamic oldPrice;
  dynamic totalTax;
  dynamic subtotal;
  dynamic total;
  dynamic totalPrice;

  Product(
      {this.id,
        this.name,
        this.price,
        this.image,
        this.variationNames,
        this.variationId,
        this.sku,
        this.stock,
        this.taxes,
        this.shipping,
        this.quantity,
        this.discount,
        this.oldPrice,
        this.totalTax,
        this.subtotal,
        this.total,
        this.totalPrice});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    image = json['image'];
    variationNames = json['variation_names'];
    variationId = json['variation_id'];
    sku = json['sku'];
    stock = json['stock'];
    taxes = json['taxes'];
    shipping = json['shipping'] != null
        ? Shipping.fromJson(json['shipping'])
        : null;
    quantity = json['quantity'];
    discount = json['discount'];
    oldPrice = json['old_price'];
    totalTax = json['total_tax'];
    subtotal = json['subtotal'];
    total = json['total'];
    totalPrice = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['image'] = image;
    data['variation_names'] = variationNames;
    data['variation_id'] = variationId;
    data['sku'] = sku;
    data['stock'] = stock;
    if (taxes != null) {
      data['taxes'] = taxes!.map((v) => v.toJson()).toList();
    }
    if (shipping != null) {
      data['shipping'] = shipping!.toJson();
    }
    data['quantity'] = quantity;
    data['discount'] = discount;
    data['old_price'] = oldPrice;
    data['total_tax'] = totalTax;
    data['subtotal'] = subtotal;
    data['total'] = total;
    data['total_price'] = totalPrice;
    return data;
  }
}

class Shipping {
  int? shippingType;
  String? shippingCost;
  int? isProductQuantityMultiply;

  Shipping(
      {this.shippingType, this.shippingCost, this.isProductQuantityMultiply});

  Shipping.fromJson(Map<String, dynamic> json) {
    shippingType = json['shipping_type'];
    shippingCost = json['shipping_cost'];
    isProductQuantityMultiply = json['is_product_quantity_multiply'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shipping_type'] = shippingType;
    data['shipping_cost'] = shippingCost;
    data['is_product_quantity_multiply'] = isProductQuantityMultiply;
    return data;
  }
}
