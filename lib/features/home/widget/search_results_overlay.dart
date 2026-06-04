import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/app_router.dart';
import 'package:mega_cart/core/customs/shimmer_loading.dart';
import 'package:mega_cart/features/home/cubit/home_cubit.dart';
import 'package:mega_cart/features/home/cubit/home_state.dart';

class SearchResultsOverlay extends StatelessWidget {
  final HomeState state;

  const SearchResultsOverlay({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeCubit = context.read<HomeCubit>();

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                if (state.searchTerm.isEmpty) {
                  if (state.searchHistory.isEmpty) {
                    return Center(child: Text('noSearchHistory'.tr));
                  }
                  return _buildSearchHistory(theme, homeCubit);
                }

                if (state.status == HomeStatus.failure) {
                  return _buildErrorState(theme, homeCubit, state.errorMessage);
                }

                if (state.status == HomeStatus.loading) {
                  return _buildLoadingSuggestions();
                }

                if (state.products.isEmpty &&
                    state.status == HomeStatus.success) {
                  return Center(child: Text('noProductsFound'.tr));
                }

                return _buildProductSuggestions(theme, homeCubit);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHistory(ThemeData theme, HomeCubit homeCubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'recentSearches'.tr,
                style: theme.textTheme.labelLarge?.copyWith(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () => homeCubit.clearHistory(),
              child: Text(
                'clearAll'.tr,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: state.searchHistory.length,
            itemBuilder: (context, index) {
              final term = state.searchHistory[index];
              return ListTile(
                leading: const Icon(Icons.history, size: 20),
                title: Text(term),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => homeCubit.removeFromHistory(term),
                ),
                onTap: () => homeCubit.updateSearchTerm(term),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingSuggestions() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.search, color: Colors.grey),
        title: ShimmerLoading(
          child: Container(height: 15, width: 150, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildProductSuggestions(ThemeData theme, HomeCubit homeCubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'suggestedProducts'.tr,
            style: theme.textTheme.labelLarge?.copyWith(color: Colors.grey),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              final localizedName =
                  Get.locale?.languageCode == 'ar' &&
                      product.arabicName.isNotEmpty
                  ? product.arabicName
                  : product.name;

              return ListTile(
                leading: const Icon(Icons.search, size: 20, color: Colors.blue),
                title: Text(localizedName),
                trailing: const Icon(
                  Icons.north_west,
                  size: 16,
                  color: Colors.grey,
                ),
                onTap: () {
                  homeCubit.addToHistory(localizedName);
                  homeCubit.updateSearchOverlay(false);
                  homeCubit.updateSearchTerm('');
                  Get.toNamed(AppRoutes.detail, arguments: product.id);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(
    ThemeData theme,
    HomeCubit homeCubit,
    String? errorMessage,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              errorMessage ?? 'fetchError'.tr,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () =>
                  homeCubit.loadProducts(searchTerm: state.searchTerm),
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: Text(
                'retry'.tr,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
