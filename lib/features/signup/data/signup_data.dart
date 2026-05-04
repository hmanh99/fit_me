class SignupData {
  final String username;
  final String email;
  final String password;

  SignupData({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  String toString() {
    // TODO: implement toString
    return 'SignupData(username: $username, email: $email)';
  }
}
