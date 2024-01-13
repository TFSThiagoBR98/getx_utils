import 'package:flutter/material.dart';

import '../utils/func_utils.dart';
import '../widgets/warning_dialog.dart';
import 'ui_exception.dart';

class RegisterMustVerifyEmailException implements UiException {
  final String message;

  RegisterMustVerifyEmailException(
      {this.message = 'Please check you email to continue registration'})
      : super();

  @override
  String toString() => message;

  @override
  Future<void> callDialog(
    BuildContext context, {
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
        context: context,
        builder: (context) => WarningDialog(
            errorMessage: 'Registro efetuado com sucesso\n'
                'Por favor verifique seu email para ativar sua conta\n',
            onOk: onSuccess),
        barrierDismissible: false,
      );
    }
  }
}
