import 'package:equatable/equatable.dart';
import 'package:mega_cart/core/models/product.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Product> products;
  final List<Product> allAvailableProducts;
  final List<String> searchHistory;
  final bool showCategories;
  final bool isSearchOverlayVisible;
  final String searchTerm;
  final String userEmail;
  final bool isLoadingMore;
  final bool hasNextPage;
  final int page;
  final int pageSize;
  final int totalCount;
  final bool hasPreviousPage;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.products = const [],
    this.allAvailableProducts = const [],
    this.searchHistory = const [],
    this.showCategories = false,
    this.isSearchOverlayVisible = false,
    this.searchTerm = '',
    this.userEmail = '',
    this.isLoadingMore = false,
    this.hasNextPage = true,
    this.page = 1,
    this.pageSize = 10,
    this.totalCount = 0,
    this.hasPreviousPage = false,
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<Product>? products,
    List<Product>? allAvailableProducts,
    List<String>? searchHistory,
    bool? showCategories,
    bool? isSearchOverlayVisible,
    String? searchTerm,
    String? userEmail,
    bool? isLoadingMore,
    bool? hasNextPage,
    int? page,
    int? pageSize,
    int? totalCount,
    bool? hasPreviousPage,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      products: products ?? this.products,
      allAvailableProducts: allAvailableProducts ?? this.allAvailableProducts,
      searchHistory: searchHistory ?? this.searchHistory,
      showCategories: showCategories ?? this.showCategories,
      isSearchOverlayVisible:
          isSearchOverlayVisible ?? this.isSearchOverlayVisible,
      searchTerm: searchTerm ?? this.searchTerm,
      userEmail: userEmail ?? this.userEmail,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    allAvailableProducts,
    searchHistory,
    showCategories,
    isSearchOverlayVisible,
    searchTerm,
    userEmail,
    isLoadingMore,
    hasNextPage,
    page,
    pageSize,
    totalCount,
    hasPreviousPage,
    errorMessage,
  ];
}
