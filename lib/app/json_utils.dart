import 'dart:convert';

toNull(_) => null;
toMapOrNull(value) => (value is List ? null : value as Map<String, dynamic>?);
jsonMap(value) => jsonDecode(value);
toString(value) => value.toString();
toId(model) => model.map((element) => element.id.toString()).toList();
getData(Map<String, dynamic>? data) => data?['data'] ?? [];