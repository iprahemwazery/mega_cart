import 'package:mega_cart/core/NetWork/api_service.dart';
import 'package:mega_cart/features/home/data/models/product.dart';

abstract class HomeRemoteDataSource {
  Future<ProductResponse> getProducts({
    String? searchTerm,
    int page,
    int pageSize,
  });
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiService apiService;

  HomeRemoteDataSourceImpl(this.apiService);

  @override
  Future<ProductResponse> getProducts({
    String? searchTerm,
    int page = 1,
    int pageSize = 10,
  }) async {
    return await apiService.getProducts(
      searchTerm: searchTerm,
      page: page,
      pageSize: pageSize,
    );
  }
}
