import 'package:mega_cart/features/profile/damain/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    super.email,
    super.profilePictureUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['userId'] ?? json['id'] ?? '').toString(),
      name: (json['fullName'] ?? json['name'] ?? 'User').toString(),
      email: json['email']?.toString(),
      profilePictureUrl: (json['profilePicture'] ?? json['profilePictureUrl'])
          ?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}
