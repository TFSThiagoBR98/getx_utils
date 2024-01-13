import 'package:flutter/material.dart';

import '../utils/func_utils.dart';
import '../widgets/error_dialog.dart';
import 'ui_exception.dart';

class AuthWrongException implements UiException {
  final String message;

  AuthWrongException({this.message = 'Wrong username or password'}) : super();

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
          errorMessage: 'Usuário ou senha inválidos\n',
          onRetry: onRetry,
          onOk: onSuccess,
        ),
        barrierDismissible: false,
      );
    }
  }
}
