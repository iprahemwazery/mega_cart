import 'package:dio/dio.dart';
import 'package:get/get.dart' as get_x;

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = '';

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'serverConnectionFailed'.tr;
        break;
      case DioExceptionType.badResponse:
        errorMessage = _handleBadResponse(err.response);
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request cancelled';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'noInternetConnection'.tr;
        break;
      default:
        errorMessage = 'unexpectedError'.tr;
    }

    final modifiedError = DioException(
      requestOptions: err.requestOptions,
      error: errorMessage,
      type: err.type,
      response: err.response,
    );

    return handler.next(modifiedError);
  }

  String _handleBadResponse(Response? response) {
    if (response == null) return 'unexpectedError'.tr;

    final statusCode = response.statusCode;
    final data = response.data;

    if (data is Map && data.containsKey('message')) {
      return data['message'];
    }

    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'unauthorized'.tr;
      case 403:
        return 'Forbidden';
      case 404:
        return 'productNotFound'.tr;
      case 500:
        return 'internalServerError'.tr;
      default:
        return 'unexpectedError'.tr;
    }
  }
}
