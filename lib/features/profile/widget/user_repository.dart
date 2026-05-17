import 'package:dartz/dartz.dart';
import 'package:mega_cart/core/NetWork/failure.dart';
import 'package:mega_cart/features/profile/widget/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUserProfile(String userId);
}
