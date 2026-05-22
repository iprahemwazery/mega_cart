import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.labelText,
    required this.obscureText,
    this.prefixIcon, // إضافة prefixIcon هنا
    this.validator,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.suffixIcon,
  });
  final String labelText;
  final bool obscureText;
  final Widget? prefixIcon; // تعريف prefixIcon
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: const Color(0xFF1A1A1A), // لون المؤشر
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      validator: validator,
      style: TextStyle(fontSize: 14.sp, color: Colors.black87),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: prefixIcon, // استخدام prefixIcon
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF8F9FA), // خلفية خفيفة جداً
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.r), // حواف دائرية
          borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.r),
          borderSide: const BorderSide(color: Color(0xFF1A1A1A), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.r),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.r),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}
