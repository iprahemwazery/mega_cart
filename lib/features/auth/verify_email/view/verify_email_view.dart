import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/app_router.dart';
import 'package:mega_cart/features/auth/verify_email/cubit/verify_email_cubit.dart';
import 'package:mega_cart/features/auth/verify_email/cubit/verify_email_state.dart';
import 'package:mega_cart/features/auth/widget/text_field.dart';

import 'package:mega_cart/features/auth/login/view/auth_repository_impl.dart';
import 'package:dio/dio.dart';

class VerifyEmailView extends StatelessWidget {
  VerifyEmailView({super.key})
    : _emailController = TextEditingController(
        text: Get.arguments is Map
            ? (Get.arguments as Map)['email'] as String?
            : null,
      );

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController;
  final TextEditingController _otpController = TextEditingController();

  void _onVerifyPressed(BuildContext context) {
    context.read<VerifyEmailCubit>().verifyEmail(
      _emailController.text,
      _otpController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerifyEmailCubit(AuthRepositoryImpl(Dio())),
      child: BlocConsumer<VerifyEmailCubit, VerifyEmailState>(
        listener: (context, state) {
          if (state.status == VerifyEmailStatus.success) {
            Get.snackbar(
              'Success',
              'تم التحقق من البريد الإلكتروني بنجاح',
              snackPosition: SnackPosition.BOTTOM,
            );
            Get.offAllNamed(AppRoutes.home);
          } else if (state.status == VerifyEmailStatus.failure &&
              state.errorMessage != null) {
            Get.snackbar(
              'Error',
              state.errorMessage!.tr,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
        builder: (context, state) {
          return _buildUI(context, state);
        },
      ),
    );
  }

  Widget _buildUI(BuildContext context, VerifyEmailState state) {
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
                  errorText: state.emailError,
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  labelText: 'OTP',
                  obscureText: false,
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  errorText: state.otpError,
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.status == VerifyEmailStatus.loading
                        ? null
                        : () => _onVerifyPressed(context),
                    child: state.status == VerifyEmailStatus.loading
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
