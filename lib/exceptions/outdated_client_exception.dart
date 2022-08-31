import 'package:flutter/material.dart';

import '../utils/func_utils.dart';
import '../utils/main_utils.dart';
import '../widgets/error_dialog.dart';
import 'ui_exception.dart';

class OutdatedClientException implements UiException {
  final String message;

  OutdatedClientException({this.message = 'This client is outdated, please update the app'}) : super();

  @override
  String toString() => message;

  @override
  Future<void> callDialog({
    ErrorCallback? onError,
    VoidCallback? onRetry,
    VoidCallback? onSuccess,
  }) async {
    var willShowDialog = true;
    if (onError != null) {
      willShowDialog = onError(this);
    }

    if (willShowDialog) {
      await showDialog<void>(
        context: appContext!,
        builder: (context) => ErrorDialog(
          errorMessage: 'Este aplicativo está desatualizado\n'
              'Por favor faça uma atualização na loja de aplicativos de seu dispositivo\n',
          onRetry: onRetry,
          onOk: onSuccess,
        ),
        barrierDismissible: false,
      );
    }
  }
}
