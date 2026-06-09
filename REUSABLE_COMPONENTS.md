# 📚 دليل استخدام المكونات المعاد استخدامها

في هذا المشروع، تم استخراج مكونات مهمة قابلة لإعادة الاستخدام بسهولة في أي تطبيق Flutter آخر.

---

## 🎁 المكونات المتاحة

### 1. **PageAnimationWrapper** - أنميشن متقدم

📁 **المسار:** `lib/core/animations/page_animation_wrapper.dart`  
📖 **الدليل:** `lib/core/animations/README.md`

**المميزات:**

- Slide + Fade + Scale Animation
- Staggered Animation (تأخير متدرج)
- قابل للتخصيص بالكامل
- بدون dependancies إضافية

**الاستخدام السريع:**

```dart
PageAnimationWrapper(
  index: index,
  child: YourWidget(),
)
```

---

### 2. **FloatingCapsuleNavBar** - شريط ملاحة عائم

📁 **المسار:** `lib/core/navigation/floating_capsule_nav_bar.dart`  
📖 **الدليل:** `lib/core/navigation/README.md`

**المميزات:**

- Glassmorphism Design
- Backdrop Filter ديناميكي
- Haptic Feedback
- تأثيرات حركية سلسة

**الاستخدام السريع:**

```dart
FloatingCapsuleNavBar(
  selectedIndex: _currentIndex,
  onItemSelected: (index) => setState(() => _currentIndex = index),
  items: navItems,
  blurSigma: _blurSigma,
)
```

---

## 🚀 خطوات الاستخدام في مشروع جديد

### **الخطوة 1: انسخ المجلدات**

من هذا المشروع، انسخ:

- `lib/core/animations/` - مجلد الأنميشنات
- `lib/core/navigation/` - مجلد الملاحة

إلى مشروعك الجديد في نفس المسار.

### **الخطوة 2: تثبيت الـ Dependencies**

تأكد من وجود هذه الـ Packages في `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_staggered_animations: ^1.2.0
  flutter_screenutil: ^5.9.0
```

### **الخطوة 3: استخدم المكونات**

#### في ملف `main.dart`:

```dart
import 'package:your_app/core/animations/page_animation_wrapper.dart';
import 'package:your_app/core/navigation/floating_capsule_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
```

#### في ملف الـ Screen الخاص بك:

```dart
import 'package:flutter/material.dart';
import 'package:your_app/core/animations/page_animation_wrapper.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: 10,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return PageAnimationWrapper(
            index: index,
            child: Card(
              child: Center(child: Text('Item $index')),
            ),
          );
        },
      ),
    );
  }
}
```

---

## 📖 أمثلة عملية شاملة

### مثال 1: تطبيق متجر إلكتروني كامل

```dart
import 'package:flutter/material.dart';
import 'package:your_app/core/animations/page_animation_wrapper.dart';
import 'package:your_app/core/navigation/floating_capsule_nav_bar.dart';

class ECommerceApp extends StatefulWidget {
  @override
  State<ECommerceApp> createState() => _ECommerceAppState();
}

class _ECommerceAppState extends State<ECommerceApp> {
  int _currentIndex = 0;
  final ValueNotifier<double> _blurSigma = ValueNotifier(12.0);

  final List<BottomNavItem> _navItems = [
    BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      screen: HomeScreen(),
    ),
    BottomNavItem(
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart,
      label: 'Cart',
      screen: CartScreen(),
    ),
    BottomNavItem(
      icon: Icons.favorite_outline,
      activeIcon: Icons.favorite,
      label: 'Favorites',
      screen: FavoritesScreen(),
    ),
    BottomNavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      screen: ProfileScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _navItems.map((item) => item.screen).toList(),
      ),
      bottomNavigationBar: FloatingCapsuleNavBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        items: _navItems,
        blurSigma: _blurSigma,
      ),
    );
  }
}

// شاشة المنزل مع الأنميشن
class HomeScreen extends StatelessWidget {
  final List<String> products = ['Product 1', 'Product 2', 'Product 3', 'Product 4'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return PageAnimationWrapper(
            index: index,
            child: Card(
              elevation: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag, size: 50),
                  SizedBox(height: 10),
                  Text(products[index]),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// شاشات فارغة للمثال
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: Center(child: Text('Cart Screen')),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: Center(child: Text('Favorites Screen')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('Profile Screen')),
    );
  }
}
```

### مثال 2: قائمة بسيطة مع الأنميشن

```dart
import 'package:flutter/material.dart';
import 'package:your_app/core/animations/page_animation_wrapper.dart';

class SimpleListScreen extends StatelessWidget {
  final List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Items')),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return PageAnimationWrapper(
            index: index,
            delay: Duration(milliseconds: 100 * index),
            child: ListTile(
              title: Text(items[index]),
              trailing: Icon(Icons.arrow_forward),
            ),
          );
        },
      ),
    );
  }
}
```

---

## 🎨 تخصيص المكونات

### تخصيص الأنميشن

```dart
PageAnimationWrapper(
  index: index,
  duration: Duration(milliseconds: 600), // مدة أطول
  verticalOffset: 100.0, // انزلاق أكبر
  delay: Duration(milliseconds: 150 * index), // تأخير أكبر
  child: YourWidget(),
)
```

### تخصيص شريط الملاحة

```dart
FloatingCapsuleNavBar(
  selectedIndex: _currentIndex,
  onItemSelected: (index) => setState(() => _currentIndex = index),
  items: _navItems,
  blurSigma: _blurSigma, // blur ديناميكي
)
```

---

## 📊 مقارنة الأداء

| الميزة           | PageAnimationWrapper | FloatingCapsuleNavBar |
| ---------------- | -------------------- | --------------------- |
| الحجم            | صغير جداً            | وسط                   |
| الأداء           | ممتاز                | ممتاز                 |
| التخصيص          | عالي جداً            | عالي                  |
| سهولة الاستخدام  | سهلة جداً            | سهلة جداً             |
| الـ Dependencies | 1 فقط                | 2                     |

---

## 🐛 استكشاف الأخطاء

### المشكلة: الأنميشن لا يعمل

**الحل:**

```dart
// تأكد من استخدام flutter_staggered_animations
// وتأكد من أن العنصر مرئي على الشاشة
```

### المشكلة: Overflow في شريط الملاحة

**الحل:**

```dart
// استخدم flutter_screenutil بشكل صحيح
// تأكد من وجود MediaQuery.of(context)
```

---

## 📚 موارد إضافية

- [Flutter Official Documentation](https://flutter.dev/docs)
- [Flutter Staggered Animations](https://pub.dev/packages/flutter_staggered_animations)
- [Flutter ScreenUtil](https://pub.dev/packages/flutter_screenutil)

---

## 💬 الدعم والمساهمة

إذا كان لديك أسئلة أو مقترحات، يمكنك:

1. فتح Issue في المستودع
2. تقديم Pull Request
3. التواصل المباشر

---

## 📄 الترخيص

جميع المكونات مفتوحة المصدر ومتاحة للاستخدام التجاري وغير التجاري.

---

**استمتع ببناء تطبيقات رائعة! 🚀**
