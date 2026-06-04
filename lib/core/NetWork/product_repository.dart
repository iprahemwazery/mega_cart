import 'package:dartz/dartz.dart';
import 'package:mega_cart/core/NetWork/failure.dart';
import 'package:mega_cart/core/models/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, Product>> getProductDetails(String id);
  Future<Either<Failure, dynamic>> addProduct({
    required String sellerId,
    required String name,
    required String description,
    required String nameArabic,
    required String descriptionArabic,
    required double price,
    required String coverPictureUrl,
  });
  Future<Either<Failure, dynamic>> deleteProduct(String id);
}
