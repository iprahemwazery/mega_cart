import 'package:dartz/dartz.dart';
import 'package:mega_cart/core/NetWork/failure.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Map<String, dynamic>>> getUserProfile();
}

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<Either<Failure, Map<String, dynamic>>> getUserProfile() async {
    try {
      // Simulating API delay
      await Future.delayed(const Duration(seconds: 1));
      return const Right({
        "userName": "Ahmed Wazery",
        "userEmail": "wazery@example.com",
        "profilePicture": "https://via.placeholder.com/150",
      });
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
