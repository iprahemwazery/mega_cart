enum LoginStatus { initial, loading, success, failure }

class LoginState {
  final LoginStatus status;
  final bool isPasswordObscured;
  final String? errorMessage;
  final String? emailError;
  final String? passwordError;
  final String? token;

  const LoginState({
    this.status = LoginStatus.initial,
    this.isPasswordObscured = true,
    this.errorMessage,
    this.emailError,
    this.passwordError,
    this.token,
  });

  LoginState copyWith({
    LoginStatus? status,
    bool? isPasswordObscured,
    String? errorMessage,
    String? emailError,
    String? passwordError,
    String? token,
  }) {
    return LoginState(
      status: status ?? this.status,
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      errorMessage: errorMessage ?? this.errorMessage,
      emailError: emailError,
      passwordError: passwordError,
      token: token ?? this.token,
    );
  }
}
