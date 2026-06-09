import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

/// A reusable staggered "slide up + fade in" list widget.
///
/// Usage:
/// SlideUpStaggeredList(
///   itemCount: items.length,
///   itemBuilder: (ctx, i) => YourItemWidget(...),
/// )
class SlideUpStaggeredList extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Axis scrollDirection;
  final EdgeInsetsGeometry? padding;
  final Duration duration;
  final double verticalOffset;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const SlideUpStaggeredList({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.duration = const Duration(milliseconds: 450),
    this.verticalOffset = 50.0,
    this.shrinkWrap = false,
    this.physics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: padding,
        scrollDirection: scrollDirection,
        itemCount: itemCount,
        shrinkWrap: shrinkWrap,
        physics: physics,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: duration,
            child: SlideAnimation(
              verticalOffset: verticalOffset,
              child: FadeInAnimation(child: itemBuilder(context, index)),
            ),
          );
        },
      ),
    );
  }
}
