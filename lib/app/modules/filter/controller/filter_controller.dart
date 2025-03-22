import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  final selectedOption = "".obs;
  final selectedBrandIndex = 0.obs;
  final brandIndexList = <String>[];

  // final variationIndexList = <String>[];
  final variationObjectList = <dynamic>[];
  String? encodeVaritionObject;

  String? brands;
  String? homeBrands;

  final minPriceTextController = TextEditingController();
  final maxPriceTextController = TextEditingController();

  RangeValues currentRangeValues = RangeValues(0, 0);
  int? minRange;
  int? maxRange;

  final _copyVariationObjectList = <dynamic>[];
  List<dynamic> get copyVariationObjectList => _copyVariationObjectList;

  updateCopyVariationList() {
    _copyVariationObjectList.clear();
    _copyVariationObjectList.addAll(variationObjectList);
  }

  updateVariationList() {
    variationObjectList.clear();
    variationObjectList.addAll(_copyVariationObjectList);
  }


  addBrandId(String id) {
    if (brandIndexList.contains(id)) {
      brandIndexList.remove(id);
      brands = brandIndexList.toString();
    } else {
      brandIndexList.add(id);
      brands = brandIndexList.toString();
    }
  }

  // addVariationId(dynamic variationObject) {
  // String productAttributeId = variationObject['attribute'].toString();
  // String productOptionId = variationObject['option'].toString();
  //
  // final attributeExists = variationObjectList.any(
  //       (item) => item['attribute'] == productAttributeId && item['option'] == productOptionId,
  // );
  //
  // if (attributeExists) {
  //   variationIndexList.remove(productOptionId);
  // } else {
  //   variationIndexList.add(productOptionId);
  // }
  // }

  bool checkVariationId(dynamic variationObject) {
    final productAttributeId = variationObject['attribute'];
    final productOptionId = variationObject['option'];

    final attributeExists = variationObjectList.any(
          (item) => item['attribute'] == productAttributeId && item['option'] == productOptionId,
    );

    return attributeExists;
  }


  // addVariationId(String productOptionId) {
  //   if (variationIndexList.contains(productOptionId)) {
  //     variationIndexList.remove(productOptionId);
  //   } else {
  //     variationIndexList.add(productOptionId);
  //   }
  // }

  void addVariationObject(variationObject) {
    final int? incomingAttribute =
    int.tryParse(variationObject['attribute'].toString());
    final int? incomingOption =
    int.tryParse(variationObject['option'].toString());

    bool exists = variationObjectList.any((item) =>
    item['attribute'] is int &&
        item['option'] is int &&
        item['attribute'] == incomingAttribute &&
        item['option'] == incomingOption);

    if (exists) {
      variationObjectList.removeWhere((item) =>
      item['attribute'] is int &&
          item['option'] is int &&
          item['attribute'] == incomingAttribute &&
          item['option'] == incomingOption);
      // encodeVaritionObject = jsonEncode(variationObjectList).toString();
    } else {
      variationObjectList.add({
        'attribute': incomingAttribute,
        'option': incomingOption,
      });
      // encodeVaritionObject = jsonEncode(variationObjectList).toString();
    }
  }

  void addCollectionVariationObject(variationObject) {
    final int? incomingAttribute =
    int.tryParse(variationObject['attribute'].toString());
    final int? incomingOption =
    int.tryParse(variationObject['option'].toString());

    bool exists = variationObjectList.any((item) =>
    item['attribute'] is int &&
        item['option'] is int &&
        item['attribute'] == incomingAttribute &&
        item['option'] == incomingOption);

    if (exists) {
      variationObjectList.removeWhere((item) =>
      item['attribute'] is int &&
          item['option'] is int &&
          item['attribute'] == incomingAttribute &&
          item['option'] == incomingOption);
      encodeVaritionObject = jsonEncode(variationObjectList).toString();
    } else {
      variationObjectList.add({
        'attribute': incomingAttribute,
        'option': incomingOption,
      });
      encodeVaritionObject = jsonEncode(variationObjectList).toString();
    }
  }

  addHomeBrandId(String id) {
    homeBrands = "[${id.toString()}]";
  }

  void setRange() {
    minRange = currentRangeValues.start.round();
    maxRange = currentRangeValues.end.round();
  }

  setVariations() {
    encodeVaritionObject = jsonEncode(variationObjectList).toString();
    updateCopyVariationList();
  }

  resetFilter() {
    selectedOption.value = "";
    homeBrands = "";
    brands = "";
    encodeVaritionObject = "";
    variationObjectList.clear();
    // variationIndexList.clear();
    _copyVariationObjectList.clear();
    brandIndexList.clear();
    selectedBrandIndex.value = -1;
    minRange = null;
    maxRange = null;
    currentRangeValues = RangeValues(0, 0);
    minPriceTextController.text = "0";
    maxPriceTextController.text = "0";
  }
}
