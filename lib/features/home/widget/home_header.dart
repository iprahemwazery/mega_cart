import 'package:flutter/material.dart';
import 'package:get/get.dart'; // يمكن استخدامها للتنقل أو إظهار الـ snackbar
import 'package:mega_cart/features/home/widget/promo_card.dart';

class HomeHeader extends StatefulWidget {
  final String userEmail;

  // Callbacks for button presses
  final VoidCallback onHomePressed;
  final VoidCallback onCategoryPressed;
  final bool showCategories; // To highlight the active button
  const HomeHeader({
    super.key,
    required this.userEmail,
    required this.onHomePressed,
    required this.onCategoryPressed,
    required this.showCategories,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  // PageController لإدارة الـ PageView
  late PageController _pageController;

  // متغير لمراقبة الصفحة الحالية (يمكن أن يكون RxInt إذا كان الـ Header ويدجت تفاعلي)
  // بما أنه StatelessWidget، سنستخدمه فقط لتحديث مؤشر الصفحات
  final RxInt _currentPage = 0.obs; // هذا المتغير خاص بالـ PageView فقط

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage.value);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // دالة بسيطة لاستخراج اسم المستخدم من البريد الإلكتروني
  String get userNameDisplay {
    if (widget.userEmail.contains('@')) {
      return widget.userEmail.split('@').first;
    }
    return widget.userEmail; // إذا لم يكن هناك @، نعرض البريد كاملاً
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // تقليل الـ padding لتقليل الارتفاع الكلي
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ), // إزالة الـ padding الأفقي هنا
      decoration: BoxDecoration(
        color: Colors.transparent, // لون خلفية الرأس
      ),
      child: SafeArea(
        // لضمان عدم تداخل المحتوى مع شريط الحالة (status bar)
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // الجانب الأيسر: صورة المستخدم، الاسم، البريد الإلكتروني
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16, // تقليل حجم الصورة الشخصية
                      backgroundColor:
                          Colors.blue.shade200, // لون خلفية الأيقونة
                      child: const Icon(
                        Icons.person, // Changed from Image to Icon
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10), // تقليل المسافة
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userNameDisplay,
                          style: const TextStyle(
                            fontSize: 16, // تقليل حجم خط الاسم
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          widget.userEmail,
                          style: TextStyle(
                            // تقليل حجم خط البريد الإلكتروني
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const Spacer(), // يدفع الأيقونات اليمنى إلى أقصى اليمين
                // الجانب الأيمن: أيقونات الإشعارات والبحث
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.black87,
                        size: 24,
                      ), // تقليل حجم الأيقونة
                      onPressed: () {
                        // TODO: إضافة منطق التنقل إلى شاشة البحث
                        Get.snackbar('البحث', 'تم الضغط على زر البحث!');
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none,
                        color: Colors.black87,
                        size: 24,
                      ), // تقليل حجم الأيقونة
                      onPressed: () {
                        // TODO: إضافة منطق التنقل إلى شاشة الإشعارات
                        Get.snackbar('الإشعارات', 'تم الضغط على زر الإشعارات!');
                      },
                    ),
                  ],
                ),
              ], // توزيع العناصر بشكل متساوٍ
            ),
            const SizedBox(height: 30), // تقليل المسافة بين الصفوف
            Row(
              children: [
                Spacer(),
                TextButton(
                  onPressed: widget.onHomePressed,
                  style: TextButton.styleFrom(
                    backgroundColor: !widget.showCategories
                        ? Colors.blueAccent
                        : Colors.grey[200],
                    foregroundColor: !widget.showCategories
                        ? Colors.white
                        : Colors.black87,
                  ),
                  child: const Text('Home'),
                ),
                Spacer(),
                TextButton(
                  onPressed: widget.onCategoryPressed,
                  style: TextButton.styleFrom(
                    backgroundColor: widget.showCategories
                        ? Colors.blueAccent
                        : Colors.grey[200],
                    foregroundColor: widget.showCategories
                        ? Colors.white
                        : Colors.black87,
                  ),
                  child: const Text('Category'),
                ),
                Spacer(),
              ],
            ),
            const SizedBox(height: 20), // المسافة قبل الـ PageView
            SizedBox(
              height: 150, // نفس ارتفاع الـ PromoCard
              child: PageView.builder(
                controller: _pageController,
                itemCount: 3, // ثلاث نسخ من الـ PromoCard
                onPageChanged: (index) {
                  _currentPage.value = index; // تحديث الصفحة الحالية
                },
                itemBuilder: (context, index) {
                  // نصوص مختلفة لكل PromoCard
                  if (index == 0) {
                    return const PromoCard(
                      promoText: '24% off Shipping today \n on bag purchase',
                      byText: 'by, MegaCart',
                    );
                  } else if (index == 1) {
                    return const PromoCard(
                      promoText: 'Summer Sale! Up to 50% off \n selected items',
                      byText: 'by, MegaCart Deals',
                    );
                  } else {
                    return const PromoCard(
                      promoText:
                          'New Arrivals! Explore \n our latest collection',
                      byText: 'by, MegaCart Fashion',
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 10), // المسافة بين الـ PageView والمؤشر
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3, // ثلاث نقاط لكل صفحة
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentPage.value == index
                        ? 24
                        : 8, // النقطة النشطة أطول
                    decoration: BoxDecoration(
                      color: _currentPage.value == index
                          ? Colors.blueAccent
                          : Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
