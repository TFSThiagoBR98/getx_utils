import 'package:flutter/material.dart';

import '../utils/func_utils.dart';
import '../utils/main_utils.dart';
import '../widgets/error_dialog.dart';
import 'ui_exception.dart';

class PermissionException implements UiException {
  final String message;

  PermissionException({this.message = 'You are not authorized to run this command'}) : super();

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
          errorMessage: 'Você não tem permissão para executar esta ação\n',
          onRetry: onRetry,
          onOk: onSuccess,
        ),
        barrierDismissible: false,
      );
    }
  }
}
