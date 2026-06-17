import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String? email;
  final String? profilePictureUrl;

  const UserEntity({
    required this.id,
    required this.name,
    this.email,
    this.profilePictureUrl,
  });

  @override
  List<Object?> get props => [id, name, email, profilePictureUrl];
}
