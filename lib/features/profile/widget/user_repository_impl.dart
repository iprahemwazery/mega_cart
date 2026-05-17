import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mega_cart/core/NetWork/failure.dart';
import 'package:mega_cart/features/profile/widget/user.dart';
import 'package:mega_cart/features/profile/widget/user_remote_data_source.dart';
import 'package:mega_cart/features/profile/widget/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> getUserProfile(String userId) async {
    try {
      final userModel = await remoteDataSource.getUserProfile(userId);
      return Right(userModel);
    } on DioException catch (e) {
      if (e.response != null && e.response!.data is Map) {
        return Left(
          ServerFailure(e.response!.data['message'] ?? 'Server error'),
        );
      } else if (e.response != null) {
        return Left(ServerFailure('Server error: ${e.response!.statusCode}'));
      }
      return Left(ServerFailure(e.message ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
