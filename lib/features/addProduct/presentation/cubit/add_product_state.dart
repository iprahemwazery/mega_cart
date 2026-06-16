part of 'add_product_cubit.dart';

enum AddProductStatus { initial, loading, success, error }

class AddProductState extends Equatable {
  final AddProductStatus status;
  final String? errorMessage;
  final List<String> categoryIds;
  final List<String> productPictureUrls;

  const AddProductState({
    this.status = AddProductStatus.initial,
    this.errorMessage,
    this.categoryIds = const [],
    this.productPictureUrls = const [],
  });

  AddProductState copyWith({
    AddProductStatus? status,
    String? errorMessage,
    List<String>? categoryIds,
    List<String>? productPictureUrls,
  }) {
    return AddProductState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      categoryIds: categoryIds ?? this.categoryIds,
      productPictureUrls: productPictureUrls ?? this.productPictureUrls,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    categoryIds,
    productPictureUrls,
  ];
}

class AddProductInitial extends AddProductState {
  const AddProductInitial() : super(status: AddProductStatus.initial);
}

class AddProductLoading extends AddProductState {
  const AddProductLoading() : super(status: AddProductStatus.loading);
}

class AddProductSuccess extends AddProductState {
  const AddProductSuccess() : super(status: AddProductStatus.success);
}

class AddProductError extends AddProductState {
  const AddProductError(String message)
    : super(status: AddProductStatus.error, errorMessage: message);
}
