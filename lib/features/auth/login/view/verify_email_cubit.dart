import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:mega_cart/features/auth/login/view/auth_repository.dart';
import 'package:mega_cart/features/auth/login/view/verify_email_state.dart';
import 'package:mega_cart/features/splashScreen/view/session_manager.dart';
import 'package:get/get.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  final AuthRepository _authRepository;

  VerifyEmailCubit(this._authRepository) : super(const VerifyEmailState());

  Future<void> verifyEmail(String email, String otp) async {
    emit(
      state.copyWith(
        status: VerifyEmailStatus.loading,
        emailError: null,
        otpError: null,
        errorMessage: null,
      ),
    );

    final String? emailError = _validateEmail(email);
    final String? otpError = _validateOtp(otp);

    if (emailError != null || otpError != null) {
      emit(
        state.copyWith(
          status: VerifyEmailStatus.failure,
          emailError: emailError,
          otpError: otpError,
        ),
      );
      return;
    }

    try {
      final token = await _authRepository.verifyEmail(email, otp);
      await SessionManager.setLoggedIn(token, email.trim());
      emit(state.copyWith(status: VerifyEmailStatus.success));
    } on DioException catch (error) {
      String message = 'verificationFailed';
      if (error.response != null && error.response?.data != null) {
        message = error.response?.data.toString() ?? message;
      }
      emit(
        state.copyWith(
          status: VerifyEmailStatus.failure,
          errorMessage: message,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: VerifyEmailStatus.failure,
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

  String? _validateOtp(String? value) {
    if (value == null || value.isEmpty) return 'requiredField'.tr;
    return null;
  }
}
