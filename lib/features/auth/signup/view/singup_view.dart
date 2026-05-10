import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/NetWork/api_constans.dart';
import 'package:mega_cart/core/app_router.dart';
import 'package:mega_cart/features/auth/widget/text_field.dart';

class SingupView extends StatefulWidget {
  const SingupView({super.key});

  @override
  State<SingupView> createState() => _SingupViewState();
}

class _SingupViewState extends State<SingupView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordObscured = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final data = {
      'email': _emailController.text.trim(),
      'password': _passwordController.text,
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
    };

    try {
      final dio = Dio();
      debugPrint('register request: ${data.toString()}');
      final response = await dio.post(
        ApiConstans.baseUrl + ApiConstans.register,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      debugPrint('register response: ${response.statusCode} ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'تم تسجيل المستخدم بنجاح، ادخل رمز التحقق',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.toNamed(
          AppRoutes.verifyEmail,
          arguments: {'email': _emailController.text.trim()},
        );
      } else {
        Get.snackbar(
          'Error',
          response.data.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on DioException catch (error) {
      String message = 'حدث خطأ أثناء التسجيل';
      debugPrint(
        'register error: ${error.response?.statusCode} ${error.response?.data}',
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
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10.h),
                Text(
                  'Signup Screen',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 3.h),
                CustomTextField(
                  labelText: 'First Name',
                  obscureText: false,
                  controller: _firstNameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 2.h),
                CustomTextField(
                  labelText: 'Last Name',
                  obscureText: false,
                  controller: _lastNameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 2.h),
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
                SizedBox(height: 2.h),
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
                  validator: (value) {
                    final password = value ?? '';
                    if (password.isEmpty) {
                      return 'Password is required';
                    }
                    if (password.length < 8) {
                      return 'Password must be at least 8 chars';
                    }
                    if (!RegExp(r'[A-Z]').hasMatch(password)) {
                      return 'Password must contain at least one uppercase letter';
                    }
                    if (!RegExp(r'[a-z]').hasMatch(password)) {
                      return 'Password must contain at least one lowercase letter';
                    }
                    if (!RegExp(r'[0-9]').hasMatch(password)) {
                      return 'Password must contain at least one number';
                    }
                    if (!RegExp(
                      r'[!@#\$%\^&*(),.?":{}|<>]',
                    ).hasMatch(password)) {
                      return 'Password must contain at least one special character';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 4.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _registerUser,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Signup'),
                  ),
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
