import 'package:equatable/equatable.dart';
import 'package:mega_cart/features/home/data/models/product.dart';

class FavoritesState extends Equatable {
  final List<Product> favorites;

  const FavoritesState({this.favorites = const []});

  @override
  List<Object?> get props => [favorites];
}
