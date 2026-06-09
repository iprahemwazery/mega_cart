import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PageAnimationWrapper extends StatelessWidget {
  final int index;
  final Widget child;
  final Duration duration;
  final Duration? delay;
  final double verticalOffset;

  /// يستخدم لتغليف عنصر واحد داخل ListView.builder أو GridView.builder
  const PageAnimationWrapper({
    super.key,
    required this.index,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.delay,
    this.verticalOffset = 60.0,
  });

  static List<Widget> staggeredList({
    required List<Widget> children,
    Duration duration = const Duration(milliseconds: 800),
    Duration delay = const Duration(milliseconds: 100),
    double verticalOffset = 60.0,
  }) {
    return AnimationConfiguration.toStaggeredList(
      duration: duration,
      delay: delay,
      childAnimationBuilder: (widget) => SlideAnimation(
        verticalOffset: verticalOffset,
        curve: Curves.elasticOut,
        child: FadeInAnimation(
          curve: Curves.easeOut,
          child: ScaleAnimation(scale: 0.9, child: widget),
        ),
      ),
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: duration,
      delay: delay ?? Duration(milliseconds: index * 50),
      child: SlideAnimation(
        verticalOffset: verticalOffset,
        curve: Curves.elasticOut,
        child: FadeInAnimation(
          curve: Curves.easeOut,
          child: ScaleAnimation(scale: 0.9, child: child),
        ),
      ),
    );
  }
}
