import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/language_service.dart';
import 'package:mega_cart/core/theme_service.dart';

class SettingsController extends GetxController {
  var isNotificationsEnabled = true.obs;

  final currentThemeMode = ThemeService().theme.obs;

  // 1. متغير ملاحَظ لإدارة لغة التطبيق
  final currentLocale = LanguageService().locale.obs;

  // 2. متغير ملاحَظ لتشغيل الـ Switch في الواجهة
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = currentThemeMode.value == ThemeMode.dark;
  }

  void toggleNotifications(bool value) {
    isNotificationsEnabled.value = value;
  }

  void updateThemeMode(ThemeMode mode) {
    currentThemeMode.value = mode;
    isDarkMode.value = mode == ThemeMode.dark;
    ThemeService().changeThemeMode(mode);
  }

  // 3. دالة تبديل الوضع الداكن وحفظه
  void toggleTheme(bool value) {
    updateThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  // 4. تغيير لغة التطبيق وحفظها
  void changeLanguage(String langCode) {
    LanguageService().changeLanguage(langCode);
    currentLocale.value = Locale(langCode);
  }

  void changePassword() {}

  void showAboutApp() {}
}
