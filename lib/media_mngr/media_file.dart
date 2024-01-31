import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';

class MediaFile<T> {
  final T? model;
  final String? collection;
  final XFile? file;
  final ImageProvider<Object>? image;

  const MediaFile({this.model, this.file, this.image, this.collection});
}
