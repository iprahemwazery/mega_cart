import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mega_cart/core/NetWork/api_constans.dart';
import 'package:mega_cart/core/app_router.dart';
import 'package:mega_cart/core/language_service.dart';
import 'package:mega_cart/core/theme_service.dart';
import 'package:mega_cart/features/CheckOut/cubit/checkout_cubit.dart';
import 'package:mega_cart/features/favorites/cubit/favorites_cubit.dart';
import 'package:mega_cart/features/auth/login/view/auth_repository_impl.dart';
import 'package:mega_cart/core/NetWork/order_controller.dart';
import 'package:mega_cart/features/home/cubit/category_cubit.dart';
import 'package:mega_cart/features/home/controller/home_repository_impl.dart';
import 'package:mega_cart/features/order/cubit/order_cubit.dart';
import 'package:mega_cart/features/profile/cubit/profile_cubit.dart';
import 'package:mega_cart/features/profile/data/profile_repository.dart';
import 'package:mega_cart/features/profile/widget/user_repository.dart';
import 'package:mega_cart/features/singelProfuct/data/product_repository.dart';
import 'package:mega_cart/core/NetWork/api_service.dart';
import 'package:mega_cart/features/home/cubit/home_cubit.dart';
import 'package:mega_cart/features/cart/cubit/cart_cubit.dart';
import 'package:mega_cart/features/auth/login/cubit/login_cubit.dart';
import 'package:mega_cart/features/auth/signup/cubit/signup_cubit.dart';
import 'package:mega_cart/features/cart/data/cart_repository_impl.dart';
import 'package:mega_cart/core/l10n/app_translations.dart';
import 'package:mega_cart/core/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstans.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json'},
      ),
    );
    Get.put(dio);
    final apiService = ApiService(dio);
    Get.put(apiService);

    return MultiBlocProvider(
      providers: [
        //auth
        //Login
        BlocProvider(create: (context) => LoginCubit(AuthRepositoryImpl(dio))),
        //Signup
        BlocProvider(create: (context) => SignupCubit(AuthRepositoryImpl(dio))),
        //home
        BlocProvider(
          create: (context) =>
              HomeCubit(HomeRepositoryImpl(apiService))..loadProducts(),
        ),
        //category
        BlocProvider(create: (context) => CategoryCubit()..getCategories()),
        //cart
        BlocProvider(
          create: (context) => CartCubit(
            CartRepositoryImpl(dio),
            ProductRepositoryImpl(apiService),
          ),
        ),

        //favorites
        BlocProvider(create: (context) => FavoritesCubit()),

        //profile
        BlocProvider(
          create: (context) =>
              ProfileCubit(ProfileRepositoryImpl() as UserRepository),
        ),

        //checkout
        BlocProvider(
          create: (context) => CheckoutCubit(Get.put(OrderController())),
        ),

        //orders
        BlocProvider(create: (context) => OrderCubit()..loadOrders()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Mega Cart',
            theme: ThemeService.lightTheme,
            darkTheme: ThemeService.darkTheme,
            themeMode: ThemeService().theme,
            initialBinding: BindingsBuilder(() {}),
            locale: LanguageService().locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            translations: AppTranslations(),
            fallbackLocale: const Locale('en'),
            initialRoute: AppRoutes.splash,
            getPages: AppPages.pages,
          );
        },
      ),
    );
  }
}
