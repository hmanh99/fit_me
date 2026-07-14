class ServerException implements Exception {
  final String message;

  ServerException({required this.message});

  @override
  String toString() => message;
}

class CustomAuthException implements Exception {
  final String message;

  CustomAuthException({required this.message});

  @override
  String toString() => message;
}
