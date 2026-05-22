import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/app_router.dart';
import 'package:mega_cart/features/home/controller/category_controller.dart';
import 'package:mega_cart/features/home/controller/home_controller.dart';
import 'package:mega_cart/features/home/widget/home_header.dart'; // استيراد ويدجت الرأس الجديد
import 'package:mega_cart/features/home/widget/product_card.dart';
import 'package:mega_cart/features/home/widget/static_categories_content.dart';

// تم نقل ProductCard إلى ملف lib/features/home/widget/product_card.dart
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());
    final categoryController = Get.put(CategoryController());

    return Scaffold(
      // floatingActionButton: Obx(
      //   () => FloatingActionButton(
      //     heroTag: 'home_add_product_fab',
      //     onPressed: () {
      //       Get.toNamed(AppRoutes.createProduct);
      //     },
      //     tooltip: 'إضافة منتج جديد',
      //     backgroundColor: homeController.showCategories.value
      //         ? Colors.grey
      //         : Theme.of(context).primaryColor,
      //     child: const Icon(Icons.add),
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // الهيدر يبقى ثابتاً دائماً ويحدث نفسه فقط عند الحاجة
            Obx(
              () => HomeHeader(
                userEmail: homeController.userEmail.value,
                onHomePressed: () {
                  homeController.showCategories.value = false;
                  homeController.loadProducts();
                },
                onCategoryPressed: () {
                  homeController.showCategories.value = true;
                  categoryController.getCategories();
                },
                showCategories: homeController.showCategories.value,
                isSearching: homeController.isSearchOverlayVisible.value,
                onSearchModeChanged: (isSearching) {
                  // الآن يتم تحديث المتغير في الكنترولر
                  homeController.isSearchOverlayVisible.value = isSearching;
                },
                onSearchChanged: (value) {
                  // تحديث نص البحث في الكنترولر واستدعاء وظيفة التحميل
                  // الـ debounce في الكنترولر سيتكفل باستدعاء loadProducts
                  homeController.searchTerm.value = value;
                },
              ),
            ),
            // هذا الجزء هو فقط ما سيتغير ويظهر فيه التحميل
            Expanded(
              child: Stack(
                children: [
                  // 1. المحتوى الأساسي (المنتجات أو الأقسام)
                  Obx(() {
                    if (!homeController.showCategories.value) {
                      return _buildProductsContent(homeController);
                    }
                    return StaticCategoriesContent();
                  }),

                  // 2. طبقة نتائج البحث (تظهر فوق المحتوى)
                  Obx(() {
                    if (homeController.isSearchOverlayVisible.value) {
                      // استخدام المتغير من الكنترولر
                      return Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: _buildSearchResultsOverlay(homeController),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت منفصل لنتائج البحث تظهر فوق المحتوى
  Widget _buildSearchResultsOverlay(HomeController homeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Search Results',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Obx(() {
            // الآن هذا الجزء سيحدث نفسه تلقائياً عند انتهاء التحميل أو تغير النتائج
            if (homeController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (homeController.products.isEmpty) {
              return const Center(child: Text('No products found.'));
            }
            return ListView.builder(
              itemCount: homeController.products.length,
              itemBuilder: (context, index) {
                final product = homeController.products[index];
                return ListTile(
                  leading: Image.network(
                    product.coverPictureUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.name),
                  subtitle: Text('\$${product.price}'),
                  onTap: () {
                    homeController.isSearchOverlayVisible.value = false;
                    homeController.searchTerm.value = '';
                    homeController.loadProducts();
                    Get.toNamed(AppRoutes.detail, arguments: product.id);
                  },
                );
              },
            );
          }),
        ),
      ],
    );
  }

  // ويدجت منفصل لعرض شبكة المنتجات
  Widget _buildProductsContent(HomeController homeController) {
    // إذا كانت القائمة فارغة والتحميل جارٍ، أظهر مؤشر تحميل مركزي
    if (homeController.isLoading.value && homeController.products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        if (!homeController.showCategories.value) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              'New Arrivals',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0.5, 0.5), // إزاحة الظل
                    blurRadius: 1.0, // نعومة الظل
                    color: Colors.black38,
                  ), // لون الظل وشفافيته
                ],
              ),
            ),
          ),
          // Products grid
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => homeController.loadProducts(),
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ), // إزالة الهامش الأفقي من هنا
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing:
                      12, // تقليل المسافة بين الكروت قليلاً للتناسق
                  mainAxisSpacing: 12,
                ),
                itemCount:
                    homeController.products.length +
                    (homeController.hasNextPage.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == homeController.products.length) {
                    // Load more indicator
                    if (homeController.isLoadingMore.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // Trigger load more when reaching the end
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      homeController.loadProducts(loadMore: true);
                    });
                    return const SizedBox.shrink();
                  }

                  final product = homeController.products[index];
                  return GestureDetector(
                    onTap: () =>
                        Get.toNamed(AppRoutes.detail, arguments: product.id),
                    child: ProductCard(product: product),
                  );
                },
              ),
            ),
          ),
        ] else ...[
          // Static Categories Content
          Expanded(child: StaticCategoriesContent()),
        ],
      ],
    );
  }
}
