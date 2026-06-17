import 'package:dio/dio.dart';
import 'package:mega_cart/features/splashScreen/view/session_manager.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SessionManager.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      // Optionally, you can add logic here to clear the session and redirect to the login page
      // For example:
      // SessionManager.setLoggedOut();
      // Get.offAllNamed(AppRoutes.login); // Requires Get package
    }
    super.onError(err, handler);
  }
}
