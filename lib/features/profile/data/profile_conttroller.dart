import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:mega_cart/core/app_router.dart';
import 'package:mega_cart/features/splashScreen/view/session_manager.dart';

class ProfileConttroller {
  String? email;
  bool isLoading = true;

  Future<void> loadUserProfile() async {
    isLoading = true;
    email = await SessionManager.getUserEmail();
    isLoading = false;
  }

  Future<void> logout() async {
    await SessionManager.setLoggedOut();
    Get.offAllNamed(AppRoutes.login);
  }
}
