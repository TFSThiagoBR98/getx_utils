class RegisterMustVerifyEmailException implements Exception {
  final String message;

  RegisterMustVerifyEmailException({this.message = "Please check you email to continue registration"}) : super();

  @override
  String toString() => message;
}
