import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_utils/exceptions/ui_exception.dart';

import '../utils/func_utils.dart';
import '../widgets/error_dialog.dart';

class PermissionException implements UiException {
  final String message;

  PermissionException({this.message = "You are not authorized to run this command"}) : super();

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
          errorMessage: "Você não tem permissão para executar esta ação\n",
          onRetry: onRetry,
          onOk: onSuccess,
        ),
        barrierDismissible: false,
      );
    }
  }
}
