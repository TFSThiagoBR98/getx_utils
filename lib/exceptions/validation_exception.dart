import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_utils/exceptions/ui_exception.dart';

import '../utils/func_utils.dart';
import '../widgets/error_dialog.dart';
import '../widgets/warning_dialog.dart';

class ValidationException implements UiException {
  final String message;
  final Map? fields;

  ValidationException({this.message = "Some fields have an invalid value", this.fields}) : super();

  @override
  String toString() => message;

  String breakMap() {
    return fields?.values.map((e) => (e as List).join('\n')).join('\n') ?? "";
  }

  @override
  Future<void> callDialog({
    ErrorCallback? onError,
    VoidCallback? onRetry,
    VoidCallback? onSuccess,
  }) async {
    var showDialog = true;
    if (onError != null) {
      showDialog = onError(this);
    }

    if (showDialog) {
      await Get.dialog(
        ErrorDialog(
            errorMessage: "Alguns campos contém valores inválidos\n"
                "Reveja os valores fornecidos e tente novamente\n"
                "${breakMap()}\n",
            onOk: onSuccess),
        barrierDismissible: false,
      );
    }
  }
}
