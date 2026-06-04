import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mega_cart/core/app_router.dart';

// تم نقل هذا الملف إلى مجلد auth/widget ليكون عاماً
// المسار الجديد المقترح: mega_cart/lib/features/auth/widget/footer_section.dart
class FooterSection extends StatelessWidget {
  final String text1;
  final String text2;
  final VoidCallback onTap;

  const FooterSection({
    super.key,
    required this.text1,
    required this.text2,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text1.tr,
          style: GoogleFonts.montserrat(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 14.sp,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            text2.tr,
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}
