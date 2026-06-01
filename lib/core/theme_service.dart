import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeService {
  // تحويل الكلاس إلى Singleton لضمان استقرار الأداء
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  final _box = GetStorage();
  final _key = 'themeMode';

  // تعريف ستايل النصوص الموحد للتطبيق
  static TextTheme _buildTextTheme(Brightness brightness) {
    // نستخدم Montserrat كخط أساسي لواجهة المستخدم
    final baseTheme = GoogleFonts.montserratTextTheme(
      ThemeData(brightness: brightness).textTheme,
    );

    return baseTheme.copyWith(
      // يمكنك تخصيص أحجام محددة هنا لتكون ثابتة في كل التطبيق
      displayLarge: baseTheme.displayLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: baseTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w800,
        fontSize: 24,
      ),
      titleMedium: baseTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      bodyMedium: baseTheme.bodyMedium?.copyWith(fontSize: 14),
      labelLarge: baseTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),
    );
  }

  // استخدام FlexColorScheme للثيم الفاتح
  static final lightTheme = FlexThemeData.light(
    scheme: FlexScheme
        .blue, // يمكنك الاختيار من بين عشرات الثيمات الجاهزة (mandyRed, vesuviusBurn, etc.)
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 7,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
      alignedDropdown: true,
      useInputDecoratorThemeInDialogs: true,
      defaultRadius: 12.0, // توحيد انحناء الحواف في كل التطبيق
      // تخصيص الأزرار عالمياً
      elevatedButtonSchemeColor: SchemeColor.primary,
      elevatedButtonSecondarySchemeColor: SchemeColor.onPrimary,
      outlinedButtonSchemeColor: SchemeColor.primary,
      textButtonSchemeColor: SchemeColor.primary,
      filledButtonSchemeColor: SchemeColor.primary,
      elevatedButtonElevation: 2.0,
      buttonPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      // تخصيص الكروت عالمياً
      cardRadius: 12.0,
      cardElevation: 0.5,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    textTheme: _buildTextTheme(Brightness.light),
  );

  // استخدام FlexColorScheme للثيم الغامق
  static final darkTheme = FlexThemeData.dark(
    scheme: FlexScheme.blue,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 13,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
      alignedDropdown: true,
      useInputDecoratorThemeInDialogs: true,
      defaultRadius: 12.0,
      // تخصيص الأزرار عالمياً في الوضع الليلي
      elevatedButtonSchemeColor: SchemeColor.primary,
      elevatedButtonSecondarySchemeColor: SchemeColor.onPrimary,
      outlinedButtonSchemeColor: SchemeColor.primary,
      textButtonSchemeColor: SchemeColor.primary,
      filledButtonSchemeColor: SchemeColor.primary,
      elevatedButtonElevation: 1.0,
      // تخصيص الكروت في الوضع الليلي
      cardRadius: 12.0,
      cardElevation: 0.0,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    textTheme: _buildTextTheme(Brightness.dark),
  );

  // يمكنك أيضاً إضافة ألوان "مستقلة" إذا أردت استخدامها مباشرة
  Color get cardColor => isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
  Color get dividerColor => isDarkMode ? Colors.white24 : Colors.black12;

  // الحصول على الـ ThemeMode الحالي (System, Light, Dark)
  ThemeMode get theme {
    final value = _box.read(_key);
    if (value == 'dark') return ThemeMode.dark;
    if (value == 'light') return ThemeMode.light;
    return ThemeMode.system;
  }

  // التحقق هل الوضع الحالي هو الليلي
  bool get isDarkMode => Get.isDarkMode;

  // حفظ الاختيار الجديد في التخزين الدائم
  void _saveThemeToBox(ThemeMode mode) => _box.write(_key, mode.name);

  // الوظيفة الأساسية لتغيير الثيم
  void changeThemeMode(ThemeMode mode) {
    Get.changeThemeMode(mode);
    _saveThemeToBox(mode);
  }
}
