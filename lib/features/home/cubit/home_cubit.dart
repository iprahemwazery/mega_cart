import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mega_cart/features/home/cubit/home_state.dart';
import 'package:mega_cart/core/models/product.dart';
import 'package:mega_cart/features/home/view/home_repository.dart';
import 'package:mega_cart/features/splashScreen/view/session_manager.dart'; // Import SessionManager
import 'package:flutter/foundation.dart'; // For debugPrint

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;
  Timer? _searchTimer;
  final _storage = GetStorage();
  static const String _historyKey = 'search_history';

  HomeCubit(this._repository) : super(const HomeState()) {
    _loadUserData(); // Load user data when Cubit is created
    _loadSearchHistory(); // تحميل السجل عند البداية
  }

  Future<void> loadProducts({
    bool loadMore = false,
    bool isRefresh = false,
    String? searchTerm,
  }) async {
    // Prevent multiple concurrent loads
    if (state.status == HomeStatus.loading || state.isLoadingMore) return;

    // No more pages to load if trying to load more
    if (loadMore && !state.hasNextPage) return;

    final int nextPage = loadMore ? state.page + 1 : 1;
    final String currentSearchTerm = searchTerm ?? state.searchTerm;

    if (loadMore) {
      emit(state.copyWith(isLoadingMore: true));
    } else if (!isRefresh) {
      // Clear products only on initial load or new search, not on pull-to-refresh
      emit(state.copyWith(status: HomeStatus.loading, products: []));
    }

    try {
      final result = await _repository.fetchProducts(
        searchTerm: currentSearchTerm,
        page: nextPage,
        pageSize: state.pageSize,
      );

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: HomeStatus.failure,
              errorMessage: failure.message,
              isLoadingMore: false,
            ),
          );
        },
        (productResponse) {
          final List<Product> updatedProducts = loadMore
              ? [...state.products, ...productResponse.items]
              : productResponse.items;

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
    }
  }

  void toggleCategories(bool show) {
    emit(state.copyWith(showCategories: show));
  }

  void updateSearchOverlay(bool isVisible) {
    emit(state.copyWith(isSearchOverlayVisible: isVisible));
  }

  void updateSearchTerm(String term, {bool immediate = false}) {
    // إلغاء التايمر القديم إذا كان لا يزال يعمل
    _searchTimer?.cancel();

    if (term.trim().isEmpty) {
      // مسح النتائج فوراً إذا كان الحقل فارغاً للعودة لعرض سجل البحث
      emit(
        state.copyWith(
          searchTerm: '',
          products: [],
          status: HomeStatus.initial,
        ),
      );
      return;
    }

    // تحديث الحالة فوراً لإظهار الـ Shimmer ومنع ظهور منتجات الهوم القديمة كـ "نتائج مقترحة"
    emit(
      state.copyWith(
        searchTerm: term,
        status: HomeStatus.loading,
        products: [], // مسح القائمة الحالية فوراً
      ),
    );

    if (immediate) {
      loadProducts(searchTerm: term);
    } else {
      // بدء تايمر جديد: سيتم تنفيذ البحث فقط إذا توقف المستخدم عن الكتابة لمدة 500ms
      _searchTimer = Timer(const Duration(milliseconds: 500), () {
        loadProducts(searchTerm: term);
      });
    }
  }

  // تحميل السجل من التخزين المحلي
  void _loadSearchHistory() {
    final List<dynamic>? history = _storage.read(_historyKey);
    if (history != null) {
      emit(state.copyWith(searchHistory: List<String>.from(history)));
    }
  }

  // إضافة كلمة للسجل
  void addToHistory(String term) {
    if (term.trim().isEmpty) return;

    List<String> currentHistory = List.from(state.searchHistory);
    currentHistory.remove(
      term,
    ); // حذف الكلمة إذا كانت موجودة مسبقاً لرفعها للأعلى
    currentHistory.insert(0, term);

    if (currentHistory.length > 10)
      currentHistory = currentHistory.sublist(
        0,
        10,
      ); // الاحتفاظ بآخر 10 عمليات بحث

    _storage.write(_historyKey, currentHistory);
    emit(state.copyWith(searchHistory: currentHistory));
  }

  // حذف عنصر واحد من السجل
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
    // تنظيف التايمر عند إغلاق الكيوبت لمنع تسريب الذاكرة
    _searchTimer?.cancel();
    return super.close();
  }
}
