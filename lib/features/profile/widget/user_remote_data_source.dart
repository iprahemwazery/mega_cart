import 'package:dio/dio.dart';
import 'package:mega_cart/core/NetWork/api_constans.dart';
import 'package:mega_cart/features/splashScreen/view/session_manager.dart';
import 'package:mega_cart/core/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUserProfile(String userId);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> getUserProfile(String userId) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock data for demonstration
    if (userId == 'user123') {
      final email =
          await SessionManager.getUserEmail() ?? 'mohamed.ahmed@example.com';
      final name = email.split('@')[0];

      return UserModel.fromJson({
        'id': 'user123',
        'name': name,
        'email': email,
        'profilePictureUrl':
            'https://via.placeholder.com/150/0000FF/FFFFFF?text=MA', // Example image
      });
    } else {
      throw DioException(
        requestOptions: RequestOptions(
          path: '${ApiConstans.baseUrl}users/$userId',
        ),
        response: Response(
          requestOptions: RequestOptions(
            path: '${ApiConstans.baseUrl}users/$userId',
          ),
          statusCode: 404,
          data: {'message': 'User not found'},
        ),
        type: DioExceptionType.badResponse,
        error: 'User not found',
      );
    }
  }
}
