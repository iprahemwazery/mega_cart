import 'package:dartz/dartz.dart';
import 'package:mega_cart/core/NetWork/api_service.dart';
import 'package:mega_cart/core/NetWork/failure.dart';
import 'package:mega_cart/core/models/product.dart';
import 'package:mega_cart/core/models/create_product_request.dart';

abstract class ProductRepository {
  Future<Either<Failure, Product>> getProductDetails(String id);

  // New abstract method for adding a product
  Future<Either<Failure, dynamic>> addProduct({
    required String sellerId,
    required String name,
    required String description,
    required String nameArabic,
    required String descriptionArabic,
    required double price,
    required String coverPictureUrl,
  });

  // New abstract method for deleting a product
  Future<Either<Failure, dynamic>> deleteProduct(String id);
}
