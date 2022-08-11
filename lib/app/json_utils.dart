import 'dart:convert';

// ignore: prefer_void_to_null
Null toNull(dynamic _) => null;
Map<String, dynamic>? toMapOrNull(dynamic value) => (value is List ? null : value as Map<String, dynamic>?);
dynamic jsonMap(String value) => jsonDecode(value);
String toString(dynamic value) => value.toString();
dynamic toId(dynamic model) => model.map((dynamic element) => element.id.toString()).toList();
dynamic getData(Map<String, dynamic>? data) => data?['data'] ?? <dynamic>[];
