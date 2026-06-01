enum VerifyEmailStatus { initial, loading, success, failure }

class VerifyEmailState {
  final VerifyEmailStatus status;
  final String? errorMessage;
  final String? emailError;
  final String? otpError;

  const VerifyEmailState({
    this.status = VerifyEmailStatus.initial,
    this.errorMessage,
    this.emailError,
    this.otpError,
  });

  VerifyEmailState copyWith({
    VerifyEmailStatus? status,
    String? errorMessage,
    String? emailError,
    String? otpError,
  }) {
    return VerifyEmailState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      emailError: emailError,
      otpError: otpError,
    );
  }
}
