import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google Button
        _AnimatedSocialBtn(
          onTap: () => debugPrint('Google Login'),
          imagePath:
              'assets/icons/png-clipart-google-logo-google-text-trademark-thumbnail.png',
        ),
        const SizedBox(width: 20),
        // Facebook Button
        _AnimatedSocialBtn(
          onTap: () => debugPrint('Facebook Login'),
          imagePath: 'assets/icons/images.jpeg',
        ),
      ],
    );
  }
}

class _AnimatedSocialBtn extends StatefulWidget {
  final VoidCallback onTap;
  final String imagePath;

  const _AnimatedSocialBtn({required this.onTap, required this.imagePath});

  @override
  State<_AnimatedSocialBtn> createState() => _AnimatedSocialBtnState();
}

class _AnimatedSocialBtnState extends State<_AnimatedSocialBtn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Image.asset(
            widget.imagePath,
            width: 40,
            height: 40,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
