import 'package:flutter/material.dart';
import 'package:mega_cart/features/favorites/view/favorit_view.dart';
import 'package:get/get.dart';
import 'package:mega_cart/features/cart/presentation/view/cart_view.dart';
import 'package:mega_cart/features/home/presentation/view/home_view.dart';
import 'package:mega_cart/features/order/view/orde_view.dart';
import 'package:mega_cart/features/profile/view/profiel_view.dart';
import 'package:mega_cart/core/customs/navigation/floating_capsule_nav_bar.dart';
import 'package:mega_cart/core/animations/page_animation_wrapper.dart';

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
      extendBody: true,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            final velocity = notification.scrollDelta?.abs() ?? 0;
            _blurSigma.value = (12.0 + (velocity * 0.5)).clamp(12.0, 30.0);
          } else if (notification is ScrollEndNotification) {
            _blurSigma.value = 12.0;
          }
          return false;
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: PageAnimationWrapper(
            key: ValueKey(_currentIndex),
            index: 0,
            verticalOffset: _currentIndex == 3 ? 50.0 : -50.0,
            child: _navItems[_currentIndex].screen,
          ),
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
