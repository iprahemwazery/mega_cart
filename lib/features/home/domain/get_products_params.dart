import 'package:equatable/equatable.dart';

class GetProductsParams extends Equatable {
  final String? searchTerm;
  final int page;
  final int pageSize;

  const GetProductsParams({this.searchTerm, this.page = 1, this.pageSize = 10});

  @override
  List<Object?> get props => [searchTerm, page, pageSize];

  GetProductsParams copyWith({String? searchTerm, int? page, int? pageSize}) {
    return GetProductsParams(
      searchTerm: searchTerm ?? this.searchTerm,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
