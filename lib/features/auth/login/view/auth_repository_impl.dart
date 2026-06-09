import 'package:dio/dio.dart';
import 'package:mega_cart/core/NetWork/api_constans.dart';
import 'package:mega_cart/features/auth/login/view/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<String> login(String email, String password) async {
    final data = {'email': email.trim(), 'password': password};

    try {
      final response = await _dio.post(
        ApiConstans.baseUrl + ApiConstans.login,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        String token = 'dummy_token';
        if (responseData is Map) {
          token =
              responseData['token'] ??
              responseData['accessToken'] ??
              responseData['authToken'] ??
              'dummy_token';
        }
        return token;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data.toString(),
        );
      }
    } on DioException catch (e) {
      throw e; // Re-throw DioException to be handled by Cubit
    } catch (e) {
      throw Exception('Server connection failed'); // Generic error
    }
  }

  @override
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final data = {
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'email': email.trim(),
      'password': password,
    };

    try {
      final response = await _dio.post(
        ApiConstans.baseUrl + ApiConstans.register,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data.toString());
      }
    } on DioException catch (e) {
      throw e;
    } catch (e) {
      throw Exception('Server connection failed');
    }
  }

  @override
  Future<String> verifyEmail(String email, String otp) async {
    final data = {'email': email.trim(), 'otp': otp.trim()};

    try {
      final response = await _dio.post(
        ApiConstans.baseUrl + ApiConstans.verifyEmail,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        String token = 'dummy_token_after_verification';
        if (responseData is Map) {
          token = responseData['token'] ?? 'dummy_token_after_verification';
        }
        return token;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data.toString(),
        );
      }
    } on DioException catch (e) {
      throw e;
    } catch (e) {
      throw Exception('Server connection failed');
    }
  }
}
