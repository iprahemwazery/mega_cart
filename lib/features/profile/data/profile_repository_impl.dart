import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mega_cart/core/NetWork/api_service.dart';
import 'package:mega_cart/core/NetWork/failure.dart';
import 'package:mega_cart/features/profile/damain/profile_repository.dart';
import 'package:mega_cart/features/profile/data/user_model.dart';
import 'package:mega_cart/features/profile/damain/profile_repository.dart';
import 'package:mega_cart/features/profile/damain/user_entity.dart'; // Corrected import

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiService apiService;

  ProfileRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
    try {
      final response = await apiService.dio.get('auth/me');
      final userModel = UserModel.fromJson(response.data);
      return Right(userModel as UserEntity);
    } catch (e) {
      if (e is DioException) {
        return Left(
          ServerFailure(
            e.response?.data?['message'] ??
                e.response?.data?['detail'] ??
                e.message ??
                'An unexpected error occurred',
          ),
        );
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
