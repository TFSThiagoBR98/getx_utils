import 'package:ferry/ferry.dart';
import 'package:gql_exec/gql_exec.dart';

class GraphQLErrorException implements Exception {
  final List<GraphQLError>? errors;
  final LinkException? linkException;

  GraphQLErrorException({this.errors, this.linkException}) : super();

  @override
  String toString() =>
      'GraphQLErrorException(${errors?.map((e) => e.message).join(", ")}} - ${linkException.toString()})';
}
