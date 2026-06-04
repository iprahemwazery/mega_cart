import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mega_cart/features/auth/login/cubit/login_state.dart';

class LoginButton extends StatelessWidget {
  final LoginState state;
  final VoidCallback onPressed;

  const LoginButton({super.key, required this.state, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SizedBox(
        width: 200.w,
        height: 56.h,
        child: ElevatedButton(
          onPressed: state.status == LoginStatus.loading ? null : onPressed,
          child: state.status == LoginStatus.loading
              ? SizedBox(
                  height: 20.h,
                  width: 20.h,
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
    );
  }
}
