import 'package:flutter/material.dart';
import 'package:mega_cart/features/home/view/home_view.dart';
import 'package:mega_cart/features/favorites/view/favorit_view.dart';
import 'package:get/get.dart'; // Import Get for .tr extension
import 'package:mega_cart/features/cart/view/cart_view.dart';
import 'package:mega_cart/features/profile/view/profiel_view.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeView(), // Home
    Center(
      child: Text('orders'.tr, style: const TextStyle(fontSize: 24)),
    ), // Orders
    const CartView(), // Cart
    const FavoritView(), // Favorites
    const ProfileView(), // Profile
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
            icon: const Icon(Icons.home_outlined), // Home
            selectedIcon: const Icon(Icons.home), // Home
            label: 'home'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined), // Orders
            selectedIcon: const Icon(Icons.receipt_long), // Orders
            label: 'orders'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.shopping_cart_outlined), // Cart
            selectedIcon: const Icon(Icons.shopping_cart), // Cart
            label: 'cartTab'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_outline), // Favorites
            selectedIcon: const Icon(Icons.favorite), // Favorites
            label: 'favorites'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline), // My Account
            selectedIcon: const Icon(Icons.person), // My Account
            label: 'myAccount'.tr,
          ),
        ],
      ),
    );
  }
}
