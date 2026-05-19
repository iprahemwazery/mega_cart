import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/NetWork/api_constans.dart';
import 'package:mega_cart/core/app_router.dart';
import 'package:mega_cart/core/customs/snackbar.dart';
import 'package:mega_cart/features/splashScreen/view/session_manager.dart';
import 'package:mega_cart/features/auth/widget/text_field.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100.h),
                Text(
                  'Login Screen',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24.h),
                CustomTextField(
                  labelText: 'Email',
                  obscureText: false,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (!GetUtils.isEmail(value)) return 'Enter a valid email';
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  labelText: 'Password',
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
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _loginUser,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Login'),
                  ),
                ),
                SizedBox(height: 16.h),
                TextButton(
                  onPressed: () {},
                  child: const Text('Forgot Password?'),
                ),
                SizedBox(height: 16.h),
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.register);
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
