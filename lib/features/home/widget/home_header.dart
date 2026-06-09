import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart'; // يمكن استخدامها للتنقل أو إظهار الـ snackbar
import 'package:mega_cart/features/home/widget/promo_card.dart';

class HomeHeader extends StatefulWidget {
  final String userEmail;
  final String? userImageUrl; // متغير جديد لرابط الصورة

  // Callbacks for button presses
  final VoidCallback onHomePressed;
  final VoidCallback onCategoryPressed;
  final bool showCategories; // To highlight the active button
  final Function(String)? onSearchChanged; // Callback للبحث
  final Function(String)?
  onSearchSubmitted; // Callback عند الضغط على زر البحث في الكيبورد
  final Function(bool)? onSearchModeChanged; // إخبار الأب بحالة البحث
  final bool isSearching; // بارامتر جديد للتحكم من الخارج
  const HomeHeader({
    super.key,
    required this.userEmail,
    this.userImageUrl,
    required this.onHomePressed,
    required this.onCategoryPressed,
    required this.showCategories,
    required this.isSearching,
    this.onSearchChanged,
    this.onSearchSubmitted,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.isSearching
                ? Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: colorScheme.onSurface,
                        ),
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
                          style: TextStyle(color: colorScheme.onSurface),
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: 'searchResults'.tr,
                            border: InputBorder.none,
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      size: 20,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      widget.onSearchModeChanged?.call(false);
                                      widget.onSearchChanged?.call('');
                                      setState(() {});
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (value) {
                            setState(() {});
                            widget.onSearchChanged?.call(value);
                          },
                          onSubmitted: (value) {
                            widget.onSearchSubmitted?.call(value);
                          },
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: colorScheme.surfaceVariant,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: widget.userImageUrl ?? '',
                                fit: BoxFit.cover,
                                width: 32,
                                height: 32,
                                placeholder: (context, url) => Center(
                                  child: SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.person,
                                  color: colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userNameDisplay,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                widget.userEmail,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.onSurfaceVariant,
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
                            icon: Icon(
                              Icons.search,
                              color: colorScheme.onSurface,
                              size: 24,
                            ),
                            onPressed: () {
                              widget.onSearchModeChanged?.call(true);
                              _searchFocusNode.requestFocus();
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.notifications_none,
                              color: colorScheme.onSurface,
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
            const SizedBox(height: 12),
            if (!widget.isSearching) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: widget.onHomePressed,
                    style: TextButton.styleFrom(
                      backgroundColor: !widget.showCategories
                          ? colorScheme.primary
                          : colorScheme.surfaceVariant,
                      foregroundColor: !widget.showCategories
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                    ),
                    child: Text('home'.tr),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: widget.onCategoryPressed,
                    style: TextButton.styleFrom(
                      backgroundColor: widget.showCategories
                          ? colorScheme.primary
                          : colorScheme.surfaceVariant,
                      foregroundColor: widget.showCategories
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                    ),
                    child: Text('account'.tr),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 110,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 3,
                  onPageChanged: (index) {
                    _currentPage.value = index;
                  },
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const Align(
                        alignment: Alignment.topCenter,
                        child: PromoCard(
                          promoText:
                              '24% off Shipping today \n on bag purchase',
                          byText: 'by, MegaCart',
                        ),
                      );
                    } else if (index == 1) {
                      return const Align(
                        alignment: Alignment.topCenter,
                        child: PromoCard(
                          promoText:
                              'Summer Sale! Up to 50% off \n selected items',
                          byText: 'by, MegaCart Deals',
                        ),
                      );
                    } else {
                      return const Align(
                        alignment: Alignment.topCenter,
                        child: PromoCard(
                          promoText:
                              'New Arrivals! Explore \n our latest collection',
                          byText: 'by, MegaCart Fashion',
                        ),
                      );
                    }
                  },
                ),
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage.value == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage.value == index
                            ? colorScheme.primary
                            : colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}
