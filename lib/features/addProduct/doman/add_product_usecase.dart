import 'package:dartz/dartz.dart';
import 'package:mega_cart/core/NetWork/failure.dart';
import 'package:mega_cart/features/addProduct/data/model/add_product_repository.dart';
import 'package:mega_cart/features/addProduct/data/model/create_product_request.dart';

class AddProductUseCase {
  final AddProductRepository repository;

  AddProductUseCase(this.repository);

  Future<Either<Failure, void>> call(CreateProductRequest request) async {
    return await repository.createProduct(request);
  }
}
