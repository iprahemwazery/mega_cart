import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mega_cart/features/auth/login/cubit/login_cubit.dart';
import 'package:mega_cart/features/auth/login/cubit/login_state.dart';
import 'package:mega_cart/features/auth/widget/text_field.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final LoginState state;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        CustomTextField(
          labelText: 'emailAddress'.tr,
          prefixIcon: Icon(
            Icons.email_outlined,
            color: theme.colorScheme.primary,
            size: 20.sp,
          ),
          obscureText: false,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          errorText: state.emailError,
        ),
        SizedBox(height: 25.h),
        CustomTextField(
          labelText: 'password'.tr,
          prefixIcon: Icon(
            Icons.lock_open_outlined,
            color: theme.colorScheme.primary,
            size: 20.sp,
          ),
          obscureText: state.isPasswordObscured,
          controller: passwordController,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          suffixIcon: IconButton(
            onPressed: () =>
                context.read<LoginCubit>().togglePasswordVisibility(),
            icon: Icon(
              state.isPasswordObscured
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: theme.colorScheme.onSurfaceVariant,
              size: 20.sp,
            ),
          ),
          errorText: state.passwordError,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // TODO: Implement forgot password
            },
            child: Text(
              'forgotPassword'.tr,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 13.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
