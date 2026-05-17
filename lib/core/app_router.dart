import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:mega_cart/features/auth/login/view/login_view.dart';
import 'package:mega_cart/features/auth/signup/view/singup_view.dart';
import 'package:mega_cart/features/auth/verify_email/view/verify_email_view.dart';
import 'package:mega_cart/features/createProduct/view/create_product_view.dart';
import 'package:mega_cart/features/home/view/home_view.dart';
import 'package:mega_cart/features/splashScreen/view/splash_screen_view.dart';
import 'package:mega_cart/root.dart';
import 'package:mega_cart/features/singelProfuct/view/product_details_view.dart';

class AppRoutes {
  static const String home = '/home';
  static const String favourite = '/favourite';
  static const String cart = '/cart';
  static const String profile = '/profile';
  static const String detail = '/detail';
  static const String settings = '/settings';
  static const String root = '/root';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String allTours = '/all-tours';
  static const String orders = '/orders';
  static const String signup = '/signup';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';
  static const String createProduct = '/create-product';
  static const String productDetails = '/product-details';
}

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.login, page: () => const LoginView()),
    GetPage(name: AppRoutes.register, page: () => const SingupView()),
    GetPage(name: AppRoutes.verifyEmail, page: () => const VerifyEmailView()),
    GetPage(name: AppRoutes.forgotPassword, page: () => const LoginView()),
    GetPage(name: AppRoutes.splash, page: () => const SplashScreenView()),
    GetPage(name: AppRoutes.home, page: () => const HomeView()),
    GetPage(name: AppRoutes.root, page: () => const Root()),
    GetPage(name: AppRoutes.detail, page: () => const ProductDetailsView()),
    GetPage(name: AppRoutes.createProduct, page: () => CreateProductView()),
    GetPage(name: AppRoutes.productDetails, page: () => ProductDetailsView()),
  ];
}
