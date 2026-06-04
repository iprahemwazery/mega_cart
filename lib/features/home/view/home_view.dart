import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_cart/features/home/cubit/home_cubit.dart';
import 'package:mega_cart/features/home/cubit/category_cubit.dart'; // Import CategoryCubit
import 'package:mega_cart/features/home/cubit/home_state.dart';
import 'package:mega_cart/features/home/widget/home_header.dart'; // استيراد ويدجت الرأس الجديد
import 'package:mega_cart/features/home/widget/products_content.dart';
import 'package:mega_cart/features/home/widget/categories_content.dart';
import 'package:mega_cart/features/home/widget/search_results_overlay.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) => current.status == HomeStatus.failure,
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 8),
              // BlocSelector for HomeHeader
              BlocSelector<HomeCubit, HomeState, (String, bool, bool)>(
                selector: (state) => (
                  state.userEmail,
                  state.showCategories,
                  state.isSearchOverlayVisible,
                ),
                builder: (context, data) {
                  final userEmail = data.$1;
                  final showCategories = data.$2;
                  final isSearchOverlayVisible = data.$3;
                  final homeCubit = context.read<HomeCubit>();
                  return HomeHeader(
                    userEmail: userEmail,
                    onHomePressed: () {
                      homeCubit.toggleCategories(false);
                      homeCubit.loadProducts();
                    },
                    onCategoryPressed: () {
                      homeCubit.toggleCategories(true);
                      context.read<CategoryCubit>().getCategories();
                    },
                    showCategories: showCategories,
                    isSearching: isSearchOverlayVisible,
                    onSearchModeChanged: (isSearching) {
                      homeCubit.updateSearchOverlay(isSearching);
                    },
                    onSearchChanged: (value) {
                      homeCubit.updateSearchTerm(value);
                    },
                    onSearchSubmitted: (value) {
                      homeCubit.updateSearchTerm(value, immediate: true);
                    },
                  );
                },
              ),
              Expanded(
                child: Stack(
                  children: [
                    // BlocSelector for CategoriesContent / ProductsContent
                    BlocSelector<HomeCubit, HomeState, bool>(
                      selector: (state) => state.showCategories,
                      builder: (context, showCategories) {
                        if (showCategories) {
                          return const CategoriesContent();
                        } else {
                          return const ProductsContent();
                        }
                      },
                    ),

                    // BlocSelector for SearchResultsOverlay
                    BlocSelector<HomeCubit, HomeState, bool>(
                      selector: (state) => state.isSearchOverlayVisible,
                      builder: (context, isSearchOverlayVisible) {
                        if (isSearchOverlayVisible) {
                          return BlocSelector<HomeCubit, HomeState, HomeState>(
                            selector: (state) =>
                                state, // Pass the whole state to SearchResultsOverlay
                            builder: (context, searchState) {
                              return SearchResultsOverlay(state: searchState);
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
