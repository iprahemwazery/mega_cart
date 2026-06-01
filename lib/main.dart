import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mega_cart/core/app_router.dart';
import 'package:mega_cart/core/language_service.dart';
import 'package:mega_cart/core/theme_service.dart';
import 'package:mega_cart/l10n/app_translations.dart'; // Import the new AppTranslations
import 'package:mega_cart/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeService.lightTheme,
          darkTheme: ThemeService.darkTheme,
          themeMode: ThemeService().theme, // This line was already correct
          locale: LanguageService().locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          translations: AppTranslations(), // ربط ملف الترجمات الخاص بـ GetX
          fallbackLocale: const Locale(
            'en',
          ), // لغة احتياطية في حال عدم وجود ترجمة
          initialRoute: AppRoutes.splash,
          getPages: AppPages.pages,
        );
      },
    );
  }
}
