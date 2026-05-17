import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/app_router.dart';
import 'package:mega_cart/features/home/controller/home_controller.dart';
import 'package:mega_cart/features/home/widget/product_card.dart';

// تم نقل ProductCard إلى ملف lib/features/home/widget/product_card.dart
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'home_add_product_fab',
        onPressed: () {
          Get.toNamed(AppRoutes.createProduct);
        },
        child: const Icon(Icons.add),
        tooltip: 'إضافة منتج جديد',
      ),
      appBar: AppBar(title: const Text('Mega Cart'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value && controller.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value && controller.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Failed to load products',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.loadProducts(),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // User info
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade50,
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    'Welcome back, ${controller.userEmail.value}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Products grid
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.loadProducts(),
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount:
                      controller.products.length +
                      (controller.hasNextPage.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.products.length) {
                      // Load more indicator
                      if (controller.isLoadingMore.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      // Trigger load more when reaching the end
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        controller.loadProducts(loadMore: true);
                      });
                      return const SizedBox.shrink();
                    }

                    final product = controller.products[index];
                    return GestureDetector(
                      onTap: () => Get.toNamed(
                        AppRoutes
                            .productDetails, // تأكد من تسمية المسار في AppRoutes
                        arguments: product.id,
                      ),
                      child: ProductCard(product: product),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
