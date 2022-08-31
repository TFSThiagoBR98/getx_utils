import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';

class GetxMedia<T> {
  final T? model;
  final XFile? file;
  final ImageProvider<Object>? image;

  const GetxMedia({this.model, this.file, this.image});
}
