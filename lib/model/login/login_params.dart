// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoginParams {
  final String email;
  final String password;
  final String? newPassword;
  LoginParams({
    required this.email,
    required this.password,
    this.newPassword,
  });
}
