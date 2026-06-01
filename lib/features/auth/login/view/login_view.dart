import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/app_router.dart';
import 'package:mega_cart/features/auth/widget/text_field.dart';
import 'package:mega_cart/features/auth/login/view/social_login_buttons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mega_cart/features/auth/login/cubit/login_cubit.dart';
import 'package:mega_cart/features/auth/login/cubit/login_state.dart';
import 'dart:async';

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
                    SizedBox(height: 40.h),
                    FadeInDelayed(
                      delay: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'welcomeBack'.tr,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'enterCredentials'.tr,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(height: 35.h),
                    // Input Fields
                    FadeInDelayed(
                      delay: 400,
                      child: Column(
                        children: [
                          CustomTextField(
                            labelText: 'emailAddress'.tr,
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: theme.colorScheme.primary,
                              size: 20.sp,
                            ),
                            obscureText: false,
                            controller: _emailController,
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
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            suffixIcon: IconButton(
                              onPressed: () => context
                                  .read<LoginCubit>()
                                  .togglePasswordVisibility(),
                              icon: Icon(
                                state.isPasswordObscured
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: theme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                            errorText: state.passwordError,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'forgotPassword'.tr,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    // Login Button
                    FadeInDelayed(
                      delay: 600,
                      child: Center(
                        child: SizedBox(
                          width:
                              200.w, // تقليل العرض ليكون أكثر تناسقاً واحترافية
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: state.status == LoginStatus.loading
                                ? null
                                : () => _onLoginPressed(context),
                            child: state.status == LoginStatus.loading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  )
                                : Text(
                                    'signIn'.tr,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    // Social Login Divider
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
                                  "orContinueWith".tr,
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
                          // استخدام الويدجت الموحد
                          const SocialLoginButtons(),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    // Footer
                    FadeInDelayed(
                      delay: 1000,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "newHere".tr,
                            style: GoogleFonts.montserrat(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 14.sp,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.signup),
                            child: Text(
                              "createAccount".tr,
                              style: GoogleFonts.montserrat(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                                decoration: TextDecoration.none,
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
