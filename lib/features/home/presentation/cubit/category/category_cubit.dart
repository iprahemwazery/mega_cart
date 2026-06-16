import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_cart/features/home/presentation/cubit/category/category_state.dart';
import 'package:mega_cart/features/home/data/models/category.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(const CategoryState());

  void getCategories() async {
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      await Future.delayed(const Duration(seconds: 1));
      final List<Category> fetchedCategories = [
        const Category(
          id: '1',
          name: "New Arrivals",
          description: "208 Product",
          coverPictureUrl:
              "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=500",
        ),
        const Category(
          id: '2',
          name: "Clothes",
          description: "358 Product",
          coverPictureUrl:
              "https://images.unsplash.com/photo-1529139574466-a303027c1d8b?q=80&w=500",
        ),
        const Category(
          id: '3',
          name: "Bags",
          description: "160 Product",
          coverPictureUrl:
              "https://images.unsplash.com/photo-1584917865442-de89df76afd3?q=80&w=500",
        ),
        const Category(
          id: '4',
          name: "Shoes",
          description: "230 Product",
          coverPictureUrl:
              "https://images.unsplash.com/photo-1549298916-b41d501d3772?q=80&w=600&auto=format&fit=crop",
        ),
        const Category(
          id: '5',
          name: "Electronics",
          description: "170 Product",
          coverPictureUrl:
              "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=500",
        ),
        const Category(
          id: '6',
          name: "Accessories",
          description: "145 Product",
          coverPictureUrl:
              "https://images.unsplash.com/photo-1576053139778-7e32f2ae3cfd?q=80&w=500",
        ),
        const Category(
          id: '7',
          name: "Watches",
          description: "85 Product",
          coverPictureUrl:
              "https://images.unsplash.com/photo-1524592094714-0f0654e20314?q=80&w=600&auto=format&fit=crop",
        ),
      ];
      emit(
        state.copyWith(
          status: CategoryStatus.success,
          categories: fetchedCategories,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CategoryStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
