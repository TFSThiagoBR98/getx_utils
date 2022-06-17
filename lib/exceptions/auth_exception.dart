class AuthException implements Exception {
  final String message;

  AuthException({this.message = "You are not authenticated, please login to continue"}) : super();

  @override
  String toString() => message;
}
