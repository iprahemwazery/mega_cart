import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

/// أنميشن موحد وقابل لإعادة الاستخدام يوفر تأثير Slide + Fade + Scale
///
/// يمكن استخدام هذا الملف في أي تطبيق Flutter
///
/// **المميزات:**
/// - تأثير شريحة من الأسفل للأعلى (Slide)
/// - تأثير ظهور تدريجي (Fade)
/// - تأثير تكبير تدريجي (Scale)
/// - دعم التأخير المتدرج (Staggered Delay)
/// - قابل للتخصيص (Duration, Offset, Delay)
///
/// **الاستخدام الأساسي:**
///
/// ```dart
/// // لعنصر واحد في ListView
/// ListView.builder(
///   itemCount: items.length,
///   itemBuilder: (context, index) {
///     return PageAnimationWrapper(
///       index: index,
///       child: YourWidget(),
///     );
///   },
/// )
/// ```
///
/// **الاستخدام المتقدم:**
///
/// ```dart
/// // لقائمة من العناصر
/// Column(
///   children: PageAnimationWrapper.staggeredList(
///     children: [
///       YourWidget1(),
///       YourWidget2(),
///       YourWidget3(),
///     ],
///     duration: Duration(milliseconds: 600),
///     delay: Duration(milliseconds: 150),
///   ),
/// )
/// ```
class PageAnimationWrapper extends StatelessWidget {
  final int index;
  final Widget child;
  final Duration duration;
  final Duration? delay;
  final double verticalOffset;
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
