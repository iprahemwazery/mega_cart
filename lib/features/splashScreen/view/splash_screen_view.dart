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
  late Animation<double> _fadeAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 6000),
      vsync: this,
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.linear),
      ),
    );

    _megaAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -3.0)).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
          ),
        );

    _cartAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, 3.0)).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
          ),
        );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 6500), () async {
      if (!mounted) return;

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final baseColor = isDark ? Colors.white : theme.colorScheme.primary;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withOpacity(isDark ? 0.3 : 0.12),
              theme.colorScheme.surface,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return ShaderMask(
                shaderCallback: (bounds) {
                  if (_controller.value >= 0.6) {
                    return LinearGradient(
                      colors: [baseColor, baseColor],
                    ).createShader(bounds);
                  }

                  return LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      baseColor.withOpacity(0.05),
                      baseColor.withOpacity(0.2),
                      baseColor,
                      baseColor.withOpacity(0.2),
                      baseColor.withOpacity(0.05),
                    ],
                    stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                    transform: _SlidingGradientTransform(
                      _shimmerAnimation.value,
                    ),
                  ).createShader(bounds);
                },
                child: child,
              );
            },
            child: FadeTransition(
              opacity: _fadeAnimation,
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
                        color: baseColor,
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
                        color: baseColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.percent);
  final double percent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * percent, 0, 0);
  }
}
