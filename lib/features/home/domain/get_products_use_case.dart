import 'package:dartz/dartz.dart';
import 'package:mega_cart/core/NetWork/failure.dart';
import 'package:mega_cart/features/home/domain/get_products_params.dart';
import 'package:mega_cart/features/home/domain/home_repository.dart';
import 'package:mega_cart/features/home/domain/product_entity.dart';

// يمكن تعريف UseCase عام لتوحيد الشكل
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class GetProductsUseCase
    implements UseCase<ProductPaginationEntity, GetProductsParams> {
  final HomeRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<Either<Failure, ProductPaginationEntity>> call(
    GetProductsParams params,
  ) async {
    return await repository.fetchProducts(
      searchTerm: params.searchTerm,
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}
