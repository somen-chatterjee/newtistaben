// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopperz/app/modules/auth/controller/auth_controler.dart';

class DeviceToken {
  AuthController controller = Get.put(AuthController());
  Future<String?> getDeviceToken() async {
    String? deviceToken = '@';
    try {
      deviceToken = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      print(e.toString());
    }
    if (deviceToken != null) {
      debugPrint('--------Device Token---------- ' + deviceToken);
      controller.postDeviceToken(deviceToken);
    }
    return deviceToken;
  }


  Future<String?> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // or androidInfo.androidId
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // Unique ID on iOS
    } else {
      return null;
    }
  }

}

