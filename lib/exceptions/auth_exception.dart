import 'package:flutter/material.dart';

import '../utils/func_utils.dart';
import '../widgets/error_dialog.dart';
import 'ui_exception.dart';

class AuthException implements UiException {
  final String message;

  AuthException(
      {this.message = 'You are not authenticated, please login to continue'})
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
        builder: (context) => ErrorDialog(
          errorMessage:
              'Você não está conectado a sua conta, por favor faça o login\n',
          onRetry: onRetry,
          onOk: onSuccess,
        ),
        barrierDismissible: false,
      );
    }
  }
}
