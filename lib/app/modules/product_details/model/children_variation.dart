// To parse this JSON data, do
//
//     final childrenVariationModel = childrenVariationModelFromJson(jsonString);

import 'dart:convert';

ChildrenVariationModel childrenVariationModelFromJson(String str) => ChildrenVariationModel.fromJson(json.decode(str));

String childrenVariationModelToJson(ChildrenVariationModel data) => json.encode(data.toJson());

class ChildrenVariationModel {
    final List<Datum>? data;

    ChildrenVariationModel({
        this.data,
    });

    factory ChildrenVariationModel.fromJson(Map<String, dynamic> json) => ChildrenVariationModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    final int? id;
    final String? name;
    final String? mainSku;
    final int? productAttributeId;
    final int? productAttributeOptionId;
    final String? productAttributeName;
    final String? productAttributeOptionName;
    final dynamic price;
    final String? currencyPrice;
    final int? oldPrice;
    final String? oldCurrencyPrice;
    final dynamic discount;
    final int? discountPercentage;
    final String? sku;
    final int? moq;
    final int? stock;
    int numOfItem;
    int? maximumPurchaseQuantity;
    List<String>? images;

    Datum({
        this.id,
        this.name,
        this.mainSku,
        this.productAttributeId,
        this.productAttributeOptionId,
        this.productAttributeName,
        this.productAttributeOptionName,
        this.price,
        this.currencyPrice,
        this.oldPrice,
        this.oldCurrencyPrice,
        this.discount,
        this.discountPercentage,
        this.sku,
        this.moq,
        this.stock,
        this.maximumPurchaseQuantity,
        this.numOfItem = 0,
        this.images,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        mainSku: json["main_sku"],
        productAttributeId: json["product_attribute_id"],
        productAttributeOptionId: json["product_attribute_option_id"],
        productAttributeName: json["product_attribute_name"],
        productAttributeOptionName: json["product_attribute_option_name"],
        price: json["price"],
        currencyPrice: json["currency_price"],
        oldPrice: json["old_price"],
        oldCurrencyPrice: json["old_currency_price"],
        discount: json["discount"],
        discountPercentage: json["discount_percentage"],
        sku: json["sku"],
        moq: json["moq"],
        stock: json["stock"],
        maximumPurchaseQuantity: json["maximum_purchase_quantity"],
        numOfItem: json["num_of_item"] ?? 0,
        images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "main_sku": mainSku,
        "product_attribute_id": productAttributeId,
        "product_attribute_option_id": productAttributeOptionId,
        "product_attribute_name": productAttributeName,
        "product_attribute_option_name": productAttributeOptionName,
        "price": price,
        "currency_price": currencyPrice,
        "old_price": oldPrice,
        "old_currency_price": oldCurrencyPrice,
        "discount": discount,
        "discount_percentage": discountPercentage,
        "sku": sku,
        "moq": moq,
        "stock": stock,
        "num_of_item": numOfItem,
        "maximum_purchase_quantity": maximumPurchaseQuantity,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    };
}
