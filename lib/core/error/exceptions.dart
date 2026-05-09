class ServerException implements Exception {
  final String message;

  ServerException({this.message = 'A server error occurred.'});

  @override
  String toString() => message;
}

class AuthException implements Exception {
  final String message;

  AuthException({this.message = 'An authentication error occurred.'});

  @override
  String toString() => message;
}
