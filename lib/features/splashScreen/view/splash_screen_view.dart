import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/app_router.dart';
import 'package:mega_cart/features/splashScreen/view/session_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _megaAnimation;
  late Animation<Offset> _cartAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
        milliseconds: 6000,
      ), // زيادة المدة ليكون النور والحركة أبطأ بوضوح
      vsync: this,
    );

    // 1. أنيميشن النور: يبدأ من 0 إلى 60% من وقت الأنميشن والكلمات ثابتة تماماً
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.linear),
      ),
    );

    // 2. Mega: تبدأ في مكانها (Offset.zero) وتطلع لفوق في آخر 30% من الوقت
    _megaAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -3.0)).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(
              0.6,
              1.0,
              curve: Curves.easeIn, // حركة ناعمة من السكون إلى الأعلى مباشرة
            ),
          ),
        );

    // 3. Cart: تبدأ في مكانها (Offset.zero) وتنزل لتحت في آخر 30% من الوقت
    _cartAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, 3.0)).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(
              0.6,
              1.0,
              curve: Curves.easeIn, // حركة ناعمة من السكون إلى الأسفل مباشرة
            ),
          ),
        );

    _controller.forward(); // ابدأ الأنيميشن فوراً

    // زيادة التأخير ليتناسب مع المدة الجديدة (6 ثوانٍ للأنيميشن + نصف ثانية سكون)
    // لضمان خروج الكلمات تماماً من الشاشة قبل الانتقال
    Future.delayed(const Duration(milliseconds: 6500), () async {
      if (!mounted) return; // تأكد أن الـ Widget لا يزال موجوداً في الشجرة

      final isLoggedIn = await SessionManager.isLoggedIn();
      debugPrint('SplashScreen: isLoggedIn = $isLoggedIn');
      if (isLoggedIn) {
        debugPrint('SplashScreen: Navigating to root');
        Get.offAllNamed(AppRoutes.root);
      } else {
        debugPrint('SplashScreen: Navigating to login');
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }

  late Animation<double> _shimmerAnimation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F2027), // أزرق ليلي غامق جدًا (Midnight)
              Color(0xFF203A43), // أزرق بترولي عميق
              Color(0xFF2C5364), // درجة أفتح قليلاً لإعطاء عمق للمكان
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return ShaderMask(
                shaderCallback: (bounds) {
                  // إذا وصلنا لمرحلة الحركة (تبدأ عند 0.6)، نجعل النص أبيض ساطع وثابت
                  if (_controller.value >= 0.6) {
                    return const LinearGradient(
                      colors: [Colors.white, Colors.white],
                    ).createShader(bounds);
                  }

                  // تأثير النور القوي أثناء السكون
                  return LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(
                        0.05,
                      ), // تعتيم أكثر لإبراز قوة النور
                      Colors.white.withOpacity(0.2),
                      Colors.white, // مركز النور الساطع
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.05),
                    ],
                    // توسيع النطاق لجعل "عرض" الضوء أكبر على الكلمات
                    stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                    // تحريك التدرج اللوني بناءً على الأنيميشن
                    transform: _SlidingGradientTransform(
                      _shimmerAnimation.value,
                    ),
                  ).createShader(bounds);
                },
                child: child,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideTransition(
                  position: _megaAnimation,
                  child: Text(
                    'Mega',
                    style: GoogleFonts.playball(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SlideTransition(
                  position: _cartAnimation,
                  child: Text(
                    'Cart',
                    style: GoogleFonts.playball(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// كلاس مساعد لتحريك التدرج اللوني (النور) من اليسار لليمين
class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.percent);
  final double percent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * percent, 0, 0);
  }
}
