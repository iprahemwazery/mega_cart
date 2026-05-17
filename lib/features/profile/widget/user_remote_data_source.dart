import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:mega_cart/core/NetWork/api_constans.dart';
import 'package:mega_cart/features/home/controller/home_controller.dart';
import 'package:mega_cart/features/profile/widget/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUserProfile(String userId);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;
  final controller = Get.put(HomeController());

  UserRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> getUserProfile(String userId) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock data for demonstration
    if (userId == 'user123') {
      return UserModel.fromJson({
        'id': 'user123',
        'name': controller.userName.value.isNotEmpty
            ? controller.userName.value
            : 'Mohamed Ahmed',
        'email': controller.userEmail.value.isNotEmpty
            ? controller.userEmail.value
            : 'mohamed.ahmed@example.com',

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
