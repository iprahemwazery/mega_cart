import 'package:dartz/dartz.dart';
import 'package:mega_cart/core/NetWork/failure.dart';
import 'package:mega_cart/features/profile/damain/profile_repository.dart';
import 'package:mega_cart/features/profile/damain/profile_repository.dart';

import 'package:mega_cart/features/profile/damain/user_entity.dart';

class GetUserProfileUseCase {
  final ProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getUserProfile();
  }
}
