import 'package:flutter/material.dart';
import 'package:get/get.dart'; // يمكن استخدامها للتنقل أو إظهار الـ snackbar
import 'package:mega_cart/features/home/widget/promo_card.dart';

class HomeHeader extends StatefulWidget {
  final String userEmail;

  // Callbacks for button presses
  final VoidCallback onHomePressed;
  final VoidCallback onCategoryPressed;
  final bool showCategories; // To highlight the active button
  final Function(String)? onSearchChanged; // Callback للبحث
  final Function(bool)? onSearchModeChanged; // إخبار الأب بحالة البحث
  final bool isSearching; // بارامتر جديد للتحكم من الخارج
  const HomeHeader({
    super.key,
    required this.userEmail,
    required this.onHomePressed,
    required this.onCategoryPressed,
    required this.showCategories,
    required this.isSearching,
    this.onSearchChanged,
    this.onSearchModeChanged,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  late PageController _pageController;
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  final RxInt _currentPage = 0.obs;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage.value);
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant HomeHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    // إذا تم إغلاق البحث من الخارج، قم بمسح نص البحث
    if (oldWidget.isSearching && !widget.isSearching) {
      _searchController.clear();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  String get userNameDisplay {
    if (widget.userEmail.contains('@')) {
      return widget.userEmail.split('@').first;
    }
    return widget.userEmail;
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
            widget.isSearching
                ? Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          widget.onSearchModeChanged?.call(false);
                          _searchController.clear();
                          widget.onSearchChanged?.call('');
                        },
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Search products...',
                            border: InputBorder.none,
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 20),
                                    onPressed: () {
                                      _searchController.clear();
                                      widget.onSearchChanged?.call('');
                                      setState(
                                        () {},
                                      ); // لتحديث الواجهة وإخفاء الزر
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (value) {
                            setState(() {}); // لإظهار زر X عند بدء الكتابة
                            widget.onSearchChanged?.call(value);
                          },
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // الجانب الأيسر: صورة المستخدم، الاسم، البريد الإلكتروني
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.blue.shade200,
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userNameDisplay,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                widget.userEmail,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.search,
                              color: Colors.black87,
                              size: 24,
                            ),
                            onPressed: () {
                              widget.onSearchModeChanged?.call(true);
                              _searchFocusNode.requestFocus();
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_none,
                              color: Colors.black87,
                              size: 24,
                            ),
                            onPressed: () {
                              Get.snackbar(
                                'الإشعارات',
                                'تم الضغط على زر الإشعارات!',
                              );
                            },
                          ),
                        ],
                      ),
                    ],
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
