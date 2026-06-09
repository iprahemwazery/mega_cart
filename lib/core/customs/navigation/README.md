# FloatingCapsuleNavBar - شريط ملاحة عائم احترافي

شريط ملاحة حديث وجميل على شكل كبسولة مع تأثير Glass (زجاج مثلج).

## المميزات ✨

- ✅ تصميم **Glassmorphism** حديث
- ✅ **Backdrop Filter** ديناميكي
- ✅ أيقونات نشطة وغير نشطة
- ✅ نص يظهر فقط للعنصر النشط
- ✅ **Haptic Feedback** عند الضغط
- ✅ تأثيرات حركية سلسة
- ✅ دعم `flutter_screenutil` للتجاوب
- ✅ ظل جميل وحدود معرّفة
- ✅ قابل للتخصيص بالكامل

---

## التثبيت 📦

### 1. تأكد من وجود الـ Dependencies في `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_screenutil: ^latest_version
```

### 2. انسخ الملف:

انسخ ملف `floating_capsule_nav_bar.dart` إلى مشروعك:

```
lib/core/navigation/floating_capsule_nav_bar.dart
```

---

## الاستخدام الأساسي 🚀

### الإعداد البسيط:

```dart
import 'package:your_app/core/navigation/floating_capsule_nav_bar.dart';

class Root extends StatefulWidget {
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
      label: 'Home',
      screen: HomeView(),
    ),
    BottomNavItem(
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart,
      label: 'Cart',
      screen: CartView(),
    ),
    BottomNavItem(
      icon: Icons.favorite_outline,
      activeIcon: Icons.favorite,
      label: 'Favorites',
      screen: FavoritesView(),
    ),
    BottomNavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      screen: ProfileView(),
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
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
        },
        items: _navItems,
        blurSigma: _blurSigma,
      ),
    );
  }
}
```

---

## الاستخدام المتقدم 🎯

### مع ScrollNotification للـ Blur الديناميكي:

```dart
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
      child: IndexedStack(
        index: _currentIndex,
        children: _navItems.map((item) => item.screen).toList(),
      ),
    ),
    bottomNavigationBar: FloatingCapsuleNavBar(
      selectedIndex: _currentIndex,
      onItemSelected: (index) => setState(() => _currentIndex = index),
      items: _navItems,
      blurSigma: _blurSigma,
    ),
  );
}
```

---

## الأمثلة الكاملة 📚

### مثال 1: تطبيق متجر إلكتروني

```dart
class ShoppingApp extends StatefulWidget {
  @override
  State<ShoppingApp> createState() => _ShoppingAppState();
}

class _ShoppingAppState extends State<ShoppingApp> {
  int _currentIndex = 0;
  final ValueNotifier<double> _blurSigma = ValueNotifier(12.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(),
          CategoriesScreen(),
          CartScreen(),
          OrdersScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: FloatingCapsuleNavBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Home',
            screen: SizedBox(), // تم تغطيته في IndexedStack
          ),
          BottomNavItem(
            icon: Icons.category_outlined,
            activeIcon: Icons.category,
            label: 'Categories',
            screen: SizedBox(),
          ),
          BottomNavItem(
            icon: Icons.shopping_cart_outlined,
            activeIcon: Icons.shopping_cart,
            label: 'Cart',
            screen: SizedBox(),
          ),
          BottomNavItem(
            icon: Icons.receipt_outlined,
            activeIcon: Icons.receipt,
            label: 'Orders',
            screen: SizedBox(),
          ),
          BottomNavItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'Profile',
            screen: SizedBox(),
          ),
        ],
        blurSigma: _blurSigma,
      ),
    );
  }
}
```

### مثال 2: تطبيق الموسيقى

```dart
FloatingCapsuleNavBar(
  selectedIndex: _currentIndex,
  onItemSelected: (index) => setState(() => _currentIndex = index),
  items: [
    BottomNavItem(
      icon: Icons.library_music_outlined,
      activeIcon: Icons.library_music,
      label: 'Library',
      screen: SizedBox(),
    ),
    BottomNavItem(
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      label: 'Search',
      screen: SizedBox(),
    ),
    BottomNavItem(
      icon: Icons.favorite_outline,
      activeIcon: Icons.favorite,
      label: 'Favorites',
      screen: SizedBox(),
    ),
    BottomNavItem(
      icon: Icons.account_circle_outlined,
      activeIcon: Icons.account_circle,
      label: 'Profile',
      screen: SizedBox(),
    ),
  ],
  blurSigma: _blurSigma,
)
```

### مثال 3: تطبيق اجتماعي

```dart
FloatingCapsuleNavBar(
  selectedIndex: _currentIndex,
  onItemSelected: (index) => setState(() => _currentIndex = index),
  items: [
    BottomNavItem(
      icon: Icons.feed_outlined,
      activeIcon: Icons.feed,
      label: 'Feed',
      screen: SizedBox(),
    ),
    BottomNavItem(
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore,
      label: 'Explore',
      screen: SizedBox(),
    ),
    BottomNavItem(
      icon: Icons.add_box_outlined,
      activeIcon: Icons.add_box,
      label: 'Post',
      screen: SizedBox(),
    ),
    BottomNavItem(
      icon: Icons.favorite_outline,
      activeIcon: Icons.favorite,
      label: 'Likes',
      screen: SizedBox(),
    ),
    BottomNavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      screen: SizedBox(),
    ),
  ],
  blurSigma: _blurSigma,
)
```

---

## الخصائص 🔧

| الخاصية          | النوع                     | الافتراضي | الوصف                                 |
| ---------------- | ------------------------- | --------- | ------------------------------------- |
| `selectedIndex`  | `int`                     | **مطلوب** | الفهرس الحالي للعنصر المختار          |
| `onItemSelected` | `Function(int)`           | **مطلوب** | Callback عند اختيار عنصر              |
| `items`          | `List<BottomNavItem>`     | **مطلوب** | قائمة عناصر شريط الملاحة              |
| `blurSigma`      | `ValueListenable<double>` | **مطلوب** | قيمة الـ blur (للتأثيرات الديناميكية) |

---

## خصائص BottomNavItem 🏷️

| الخاصية      | النوع       | الافتراضي | الوصف                      |
| ------------ | ----------- | --------- | -------------------------- |
| `icon`       | `IconData`  | **مطلوب** | الأيقونة غير النشطة        |
| `activeIcon` | `IconData?` | null      | الأيقونة النشطة (اختيارية) |
| `label`      | `String`    | **مطلوب** | اسم العنصر                 |
| `screen`     | `Widget`    | **مطلوب** | الشاشة المراد عرضها        |

---

## نصائح وحيل 💡

### 1. تخصيص الألوان:

استخدم `theme.colorScheme.primary` لتطبيق لون ابتدائي مخصص.

### 2. إضافة Badge للعنصر:

```dart
Stack(
  children: [
    FloatingCapsuleNavBar(...),
    Positioned(
      top: 10,
      right: 20,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text('5', style: TextStyle(color: Colors.white, fontSize: 10)),
        ),
      ),
    ),
  ],
)
```

### 3. دعم الاتجاه RTL:

الـ Widget يدعم RTL تلقائياً بواسطة Flutter.

### 4. التكيف مع الأجهزة المختلفة:

استخدم `flutter_screenutil` للحصول على تجاوب كامل.

---

## الملفات ذات الصلة 📁

- `lib/core/navigation/floating_capsule_nav_bar.dart` - الشريط الرئيسي
- `lib/root.dart` - مثال الاستخدام الكامل
- `lib/features/order/view/orde_view.dart` - شاشة داخل التطبيق

---

## الترخيص 📄

هذا الـ Widget مفتوح المصدر ويمكن استخدامه في أي مشروع تجاري أو غير تجاري.

---

## الدعم 🤝

إذا واجهت أي مشاكل أو عندك اقتراحات، لا تتردد في التواصل!
