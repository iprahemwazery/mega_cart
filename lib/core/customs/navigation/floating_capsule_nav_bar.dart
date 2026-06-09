import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// شريط ملاحة عائم على شكل كبسولة مع تأثير Glassmorphism
///
/// هذا الـ Widget يوفر:
/// - تصميم حديث على شكل كبسولة
/// - تأثير Glass (زجاج مثلج) مع الـ Backdrop Filter
/// - تأثيرات حركية سلسة للنصوص والأيقونات
/// - دعم `flutter_screenutil` للتجاوب
/// - Haptic Feedback عند الضغط
/// - دعم الـ Blur الديناميكي بناءً على السرعة
///
/// **المميزات:**
/// - ✅ تصميم احترافي وحديث
/// - ✅ أيقونة نشطة وغير نشطة
/// - ✅ نص يظهر فقط للعنصر النشط
/// - ✅ تأثير Backdrop Filter الديناميكي
/// - ✅ Haptic Feedback
/// - ✅ قابل للتخصيص بالكامل
///
/// **الاستخدام:**
///
/// ```dart
/// final ValueNotifier<double> blurSigma = ValueNotifier(12.0);
///
/// Scaffold(
///   bottomNavigationBar: FloatingCapsuleNavBar(
///     selectedIndex: _currentIndex,
///     onItemSelected: (index) {
///       setState(() => _currentIndex = index);
///     },
///     items: [
///       BottomNavItem(
///         icon: Icons.home_outlined,
///         activeIcon: Icons.home,
///         label: 'Home',
///         screen: HomeView(),
///       ),
///       BottomNavItem(
///         icon: Icons.shopping_cart_outlined,
///         activeIcon: Icons.shopping_cart,
///         label: 'Cart',
///         screen: CartView(),
///       ),
///     ],
///     blurSigma: blurSigma,
///   ),
/// )
/// ```
class FloatingCapsuleNavBar extends StatelessWidget {
  /// الفهرس الحالي للعنصر المختار
  final int selectedIndex;

  /// Callback عند اختيار عنصر جديد
  final Function(int) onItemSelected;

  /// قائمة العناصر في شريط الملاحة
  final List<BottomNavItem> items;

  /// قيمة الـ blur الديناميكية (اختيارية للتأثيرات المتقدمة)
  final ValueListenable<double> blurSigma;

  const FloatingCapsuleNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.items,
    required this.blurSigma,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.fromLTRB(24.w, 0, 24.w, 20.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child: ValueListenableBuilder<double>(
          valueListenable: blurSigma,
          builder: (context, sigma, child) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: theme.cardColor.withOpacity(
                    (sigma / 40).clamp(0.4, 0.8),
                  ),
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(items.length, (index) {
                    return _buildNavItem(
                      index,
                      items[index].icon,
                      items[index].activeIcon,
                      items[index].label,
                      theme,
                    );
                  }),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData? activeIcon,
    String label,
    ThemeData theme,
  ) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onItemSelected(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? (activeIcon ?? icon) : icon,
              color: isSelected ? theme.colorScheme.primary : theme.hintColor,
              size: 20,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isSelected
                  ? Padding(
                      padding: EdgeInsets.only(left: 6.w),
                      child: Text(label, style: theme.textTheme.labelSmall),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

/// نموذج يمثل عنصر واحد في شريط الملاحة
///
/// يحتوي على:
/// - [icon]: الأيقونة غير النشطة
/// - [activeIcon]: الأيقونة النشطة (اختيارية)
/// - [label]: اسم العنصر
/// - [screen]: الشاشة/الـ Widget المراد عرضه عند الاختيار
class BottomNavItem {
  /// الأيقونة المعروضة عندما لا يكون العنصر مختاراً
  final IconData icon;

  /// الأيقونة المعروضة عندما يكون العنصر مختاراً (اختيارية)
  /// إذا لم تُحدد، ستُستخدم [icon] بدلاً منها
  final IconData? activeIcon;

  /// اسم العنصر (يُعرض فقط عندما يكون مختاراً)
  final String label;

  /// الشاشة أو الـ Widget المراد عرضه عند تحديد هذا العنصر
  final Widget screen;

  BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.screen,
  });
}
