import 'package:dartz/dartz.dart';
import 'package:mega_cart/core/NetWork/api_service.dart';
import 'package:mega_cart/core/NetWork/failure.dart';
import 'package:mega_cart/core/models/product.dart';
import 'package:mega_cart/features/home/view/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ApiService _apiService;

  HomeRepositoryImpl(this._apiService);

  @override
  Future<Either<Failure, ProductResponse>> fetchProducts({
    String? searchTerm,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _apiService.getProducts(
        searchTerm: searchTerm,
        page: page,
        pageSize: pageSize,
      );
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
