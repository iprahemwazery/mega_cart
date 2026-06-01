abstract class AuthRepository {
  Future<String> login(String email, String password);

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  Future<String> verifyEmail(String email, String otp);
}
