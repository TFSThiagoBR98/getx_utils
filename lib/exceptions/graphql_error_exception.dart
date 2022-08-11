import 'dart:convert';

import 'package:ferry/ferry.dart';
import 'package:gql_exec/gql_exec.dart';

class GraphQLErrorException implements Exception {
  final List<GraphQLError>? errors;
  final LinkException? linkException;

  GraphQLErrorException({this.errors, this.linkException}) : super();

  @override
  String toString() => 'GraphQLErrorException(${jsonEncode(errors)} - ${linkException.toString()})';
}
