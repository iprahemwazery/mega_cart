import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/app_router.dart';
import 'package:mega_cart/features/auth/login/cubit/login_cubit.dart';
import 'package:mega_cart/features/auth/login/cubit/login_state.dart';
import 'package:mega_cart/features/auth/login/widget/footer_section.dart';
import 'package:mega_cart/features/auth/login/widget/login_button.dart';
import 'package:mega_cart/features/auth/login/widget/login_form.dart';
import 'package:mega_cart/features/auth/login/widget/logo_header.dart';
import 'package:mega_cart/features/auth/login/widget/social_section.dart';
import 'package:mega_cart/features/auth/login/widget/welcome_section.dart';
import 'package:mega_cart/features/auth/widget/fade_in_delayed.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          Get.snackbar(
            'success'.tr,
            'loginSuccess'.tr,
            snackPosition: SnackPosition.BOTTOM,
          );
          Get.offAllNamed(AppRoutes.root);
        } else if (state.status == LoginStatus.failure) {
          Get.snackbar(
            'error'.tr,
            state.errorMessage?.tr ?? 'loginError'.tr,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      builder: (context, state) {
        return _buildUI(context, state);
      },
    );
  }

  void _onLoginPressed(BuildContext context) {
    context.read<LoginCubit>().login(
      _emailController.text,
      _passwordController.text,
    );
  }

  Widget _buildUI(BuildContext context, LoginState state) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withOpacity(0.12),
              theme.colorScheme.surface,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60.h),
                    const FadeInDelayed(delay: 0, child: LogoHeader()),
                    SizedBox(height: 40.h),
                    FadeInDelayed(delay: 200, child: const WelcomeSection()),
                    SizedBox(height: 35.h),
                    FadeInDelayed(
                      delay: 400,
                      child: LoginForm(
                        emailController: _emailController,
                        passwordController: _passwordController,
                        state: state,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    FadeInDelayed(
                      delay: 600,
                      child: LoginButton(
                        state: state,
                        onPressed: () => _onLoginPressed(context),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    FadeInDelayed(delay: 800, child: SocialSection()),
                    SizedBox(height: 30.h),
                    FadeInDelayed(
                      delay: 1000,
                      child: FooterSection(
                        text1: 'newHere',
                        text2: 'createAccount',
                        onTap: () => Get.toNamed(AppRoutes.signup),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
