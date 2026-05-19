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
              ),
            ),
            // هذا الجزء هو فقط ما سيتغير ويظهر فيه التحميل
            Expanded(
              child: Obx(() {
                // حالة عرض المنتجات
                if (!homeController.showCategories.value) {
                  if (homeController.isLoading.value &&
                      homeController.products.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (homeController.hasError.value &&
                      homeController.products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Failed to load products',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            homeController.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => homeController.loadProducts(),
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    );
                  }
                  return _buildProductsContent(homeController);
                }

                // حالة عرض الأقسام
                if (categoryController.isLoading.value &&
                    categoryController.categories.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (categoryController.hasError.value &&
                    categoryController.categories.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          categoryController.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => categoryController.getCategories(),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }
                return StaticCategoriesContent();
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت منفصل لعرض شبكة المنتجات
  Widget _buildProductsContent(HomeController homeController) {
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
