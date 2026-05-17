import 'package:flutter/material.dart';
import 'package:mega_cart/features/home/view/home_view.dart';
import 'package:mega_cart/features/favorites/view/favorit_view.dart';
import 'package:mega_cart/features/cart/view/cart_view.dart';
import 'package:mega_cart/features/profile/view/profiel_view.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _currentIndex = 0;

  // قائمة الصفحات (استخدمنا HomeView والباقي كمكان محجوز حتى تنشئ ملفاتهم)
  final List<Widget> _pages = [
    const HomeView(),
    const Center(child: Text('الطلبات', style: TextStyle(fontSize: 24))),
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
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'الطلبات',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'السلة',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'المفضلة',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}
