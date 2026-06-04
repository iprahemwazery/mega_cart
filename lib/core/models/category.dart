import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String description;
  final String coverPictureUrl;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.coverPictureUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      coverPictureUrl: json['coverPictureUrl'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, description, coverPictureUrl];
}
