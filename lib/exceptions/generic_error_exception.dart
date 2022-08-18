import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/func_utils.dart';
import '../widgets/error_dialog.dart';
import 'ui_exception.dart';

class GenericErrorException implements UiException {
  final String message;
  final String? code;
  final String? reason;
  final String? operation;

  GenericErrorException(
      {this.code = 'Generic Error',
      this.reason = 'Entre em contato com a Operadora',
      this.operation = 'DECLINED',
      this.message = 'Falha ao processar sua solicitação'})
      : super();

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
          errorMessage: 'Operação falhou\n'
              'Ocorreu um problema ao tentar fazer essa ação.\n'
              '$message\n'
              'Motivo: $reason\n',
          onOk: onSuccess,
        ),
        barrierDismissible: false,
      );
    }
  }
}
