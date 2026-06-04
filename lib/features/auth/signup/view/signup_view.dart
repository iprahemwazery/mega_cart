import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/app_router.dart';
import 'package:mega_cart/features/auth/signup/cubit/signup_cubit.dart';
import 'package:mega_cart/features/auth/signup/cubit/signup_state.dart';
import 'package:mega_cart/features/auth/signup/widget/signup_buttom.dart';
import 'package:mega_cart/features/auth/signup/widget/signup_form.dart';
import 'package:mega_cart/features/auth/signup/widget/signup_welcome_section.dart';
import 'package:mega_cart/features/auth/login/widget/logo_header.dart';
import 'package:mega_cart/features/auth/login/widget/social_section.dart';
import 'package:mega_cart/features/auth/login/widget/footer_section.dart';
import 'package:mega_cart/features/auth/widget/fade_in_delayed.dart';

class SingupView extends StatelessWidget {
  SingupView({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _onRegisterPressed(BuildContext context) {
    context.read<SignupCubit>().register(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state.status == SignupStatus.success) {
          Get.snackbar(
            'success'.tr,
            'signupSuccess'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1),
          );
          Get.toNamed(
            AppRoutes.verifyEmail,
            arguments: {'email': _emailController.text.trim()},
          );
        } else if (state.status == SignupStatus.failure &&
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
    );
  }

  Widget _buildUI(BuildContext context, SignupState state) {
    final theme = Theme.of(context);
    return Scaffold(
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
                    SizedBox(height: 30.h),
                    const FadeInDelayed(delay: 0, child: LogoHeader()),
                    SizedBox(height: 30.h),
                    const FadeInDelayed(
                      delay: 200,
                      child: SignupWelcomeSection(),
                    ),
                    SizedBox(height: 30.h),
                    FadeInDelayed(
                      delay: 400,
                      child: SignupForm(
                        state: state,
                        firstNameController: _firstNameController,
                        lastNameController: _lastNameController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    FadeInDelayed(
                      delay: 600,
                      child: SignupButton(
                        state: state,
                        onPressed: () => _onRegisterPressed(context),
                      ),
                    ),
                    SizedBox(height: 25.h),
                    const FadeInDelayed(delay: 800, child: SocialSection()),
                    SizedBox(height: 25.h),
                    FadeInDelayed(
                      delay: 1000,
                      child: FooterSection(
                        text1: 'alreadyHaveAccount',
                        text2: 'signInFooter',
                        onTap: () => Get.back(),
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
