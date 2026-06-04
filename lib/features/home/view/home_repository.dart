import 'package:dartz/dartz.dart';
import 'package:mega_cart/core/NetWork/failure.dart';
import 'package:mega_cart/core/models/product.dart';

abstract class HomeRepository {
  Future<Either<Failure, ProductResponse>> fetchProducts({
    String? searchTerm,
    int page,
    int pageSize,
  });
}
