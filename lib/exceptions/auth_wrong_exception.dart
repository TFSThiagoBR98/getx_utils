class AuthWrongException implements Exception {
  final String message;

  AuthWrongException({this.message = "Wrong username or password"}) : super();

  @override
  String toString() => message;
}
