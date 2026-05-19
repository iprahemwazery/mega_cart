import 'package:flutter/material.dart';

class PromoCard extends StatelessWidget {
  final String promoText;
  final String byText;

  const PromoCard({super.key, required this.promoText, required this.byText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: EdgeInsets.zero, // إزالة الهامش ليتماشى مع حواف التطبيق
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD), // لون شبه أبيض فخم
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // نصف دائرة في اليمين من الأعلى
            Positioned(
              top: -20,
              right: -50,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // نصف دائرة في الشمال من الأسفل
            Positioned(
              bottom: -30,
              left: -50,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // النص في المنتصف تماماً
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    promoText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    byText,
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
