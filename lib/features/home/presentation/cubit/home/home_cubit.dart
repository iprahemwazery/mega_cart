import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mega_cart/features/home/presentation/cubit/home/home_state.dart';
import 'package:mega_cart/features/home/data/models/product.dart';
import 'package:mega_cart/features/home/domain/get_products_use_case.dart';
import 'package:mega_cart/features/home/domain/get_products_params.dart';
import 'package:mega_cart/features/splashScreen/view/session_manager.dart';
import 'package:flutter/foundation.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetProductsUseCase _getProductsUseCase;
  Timer? _searchTimer;
  final _storage = GetStorage();
  static const String _historyKey = 'search_history';

  HomeCubit(this._getProductsUseCase) : super(const HomeState()) {
    _loadUserData(); // Load user data when Cubit is created
    _loadSearchHistory();
  }

  Future<void> loadProducts({
    bool loadMore = false,
    bool isRefresh = false,
    String? searchTerm,
  }) async {
    debugPrint(
      'loadProducts called: loadMore=$loadMore, isRefresh=$isRefresh, searchTerm=$searchTerm, currentStatus=${state.status}',
    );
    if (state.isLoadingMore) return;
    if (state.status == HomeStatus.loading &&
        !isRefresh &&
        searchTerm == null) {
      return;
    }

    if (loadMore && !state.hasNextPage) return;

    final int nextPage = loadMore ? state.page + 1 : 1;

    final String effectiveTerm = searchTerm ?? state.searchTerm;
    final String? query = effectiveTerm.trim().isEmpty
        ? null
        : effectiveTerm.trim();

    debugPrint('loadProducts - effective query: $query, nextPage: $nextPage');

    if (loadMore) {
      debugPrint('loadProducts - Emitting isLoadingMore: true');
      emit(state.copyWith(isLoadingMore: true));
    } else if (!isRefresh && query == null) {
      emit(
        state.copyWith(
          status: HomeStatus.loading,
          products: [],
          allAvailableProducts: [],
        ),
      );
    }

    try {
      final result = await _getProductsUseCase(
        GetProductsParams(
          searchTerm: query,
          page: nextPage,
          pageSize: state.pageSize,
        ),
      );
      debugPrint('loadProducts - API call finished for query: $query');

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: HomeStatus.failure,
              errorMessage: failure.message,
              isLoadingMore: false,
            ),
          );
          debugPrint('loadProducts - API call failed: ${failure.message}');
        },
        (productResponse) {
          List<Product> newProducts = productResponse.items.cast<Product>();
          debugPrint(
            'loadProducts - Success: fetched ${newProducts.length} items',
          );

          if (query == null) {
            final List<Product> updatedAllProducts = loadMore
                ? [...state.allAvailableProducts, ...newProducts]
                : newProducts;
            emit(
              state.copyWith(
                status: HomeStatus.success,
                products: updatedAllProducts,
                allAvailableProducts: updatedAllProducts,
                page: productResponse.page,
                pageSize: productResponse.pageSize,
                totalCount: productResponse.totalCount,
                hasNextPage: productResponse.hasNextPage,
                hasPreviousPage: productResponse.hasPreviousPage,
                isLoadingMore: false,
              ),
            );
          } else {
            if (newProducts.isEmpty && state.allAvailableProducts.isNotEmpty) {
              debugPrint(
                'Backend returned empty for "$query", performing local fallback search.',
              );
              final localFilteredProducts = state.allAvailableProducts.where((
                product,
              ) {
                final lowerCaseQuery = query.toLowerCase();
                return (product.name.toLowerCase().contains(lowerCaseQuery)) ||
                    (product.arabicName.toLowerCase().contains(lowerCaseQuery));
              }).toList();

              emit(
                state.copyWith(
                  status: HomeStatus.success,
                  products: localFilteredProducts,
                  page: productResponse.page,
                  pageSize: productResponse.pageSize,
                  totalCount: localFilteredProducts.length,
                  hasNextPage: false,
                  hasPreviousPage: false,
                  isLoadingMore: false,
                ),
              );
            } else {
              final List<Product> updatedProducts = loadMore
                  ? [...state.products, ...newProducts]
                  : newProducts;
              emit(
                state.copyWith(
                  status: HomeStatus.success,
                  products: updatedProducts,
                  page: productResponse.page,
                  pageSize: productResponse.pageSize,
                  totalCount: productResponse.totalCount,
                  hasNextPage: productResponse.hasNextPage,
                  hasPreviousPage: productResponse.hasPreviousPage,
                  isLoadingMore: false,
                ),
              );
            }
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: e.toString(),
          isLoadingMore: false,
        ),
      );
      debugPrint('loadProducts - Catch block error: $e');
    }
  }

  void toggleCategories(bool show) {
    emit(state.copyWith(showCategories: show));
  }

  void updateSearchOverlay(bool isVisible) {
    emit(state.copyWith(isSearchOverlayVisible: isVisible));
  }

  void updateSearchTerm(String term, {bool immediate = false}) {
    _searchTimer?.cancel();

    debugPrint('updateSearchTerm called: term=$term, immediate=$immediate');

    if (term.trim().isEmpty) {
      emit(state.copyWith(searchTerm: '', status: HomeStatus.loading));
      loadProducts(searchTerm: null, isRefresh: true);
      return;
    }

    emit(state.copyWith(searchTerm: term, status: HomeStatus.loading));

    if (immediate) {
      loadProducts(searchTerm: term);
    } else {
      _searchTimer = Timer(const Duration(milliseconds: 500), () {
        loadProducts(searchTerm: term);
      });
    }
  }

  void _loadSearchHistory() {
    final List<dynamic>? history = _storage.read(_historyKey);
    if (history != null) {
      emit(state.copyWith(searchHistory: List<String>.from(history)));
    }
  }

  void addToHistory(String term) {
    if (term.trim().isEmpty) return;

    List<String> currentHistory = List.from(state.searchHistory);
    currentHistory.remove(term);
    currentHistory.insert(0, term);

    if (currentHistory.length > 10) {
      currentHistory = currentHistory.sublist(0, 10);
    }

    _storage.write(_historyKey, currentHistory);
    emit(state.copyWith(searchHistory: currentHistory));
  }

  void removeFromHistory(String term) {
    List<String> currentHistory = List.from(state.searchHistory);
    currentHistory.remove(term);
    _storage.write(_historyKey, currentHistory);
    emit(state.copyWith(searchHistory: currentHistory));
  }

  void clearHistory() {
    _storage.remove(_historyKey);
    emit(state.copyWith(searchHistory: []));
  }

  Future<void> _loadUserData() async {
    try {
      final email = await SessionManager.getUserEmail();
      emit(state.copyWith(userEmail: email ?? ''));
    } catch (e) {
      debugPrint('Error loading user data in HomeCubit: $e');
      emit(state.copyWith(userEmail: ''));
    }
  }

  void setUserEmail(String email) {
    emit(state.copyWith(userEmail: email));
  }

  @override
  Future<void> close() {
    _searchTimer?.cancel();
    return super.close();
  }
}
