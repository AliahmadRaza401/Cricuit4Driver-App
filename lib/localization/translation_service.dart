import 'package:circuit4driver/localization/ar_DZ.dart';
import 'package:circuit4driver/localization/en_US.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class TranslationService extends Translations {
  // static Locale? get locale => Get.deviceLocale;
  // static const fallbackLocale = Locale('en', 'US');
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'ar_DZ': arDZ,
      };
}


