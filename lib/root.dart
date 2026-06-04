import 'package:flutter/material.dart';
import 'package:mega_cart/features/home/view/home_view.dart';
import 'package:mega_cart/features/favorites/view/favorit_view.dart';
import 'package:get/get.dart';
import 'package:mega_cart/features/cart/view/cart_view.dart';
import 'package:mega_cart/features/order/view/orde_view.dart';
import 'package:mega_cart/features/profile/view/profiel_view.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeView(),
    const OrderView(),
    const CartView(),
    const FavoritView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        height: 65,
        elevation: 10,
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: 'home'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: 'orders'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.shopping_cart_outlined),
            selectedIcon: const Icon(Icons.shopping_cart),
            label: 'cartTab'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_outline),
            selectedIcon: const Icon(Icons.favorite),
            label: 'favorites'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: 'profile'.tr,
          ),
        ],
      ),
    );
  }
}
