class PermissionException implements Exception {
  final String message;

  PermissionException({this.message = "You are not authorized to run this command"}) : super();

  @override
  String toString() => message;
}
