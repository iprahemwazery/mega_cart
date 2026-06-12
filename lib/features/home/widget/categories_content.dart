import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:mega_cart/features/home/cubit/category_cubit.dart';
import 'package:mega_cart/features/home/cubit/category_state.dart';
import 'package:mega_cart/features/order/widget/page_animation_wrapper.dart';
import 'package:mega_cart/features/home/widget/static_categories_content.dart';

class CategoriesContent extends StatelessWidget {
  const CategoriesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, categoryState) {
        if (categoryState.status == CategoryStatus.loading) {
          return ListView.builder(
            padding: const EdgeInsets.only(top: 10, bottom: 100),
            itemCount: 5, // عرض 5 عناصر مؤقتة أثناء التحميل
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => const CategorySkeleton(),
          );
        }
        if (categoryState.status == CategoryStatus.failure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.wifi_off_rounded,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(categoryState.errorMessage ?? 'fetchError'.tr),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () =>
                      context.read<CategoryCubit>().getCategories(),
                  child: Text('retry'.tr),
                ),
              ],
            ),
          );
        }
        if (categoryState.categories.isEmpty) {
          return Center(child: Text('noCategoriesFound'.tr));
        }
        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 10, bottom: 100),
            itemCount: categoryState.categories.length,
            itemBuilder: (context, index) {
              final category = categoryState.categories[index];
              final int reversedIndex =
                  (categoryState.categories.length - 1) - index;
              return PageAnimationWrapper(
                index: reversedIndex,
                delay: Duration(milliseconds: 150 * reversedIndex),
                child: StaticCategoriesContent.buildCategoryCard(
                  category,
                  index,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class CategorySkeleton extends StatelessWidget {
  const CategorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 160,
      decoration: BoxDecoration(
        color: Colors.grey[300]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.2), // تأثير بسيط يشبه اللمعان
        ),
      ),
    );
  }
}
