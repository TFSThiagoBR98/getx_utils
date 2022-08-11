import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/func_utils.dart';
import '../widgets/error_dialog.dart';
import 'ui_exception.dart';

class ServerErrorException implements UiException {
  final String message;

  ServerErrorException({this.message = 'Internal Server Error'}) : super();

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
      await Get.dialog<void>(
        ErrorDialog(
          errorMessage: 'Falha no servidor\n'
              'Ocorreu um problema no nosso sistema\n'
              'Aguarde alguns minutos e tente novamente\n'
              'Caso o problema persista entre em contato com o suporte.\n',
          onRetry: onRetry,
          onOk: onSuccess,
        ),
        barrierDismissible: false,
      );
    }
  }
}
