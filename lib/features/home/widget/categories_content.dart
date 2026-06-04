import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mega_cart/features/home/cubit/category_cubit.dart';
import 'package:mega_cart/features/home/cubit/category_state.dart';
import 'package:mega_cart/features/home/widget/static_categories_content.dart';

class CategoriesContent extends StatelessWidget {
  const CategoriesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, categoryState) {
        if (categoryState.status == CategoryStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (categoryState.status == CategoryStatus.failure) {
          return Center(
            child: Text(
              categoryState.errorMessage ?? 'Error loading categories',
            ),
          );
        }
        if (categoryState.categories.isEmpty) {
          return Center(child: Text('noCategoriesFound'.tr));
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categoryState.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryState.categories[index];
                    return StaticCategoriesContent.buildCategoryCard(
                      category,
                      index,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
