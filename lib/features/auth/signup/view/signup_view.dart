import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mega_cart/core/app_router.dart';
import 'package:mega_cart/features/auth/widget/text_field.dart';
import 'package:mega_cart/features/auth/login/view/social_login_buttons.dart';
import 'package:mega_cart/features/auth/signup/cubit/signup_cubit.dart';
import 'package:mega_cart/features/auth/signup/cubit/signup_state.dart';
import 'dart:async';

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
        } else if (state.status == SignupStatus.failure) {
          Get.snackbar(
            'Error',
            state.errorMessage?.tr ?? 'signupFailed'.tr,
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
                    FadeInDelayed(
                      delay: 0,
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'MEGA',
                              style: GoogleFonts.playball(
                                fontSize: 52.sp,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                                letterSpacing: 2,
                              ),
                            ),
                            Container(
                              height: 2.h,
                              width: 50.w,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Text(
                              'CART',
                              style: GoogleFonts.montserrat(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 10,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    FadeInDelayed(
                      delay: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'createAccountTitle'.tr,
                            style: GoogleFonts.montserrat(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'fillDetails'.tr,
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              color: theme.colorScheme.primary.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    FadeInDelayed(
                      delay: 400,
                      child: Column(
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
                                  controller: _firstNameController,
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
                                  controller: _lastNameController,
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
                            controller: _emailController,
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
                            controller: _passwordController,
                            suffixIcon: IconButton(
                              onPressed: () => context
                                  .read<SignupCubit>()
                                  .togglePasswordVisibility(),
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
                            // This line was already correct
                            labelText: 'confirmPassword'
                                .tr, // This line was already correct
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              size: 20.sp,
                              color: theme.colorScheme.primary,
                            ),
                            obscureText: state.isConfirmPasswordObscured,
                            controller: _confirmPasswordController,
                            suffixIcon: IconButton(
                              onPressed: () => context
                                  .read<SignupCubit>()
                                  .toggleConfirmPasswordVisibility(),
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
                      ),
                    ),
                    SizedBox(height: 30.h),
                    // Register Button
                    FadeInDelayed(
                      delay: 600,
                      child: Center(
                        child: SizedBox(
                          width: 220.w,
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: state.status == SignupStatus.loading
                                ? null
                                : () => _onRegisterPressed(context),
                            child: state.status == SignupStatus.loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    'createAccountButton'.tr,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25.h),
                    // Divider
                    FadeInDelayed(
                      delay: 800,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: theme.colorScheme.outlineVariant,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Text(
                                  "orSignUpWith".tr,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12.sp,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: theme.colorScheme.outlineVariant,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          // استخدام الويدجت الموحد هنا
                          const SocialLoginButtons(),
                        ],
                      ),
                    ),
                    SizedBox(height: 25.h),
                    // Footer
                    FadeInDelayed(
                      delay: 1000,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "alreadyHaveAccount".tr,
                            style: GoogleFonts.montserrat(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 14.sp,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Text(
                              "signInFooter".tr,
                              style: GoogleFonts.montserrat(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
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

class FadeInDelayed extends StatefulWidget {
  final Widget child;
  final int delay;
  const FadeInDelayed({super.key, required this.child, required this.delay});

  @override
  State<FadeInDelayed> createState() => _FadeInDelayedState();
}

class _FadeInDelayedState extends State<FadeInDelayed>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _offset = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Timer(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}
