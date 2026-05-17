import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:mega_cart/core/NetWork/product_repository.dart';
import 'package:mega_cart/features/singelProfuct/data/product_details_state.dart';
import 'package:mega_cart/core/NetWork/failure.dart';
import 'package:mega_cart/core/models/product.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ProductRepository repository;

  ProductDetailsCubit(this.repository) : super(ProductDetailsInitial());

  Future<void> loadProduct(String id) async {
    emit(ProductDetailsLoading());

    final Either<Failure, Product> result = await repository.getProductDetails(
      id,
    );

    result.fold(
      (failure) => emit(ProductDetailsError(failure.message)),
      (product) => emit(ProductDetailsSuccess(product)),
    );
  }
}
