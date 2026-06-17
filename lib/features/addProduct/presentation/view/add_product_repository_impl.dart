import 'package:dartz/dartz.dart';
import 'package:mega_cart/core/NetWork/api_service.dart';
import 'package:mega_cart/core/NetWork/failure.dart';
import 'package:mega_cart/features/addProduct/data/model/add_product_repository.dart';
import 'package:mega_cart/features/addProduct/data/model/create_product_request.dart';

// This file is already in the correct data/repositories structure.
class AddProductRepositoryImpl implements AddProductRepository {
  final ApiService apiService;

  AddProductRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, void>> createProduct(
    CreateProductRequest request,
  ) async {
    try {
      await apiService.addProduct(request);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
