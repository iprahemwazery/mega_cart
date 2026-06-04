import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mega_cart/features/auth/signup/cubit/signup_cubit.dart';
import 'package:mega_cart/features/auth/signup/cubit/signup_state.dart';
import 'package:mega_cart/features/auth/widget/text_field.dart';

class SignupForm extends StatelessWidget {
  final SignupState state;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const SignupForm({
    super.key,
    required this.state,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                labelText: 'firstName'.tr,
                prefixIcon: Icon(
                  Icons.person_outline,
                  size: 20.sp,
                  color: theme.colorScheme.primary,
                ),
                controller: firstNameController,
                errorText: state.firstNameError,
                obscureText: false,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: CustomTextField(
                labelText: 'lastName'.tr,
                prefixIcon: Icon(
                  Icons.person_outline,
                  size: 20.sp,
                  color: theme.colorScheme.primary,
                ),
                controller: lastNameController,
                errorText: state.lastNameError,
                obscureText: false,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        CustomTextField(
          labelText: 'emailAddress'.tr,
          prefixIcon: Icon(
            Icons.email_outlined,
            size: 20.sp,
            color: theme.colorScheme.primary,
          ),
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          errorText: state.emailError,
          obscureText: false,
        ),
        SizedBox(height: 20.h),
        CustomTextField(
          labelText: 'password'.tr,
          prefixIcon: Icon(
            Icons.lock_open_outlined,
            size: 20.sp,
            color: theme.colorScheme.primary,
          ),
          obscureText: state.isPasswordObscured,
          controller: passwordController,
          suffixIcon: IconButton(
            onPressed: () =>
                context.read<SignupCubit>().togglePasswordVisibility(),
            icon: Icon(
              state.isPasswordObscured
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 20.sp,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          errorText: state.passwordError,
        ),
        SizedBox(height: 20.h),
        CustomTextField(
          labelText: 'confirmPassword'.tr,
          prefixIcon: Icon(
            Icons.lock_outline,
            size: 20.sp,
            color: theme.colorScheme.primary,
          ),
          obscureText: state.isConfirmPasswordObscured,
          controller: confirmPasswordController,
          suffixIcon: IconButton(
            onPressed: () =>
                context.read<SignupCubit>().toggleConfirmPasswordVisibility(),
            icon: Icon(
              state.isConfirmPasswordObscured
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 20.sp,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          errorText: state.confirmPasswordError,
        ),
      ],
    );
  }
}
