import 'package:mega_cart/features/home/domain/product_entity.dart';

class Product extends ProductEntity {
  Product({
    required super.id,
    required super.productCode,
    required super.name,
    required super.description,
    required super.arabicName,
    required super.arabicDescription,
    required super.coverPictureUrl,
    required super.productPictures,
    required super.price,
    required super.stock,
    required super.weight,
    required super.color,
    required super.rating,
    required super.reviewsCount,
    required super.discountPercentage,
    required super.sellerId,
    required super.categories,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      productCode: json['productCode'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      arabicName: json['arabicName'] ?? '',
      arabicDescription: json['arabicDescription'] ?? '',
      coverPictureUrl: json['coverPictureUrl'] ?? '',
      productPictures: List<String>.from(json['productPictures'] ?? []),
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      weight: (json['weight'] ?? 0).toDouble(),
      color: json['color'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewsCount: json['reviewsCount'] ?? 0,
      discountPercentage: (json['discountPercentage'] ?? 0).toDouble(),
      sellerId: json['sellerId'] ?? '',
      categories: List<String>.from(json['categories'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productCode': productCode,
      'name': name,
      'description': description,
      'arabicName': arabicName,
      'arabicDescription': arabicDescription,
      'coverPictureUrl': coverPictureUrl,
      'productPictures': productPictures,
      'price': price,
      'stock': stock,
      'weight': weight,
      'color': color,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'discountPercentage': discountPercentage,
      'sellerId': sellerId,
      'categories': categories,
    };
  }
}

class ProductResponse extends ProductPaginationEntity {
  ProductResponse({
    required List<Product> super.items,
    required super.page,
    required super.pageSize,
    required super.totalCount,
    required super.hasNextPage,
    required super.hasPreviousPage,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => Product.fromJson(item))
              .toList() ??
          [],
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalCount: json['totalCount'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }
}
