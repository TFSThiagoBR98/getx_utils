import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_utils/exceptions/ui_exception.dart';

import '../utils/func_utils.dart';
import '../widgets/error_dialog.dart';

class AuthException implements UiException {
  final String message;

  AuthException({this.message = "You are not authenticated, please login to continue"}) : super();

  @override
  String toString() => message;

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
          errorMessage: "Você não está conectado a sua conta, por favor faça o login\n",
          onRetry: onRetry,
          onOk: onSuccess,
        ),
        barrierDismissible: false,
      );
    }
  }
}
