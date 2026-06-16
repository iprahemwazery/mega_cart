import 'package:dartz/dartz.dart';
import 'package:mega_cart/core/NetWork/failure.dart';
import 'package:mega_cart/features/home/domain/product_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, ProductPaginationEntity>> fetchProducts({
    String? searchTerm,
    int page,
    int pageSize,
  });
}
