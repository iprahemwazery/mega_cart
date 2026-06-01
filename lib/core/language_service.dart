import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageService {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  final _box = GetStorage();
  final _key = 'languageCode';

  // الحصول على اللغة الحالية (الافتراضي إنجليزية)
  Locale get locale {
    final code = _box.read(_key) ?? 'en';
    return Locale(code);
  }

  // تغيير اللغة وحفظها
  void changeLanguage(String langCode) {
    Get.updateLocale(Locale(langCode));
    _box.write(_key, langCode);
  }
}
