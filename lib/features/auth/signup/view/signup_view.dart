import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mega_cart/core/NetWork/api_constans.dart';
import 'package:mega_cart/core/app_router.dart';
import 'package:mega_cart/features/auth/widget/text_field.dart';
import 'package:mega_cart/features/auth/login/view/social_login_buttons.dart';
import 'dart:async';

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
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() => _isLoading = true);

    final data = {
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text,
    };

    try {
      final dio = Dio();
      final response = await dio.post(
        ApiConstans.baseUrl + ApiConstans.register,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
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
      }
    } on DioException catch (e) {
      assert(() {
        debugPrint('--- Registration API Error ---');
        debugPrint('Path: ${e.requestOptions.path}\nData: ${e.response?.data}');
        return true;
      }());

      Get.snackbar(
        'Error',
        e.response?.data.toString() ?? 'signupFailed'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? 'firstNameRequired'.tr
                                      : null,
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
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? 'lastNameRequired'.tr
                                      : null,
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
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'emailRequired'.tr;
                              if (!GetUtils.isEmail(value))
                                return 'enterValidEmail'.tr;
                              return null;
                            },
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
                            obscureText: _isPasswordObscured,
                            controller: _passwordController,
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                () =>
                                    _isPasswordObscured = !_isPasswordObscured,
                              ),
                              icon: Icon(
                                _isPasswordObscured
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 20.sp,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            validator: (value) {
                              final password =
                                  value ?? ''; // This line was already correct
                              if (password.isEmpty)
                                return 'passwordRequired'
                                    .tr; // This line was already correct
                              if (password.length < 8)
                                return 'passwordMinLength'
                                    .tr; // This line was already correct
                              if (!RegExp(r'[A-Z]').hasMatch(password))
                                return 'passwordUppercase'
                                    .tr; // This line was already correct
                              if (!RegExp(r'[a-z]').hasMatch(password))
                                return 'passwordLowercase'
                                    .tr; // This line was already correct
                              if (!RegExp(r'[0-9]').hasMatch(password))
                                return 'passwordNumber'
                                    .tr; // This line was already correct
                              if (!RegExp(
                                r'[!@#\$%\^&*(),.?":{}|<>]',
                              ).hasMatch(password))
                                return 'passwordSpecialChar'
                                    .tr; // This line was already correct
                              return null;
                            },
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
                            obscureText: _isConfirmPasswordObscured,
                            controller: _confirmPasswordController,
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                () => _isConfirmPasswordObscured =
                                    !_isConfirmPasswordObscured,
                              ),
                              icon: Icon(
                                _isConfirmPasswordObscured
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 20.sp,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            validator: (v) => v != _passwordController.text
                                ? 'passwordsDoNotMatch'
                                      .tr // This line was already correct
                                : null,
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
                            onPressed: _isLoading ? null : _registerUser,
                            child: _isLoading
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
