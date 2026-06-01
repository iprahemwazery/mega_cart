import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:mega_cart/features/auth/login/view/auth_repository.dart';
import 'package:mega_cart/features/auth/signup/cubit/signup_state.dart';
import 'package:get/get.dart'; // For GetUtils.isEmail

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;

  SignupCubit(this._authRepository) : super(const SignupState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));
  }

  void toggleConfirmPasswordVisibility() {
    emit(
      state.copyWith(
        isConfirmPasswordObscured: !state.isConfirmPasswordObscured,
      ),
    );
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // Clear previous errors and set loading status
    emit(
      state.copyWith(
        status: SignupStatus.loading,
        firstNameError: null,
        lastNameError: null,
        emailError: null,
        passwordError: null,
        confirmPasswordError: null,
        errorMessage: null,
      ),
    );

    // Perform validation
    String? firstNameError = _validateFirstName(firstName);
    String? lastNameError = _validateLastName(lastName);
    String? emailError = _validateEmail(email);
    String? passwordError = _validatePassword(password);
    String? confirmPasswordError = _validateConfirmPassword(
      password,
      confirmPassword,
    );

    if (firstNameError != null ||
        lastNameError != null ||
        emailError != null ||
        passwordError != null ||
        confirmPasswordError != null) {
      emit(
        state.copyWith(
          status: SignupStatus
              .failure, // Or a new status like SignupStatus.validationError
          firstNameError: firstNameError,
          lastNameError: lastNameError,
          emailError: emailError,
          passwordError: passwordError,
          confirmPasswordError: confirmPasswordError,
        ),
      );
      return;
    }

    try {
      await _authRepository.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );

      emit(state.copyWith(status: SignupStatus.success));
    } on DioException catch (error) {
      String message = 'signupFailed';
      if (error.response != null && error.response?.data != null) {
        message = error.response?.data.toString() ?? message;
      }
      emit(state.copyWith(status: SignupStatus.failure, errorMessage: message));
    } catch (error) {
      emit(
        state.copyWith(
          status: SignupStatus.failure,
          errorMessage: 'serverConnectionFailed',
        ),
      );
    }
  }

  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) return 'firstNameRequired'.tr;
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) return 'lastNameRequired'.tr;
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'emailRequired'.tr;
    if (!GetUtils.isEmail(value)) return 'enterValidEmail'.tr;
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'passwordRequired'.tr;
    if (password.length < 8) return 'passwordMinLength'.tr;
    if (!RegExp(r'[A-Z]').hasMatch(password)) return 'passwordUppercase'.tr;
    if (!RegExp(r'[a-z]').hasMatch(password)) return 'passwordLowercase'.tr;
    if (!RegExp(r'[0-9]').hasMatch(password)) return 'passwordNumber'.tr;
    if (!RegExp(r'[!@#\$%\^&*(),.?":{}|<>]').hasMatch(password))
      return 'passwordSpecialChar'.tr;
    return null;
  }

  String? _validateConfirmPassword(String password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty)
      return 'confirmPasswordRequired'.tr; // Assuming a new translation key
    if (confirmPassword != password) return 'passwordsDoNotMatch'.tr;
    return null;
  }
}
