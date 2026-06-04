
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mega_cart/features/auth/signup/cubit/signup_state.dart';

class SignupButton extends StatelessWidget {
  final SignupState state;
  final VoidCallback onPressed;
  const SignupButton({required this.state, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 220.w,
        height: 56.h,
        child: ElevatedButton(
          onPressed: state.status == SignupStatus.loading ? null : onPressed,
          child: state.status == SignupStatus.loading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  'createAccountButton'.tr,
                  style: GoogleFonts.montserrat(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ),
    );
  }
}
