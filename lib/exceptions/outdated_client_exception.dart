class OutdatedClientException implements Exception {
  final String message;

  OutdatedClientException({this.message = "This client is outdated, please update the app"}) : super();

  @override
  String toString() => message;
}
