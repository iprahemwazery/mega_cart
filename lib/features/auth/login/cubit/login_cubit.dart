import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:mega_cart/features/auth/login/view/auth_repository.dart';
import 'package:mega_cart/features/splashScreen/view/session_manager.dart';
import 'package:mega_cart/features/auth/login/cubit/login_state.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository; // Dependency on the abstract repository

  LoginCubit(this._authRepository) : super(const LoginState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));
  }

  Future<void> login(String email, String password) async {
    // Clear previous errors and set loading status
    emit(
      state.copyWith(
        status: LoginStatus.loading,
        emailError: null,
        passwordError: null,
        errorMessage: null,
      ),
    );

    final String? emailError = _validateEmail(email);
    final String? passwordError = _validatePassword(password);

    if (emailError != null || passwordError != null) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          emailError: emailError,
          passwordError: passwordError,
        ),
      );
      return;
    }

    try {
      debugPrint('login request for email: $email');
      final token = await _authRepository.login(email, password);

      await SessionManager.setLoggedIn(token, email.trim());
      emit(state.copyWith(status: LoginStatus.success, token: token));
    } on DioException catch (error) {
      String message = 'loginError';
      if (error.response != null && error.response?.data != null) {
        message = error.response?.data.toString() ?? message;
      }
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: message));
    } catch (error) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'serverConnectionFailed',
        ),
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'requiredField'.tr;
    if (!GetUtils.isEmail(value)) return 'invalidEmail'.tr;
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'requiredField'.tr;
    return null;
  }
}
