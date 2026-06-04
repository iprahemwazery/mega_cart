import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupWelcomeSection extends StatelessWidget {
  const SignupWelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
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
    );
  }
}
