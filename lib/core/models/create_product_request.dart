class CreateProductRequest {
  final String sellerId;
  final String name;
  final String description;
  final String nameArabic;
  final String descriptionArabic;
  final String coverPictureUrl;
  final double price;
  final int stock;
  final double weight;
  final String color;
  final double discountPercentage;
  final List<String> categoryIds;
  final List<String> productPictureUrls;

  CreateProductRequest({
    required this.sellerId,
    required this.name,
    required this.description,
    required this.nameArabic,
    required this.descriptionArabic,
    required this.coverPictureUrl,
    required this.price,
    required this.stock,
    required this.weight,
    required this.color,
    required this.discountPercentage,
    required this.categoryIds,
    required this.productPictureUrls,
  });

  Map<String, dynamic> toJson() {
    return {
      'sellerId': sellerId,
      'name': name,
      'description': description,
      'nameArabic': nameArabic,
      'descriptionArabic': descriptionArabic,
      'coverPictureUrl': coverPictureUrl,
      'price': price,
      'stock': stock,
      'weight': weight,
      'color': color,
      'discountPercentage': discountPercentage,
      'categoryIds': categoryIds,
      'productPictureUrls': productPictureUrls,
    };
  }
}
