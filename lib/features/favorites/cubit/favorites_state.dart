import 'package:equatable/equatable.dart';
import 'package:mega_cart/core/models/product.dart';

class FavoritesState extends Equatable {
  final List<Product> favorites;

  const FavoritesState({this.favorites = const []});

  @override
  List<Object?> get props => [favorites];
}
