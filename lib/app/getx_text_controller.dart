import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetXTextController<V> {
  late final Rxn<V> dataRx;
  V? get data => dataRx.value;
  set data(V? value) => dataRx.value = value;

  final Rx<TextEditingController> _controller = TextEditingController().obs;
  TextEditingController get controller => _controller.value;
  set controller(TextEditingController value) => _controller.value = value;

  void setData(String value) {
    if (V is String) {
      data = value as V?;
    }
    controller.text = value;
  }

  GetXTextController() {
    if (V is String) {
      dataRx = RxnString() as Rxn<V>;
    } else if (V is num) {
      dataRx = RxnNum() as Rxn<V>;
    } else {
      dataRx = Rxn<V>();
    }
  }
}
