enum SignupStatus { initial, loading, success, failure }

class SignupState {
  final SignupStatus status;
  final bool isPasswordObscured;
  final bool isConfirmPasswordObscured;
  final String? errorMessage;
  final String? firstNameError;
  final String? lastNameError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;

  const SignupState({
    this.status = SignupStatus.initial,
    this.isPasswordObscured = true,
    this.isConfirmPasswordObscured = true,
    this.errorMessage,
    this.firstNameError,
    this.lastNameError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
  });

  SignupState copyWith({
    SignupStatus? status,
    bool? isPasswordObscured,
    bool? isConfirmPasswordObscured,
    String? errorMessage,
    String? firstNameError,
    String? lastNameError,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
  }) {
    return SignupState(
      status: status ?? this.status,
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      isConfirmPasswordObscured:
          isConfirmPasswordObscured ?? this.isConfirmPasswordObscured,
      errorMessage: errorMessage ?? this.errorMessage,
      firstNameError: firstNameError,
      lastNameError: lastNameError,
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
    );
  }
}
