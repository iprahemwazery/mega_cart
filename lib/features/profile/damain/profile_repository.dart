import 'package:dartz/dartz.dart';
import 'package:mega_cart/core/NetWork/failure.dart';
import 'package:mega_cart/features/profile/damain/user_entity.dart'; // Corrected import

abstract class ProfileRepository {
  Future<Either<Failure, UserEntity>> getUserProfile();
}
