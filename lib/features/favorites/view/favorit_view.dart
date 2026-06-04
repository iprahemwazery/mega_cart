import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_cart/features/favorites/cubit/favorites_cubit.dart';
import 'package:mega_cart/features/favorites/cubit/favorites_state.dart';
import 'package:mega_cart/features/home/widget/product_card.dart';
import 'package:get/get.dart'; // Import GetX for translations

class FavoritView extends StatefulWidget {
  const FavoritView({super.key});

  @override
  State<FavoritView> createState() => _FavoritViewState();
}

class _FavoritViewState extends State<FavoritView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // ضروري جداً استدعاء super.build عند استخدام Mixin الحفاظ على الحالة
    super.build(context);

    return Scaffold(
      appBar: AppBar(title: Text('favorites'.tr), centerTitle: true),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'emptyFavoritesList'.tr,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.favorites.length,
            itemBuilder: (context, index) {
              return ProductCard(product: state.favorites[index]);
            },
          );
        },
      ),
    );
  }
}
