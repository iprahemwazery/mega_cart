import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/NetWork/api_constans.dart';
import 'package:mega_cart/core/app_router.dart';
import 'package:mega_cart/core/customs/snackbar.dart';
import 'package:mega_cart/core/services/session_manager.dart';
import 'package:mega_cart/features/auth/widget/text_field.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final email = Get.arguments is Map
        ? (Get.arguments as Map)['email'] as String?
        : null;
    _emailController = TextEditingController(text: email ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyEmail() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final data = {
      'email': _emailController.text.trim(),
      'otp': _otpController.text.trim(),
    };

    try {
      final dio = Dio();
      final response = await dio.post(
        ApiConstans.baseUrl + ApiConstans.verifyEmail,
        data: jsonEncode(data),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      debugPrint('verify-email request: ${jsonEncode(data)}');
      debugPrint(
        'verify-email response: ${response.statusCode} ${response.data}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        String token = 'dummy_token_after_verification';
        if (data is Map) {
          token = data['token'] ?? 'dummy_token_after_verification';
        }

        await SessionManager.setLoggedIn(token, _emailController.text.trim());

        Get.snackbar(
          'Success',
          'تم التحقق من البريد الإلكتروني بنجاح',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.snackbar(
          'Error',
          response.data.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on DioException catch (error) {
      String message = 'حدث خطأ أثناء التحقق';
      debugPrint(
        'verify-email error: ${error.response?.statusCode} ${error.response?.data}',
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
                  'Verify Email',
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
                  labelText: 'OTP',
                  obscureText: false,
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _verifyEmail,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Verify Email'),
                  ),
                ),
                SizedBox(height: 24.h),
                TextButton(onPressed: Get.back, child: const Text('Back')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
