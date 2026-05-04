class SignInData {
  final String email;
  final String password;

  SignInData({
    required this.email,
    required this.password,
  });

  @override
  String toString() {
    // TODO: implement toString
    return 'SignInData(email: $email)';
  }
}
