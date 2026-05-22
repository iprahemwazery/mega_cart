import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/NetWork/api_constans.dart';
import 'package:mega_cart/core/app_router.dart';
import 'package:mega_cart/features/splashScreen/view/session_manager.dart';
import 'package:mega_cart/features/auth/widget/text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordObscured = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final data = {
      'email': _emailController.text.trim(),
      'password': _passwordController.text,
    };

    try {
      final dio = Dio();
      debugPrint('login request: ${data.toString()}');
      final response = await dio.post(
        ApiConstans.baseUrl + ApiConstans.login,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      debugPrint('login response: ${response.statusCode} ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        String token = 'dummy_token';
        if (data is Map) {
          token =
              data['token'] ??
              data['accessToken'] ??
              data['authToken'] ??
              'dummy_token';
        }

        await SessionManager.setLoggedIn(token, _emailController.text.trim());

        Get.snackbar(
          'Success',
          'تم تسجيل الدخول بنجاح',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed(AppRoutes.root);
      } else {
        Get.snackbar(
          'Error',
          response.data.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on DioException catch (error) {
      String message = 'حدث خطأ أثناء تسجيل الدخول';
      debugPrint(
        'login error: ${error.response?.statusCode} ${error.response?.data}',
      );
      if (error.response != null && error.response?.data != null) {
        message = error.response?.data.toString() ?? message;
      }
      Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
    } catch (error) {
      Get.snackbar(
        'Error',
        'فشل الاتصال بالخادم',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80.h),
                  // Brand Logo Section
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'MEGA',
                          style: GoogleFonts.playball(
                            fontSize: 48.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        Container(
                          height: 1.5.h,
                          width: 40.w,
                          color: const Color(0xFF1A1A1A),
                        ),
                        Text(
                          'CART',
                          style: GoogleFonts.montserrat(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 8,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 70.h),
                  Text(
                    'Welcome Back',
                    style: GoogleFonts.montserrat(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Enter your credentials to continue',
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                  SizedBox(height: 40.h),
                  // Input Fields
                  CustomTextField(
                    labelText: 'Email Address',
                    prefixIcon: Icon(
                      // استخدام prefixIcon
                      Icons.email_outlined,
                      color: const Color(0xFF1A1A1A),
                      size: 20.sp,
                    ),
                    obscureText: false,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Required';
                      if (!GetUtils.isEmail(value)) return 'Invalid email';
                      return null;
                    },
                  ),
                  SizedBox(height: 25.h),
                  CustomTextField(
                    labelText: 'Password',
                    prefixIcon: Icon(
                      // استخدام prefixIcon
                      Icons.lock_open_outlined,
                      color: const Color(0xFF1A1A1A),
                      size: 20.sp,
                    ),
                    obscureText: _isPasswordObscured,
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordObscured = !_isPasswordObscured;
                        });
                      },
                      icon: Icon(
                        _isPasswordObscured
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey[500],
                        size: 20,
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 60.h,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF121212),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Sign In',
                              style: GoogleFonts.montserrat(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  // Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "New here? ",
                        style: GoogleFonts.montserrat(
                          // خط النص
                          color: Colors.grey[600],
                          fontSize: 14.sp,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.register),
                        child: Text(
                          "Create Account",
                          style: GoogleFonts.montserrat(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1A1A),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
