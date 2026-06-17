import 'package:dartz/dartz.dart';
import 'package:mega_cart/core/NetWork/failure.dart';
import 'package:mega_cart/features/addProduct/data/model/create_product_request.dart';

// This file is already in the correct domain/repositories structure.
abstract class AddProductRepository {
  Future<Either<Failure, void>> createProduct(CreateProductRequest request);
}
