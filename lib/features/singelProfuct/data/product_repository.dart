import 'package:dartz/dartz.dart';
import 'package:mega_cart/core/NetWork/api_service.dart';
import 'package:mega_cart/core/NetWork/failure.dart';
import 'package:mega_cart/features/home/data/models/product.dart';
import 'package:mega_cart/features/addProduct/data/model/create_product_request.dart';
import 'package:mega_cart/core/NetWork/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiService apiService;
  ProductRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, Product>> getProductDetails(String id) async {
    try {
      final result = await apiService.getProductById(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createProduct(
    CreateProductRequest request, {
    String? token,
  }) async {
    try {
      await apiService.addProduct(request);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Implementation of the new addProduct method
  @override
  Future<Either<Failure, dynamic>> addProduct({
    required String sellerId,
    required String name,
    required String description,
    required String nameArabic,
    required String descriptionArabic,
    required double price,
    required String coverPictureUrl,
  }) async {
    try {
      final request = CreateProductRequest(
        sellerId: sellerId,
        name: name,
        description: description,
        nameArabic: nameArabic,
        descriptionArabic: descriptionArabic,
        coverPictureUrl: coverPictureUrl,
        price: price,
        stock: 10,
        weight: 0.5,
        color: "Default",
        discountPercentage: 0,
        categoryIds: [],
        productPictureUrls: [],
      );
      await apiService.addProduct(request);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Implementation of the new deleteProduct method
  @override
  Future<Either<Failure, dynamic>> deleteProduct(String id) async {
    try {
      await apiService.deleteProduct(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
