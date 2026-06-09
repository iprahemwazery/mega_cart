# PageAnimationWrapper - أنميشن قابل لإعادة الاستخدام

أنميشن موحد وسهل الاستخدام يوفر تأثير احترافي لأي تطبيق Flutter.

## المميزات ✨

- ✅ تأثير **Slide** (انزلاق من الأسفل للأعلى)
- ✅ تأثير **Fade** (ظهور تدريجي)
- ✅ تأثير **Scale** (تكبير من 0.9 إلى 1)
- ✅ **Staggered Animation** (تأخير متدرج بين العناصر)
- ✅ قابل للتخصيص بالكامل
- ✅ بدون dependancies إضافية (فقط `flutter_staggered_animations`)

---

## التثبيت 📦

### 1. أضف الـ Dependency في `pubspec.yaml`:

```yaml
dependencies:
  flutter_staggered_animations: ^latest_version
```

### 2. انسخ الملف:

انسخ ملف `page_animation_wrapper.dart` إلى مشروعك:

```
lib/core/animations/page_animation_wrapper.dart
```

---

## الاستخدام الأساسي 🚀

### استخدام في ListView:

```dart
import 'package:your_app/core/animations/page_animation_wrapper.dart';

ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return PageAnimationWrapper(
      index: index,
      child: YourWidget(item: items[index]),
    );
  },
)
```

### استخدام في GridView:

```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
  ),
  itemCount: items.length,
  itemBuilder: (context, index) {
    return PageAnimationWrapper(
      index: index,
      child: ProductCard(product: items[index]),
    );
  },
)
```

---

## الاستخدام المتقدم 🎯

### لقائمة كاملة من العناصر:

```dart
Column(
  children: PageAnimationWrapper.staggeredList(
    children: [
      Widget1(),
      Widget2(),
      Widget3(),
      Widget4(),
    ],
  ),
)
```

### تخصيص المعاملات:

```dart
PageAnimationWrapper(
  index: index,
  duration: const Duration(milliseconds: 600), // مدة الأنميشن
  delay: const Duration(milliseconds: 100 * index), // تأخير مخصص
  verticalOffset: 80.0, // المسافة المنزلقة
  child: YourWidget(),
)
```

### مثال متقدم - عكس الترتيب:

```dart
final int reversedIndex = items.length - 1 - index;
PageAnimationWrapper(
  index: reversedIndex,
  delay: Duration(milliseconds: 100 * reversedIndex),
  child: YourWidget(),
)
```

---

## الأمثلة الكاملة 📚

### مثال 1: قائمة المنتجات

```dart
GridView.builder(
  padding: const EdgeInsets.all(16),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.75,
  ),
  itemCount: products.length,
  itemBuilder: (context, index) {
    return PageAnimationWrapper(
      index: index,
      child: ProductCard(product: products[index]),
    );
  },
)
```

### مثال 2: قائمة الطلبات

```dart
ListView.builder(
  padding: const EdgeInsets.all(16),
  itemCount: orders.length,
  itemBuilder: (context, index) {
    final reversedIndex = (orders.length - 1) - index;
    return PageAnimationWrapper(
      index: reversedIndex,
      delay: Duration(milliseconds: 100 * reversedIndex),
      child: OrderCard(order: orders[index]),
    );
  },
)
```

### مثال 3: قائمة بسيطة

```dart
Column(
  children: PageAnimationWrapper.staggeredList(
    children: [
      ProfileHeader(user: user),
      SettingsOption(icon: Icons.edit, title: 'Edit Profile'),
      SettingsOption(icon: Icons.settings, title: 'Settings'),
      SettingsOption(icon: Icons.logout, title: 'Logout'),
    ],
    duration: Duration(milliseconds: 600),
    delay: Duration(milliseconds: 100),
  ),
)
```

---

## المعاملات 🔧

| المعامل          | النوع       | الافتراضي | الوصف                                             |
| ---------------- | ----------- | --------- | ------------------------------------------------- |
| `index`          | `int`       | **مطلوب** | موضع العنصر في القائمة                            |
| `child`          | `Widget`    | **مطلوب** | الـ Widget المراد تطبيق الأنميشن عليه             |
| `duration`       | `Duration`  | 800ms     | مدة الأنميشن الكاملة                              |
| `delay`          | `Duration?` | null      | تأخير مخصص (يُحسب تلقائياً من index إذا كان null) |
| `verticalOffset` | `double`    | 60.0      | المسافة التي ينزلق منها العنصر                    |

---

## نصائح وحيل 💡

### 1. تغيير منحنى الأنميشن:

عدّل قيمة `scale` في `ScaleAnimation`:

```dart
ScaleAnimation(scale: 0.95, child: widget) // تكبير أكبر
ScaleAnimation(scale: 0.8, child: widget)  // تكبير أصغر
```

### 2. استخدام في RefreshIndicator:

```dart
RefreshIndicator(
  onRefresh: () async => await loadData(),
  child: ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      return PageAnimationWrapper(
        index: index,
        child: ItemWidget(item: items[index]),
      );
    },
  ),
)
```

### 3. دعم الاتجاه من اليمين لليسار (RTL):

الأنميشن يدعم RTL تلقائياً بواسطة `flutter_staggered_animations`.

---

## الملفات ذات الصلة 📁

- `lib/core/animations/page_animation_wrapper.dart` - الأنميشن الرئيسي
- `lib/features/home/widget/products_content.dart` - مثال الاستخدام في المنتجات
- `lib/features/order/view/orde_view.dart` - مثال الاستخدام في الطلبات
- `lib/features/cart/view/cart_item_list.dart` - مثال الاستخدام في السلة

---

## الترخيص 📄

هذا الأنميشن مفتوح المصدر ويمكن استخدامه في أي مشروع تجاري أو غير تجاري.

---

## الدعم 🤝

إذا واجهت أي مشاكل أو عندك اقتراحات، لا تتردد في التواصل!
