import 'package:flutter/material.dart';
import 'package:mega_cart/features/home/view/home_view.dart';
import 'package:mega_cart/features/favorites/view/favorit_view.dart';
import 'package:get/get.dart';
import 'package:mega_cart/features/cart/view/cart_view.dart';
import 'package:mega_cart/features/order/view/orde_view.dart';
import 'package:mega_cart/features/profile/view/profiel_view.dart';
import 'package:mega_cart/core/customs/navigation/floating_capsule_nav_bar.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _currentIndex = 0;

  final ValueNotifier<double> _blurSigma = ValueNotifier(12.0);

  late final List<BottomNavItem> _navItems = [
    BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'home'.tr,
      screen: const HomeView(),
    ),
    BottomNavItem(
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
      label: 'orders'.tr,
      screen: const OrderView(),
    ),
    BottomNavItem(
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart,
      label: 'cartTab'.tr,
      screen: const CartView(),
    ),
    BottomNavItem(
      icon: Icons.favorite_outline,
      activeIcon: Icons.favorite,
      label: 'favorites'.tr,
      screen: const FavoritView(),
    ),
    BottomNavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'profile'.tr,
      screen: const ProfileView(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // للسماح للبار بالطفو فوق المحتوى
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            // حساب سرعة التمرير بناءً على المسافة المقطوعة في الإطار الحالي
            final velocity = notification.scrollDelta?.abs() ?? 0;
            // زيادة التضبيب تدريجياً مع السرعة (بحد أقصى 30)
            _blurSigma.value = (12.0 + (velocity * 0.5)).clamp(12.0, 30.0);
          } else if (notification is ScrollEndNotification) {
            // العودة للقيمة الأصلية عند توقف التمرير
            _blurSigma.value = 12.0;
          }
          return false;
        },
        child: IndexedStack(
          index: _currentIndex,
          children: List.generate(_navItems.length, (index) {
            // إعطاء Key فريد للصفحة النشطة لإجبار الأنميشن على البدء من جديد
            return KeyedSubtree(
              key: ValueKey(
                _currentIndex == index ? 'active_$index' : 'inactive_$index',
              ),
              child: _navItems[index].screen,
            );
          }),
        ),
      ),
      bottomNavigationBar: FloatingCapsuleNavBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _navItems,
        blurSigma: _blurSigma,
      ),
    );
  }
}
