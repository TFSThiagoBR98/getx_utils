import 'package:flutter/material.dart';

import '../utils/func_utils.dart';
import '../widgets/warning_dialog.dart';
import 'ui_exception.dart';

class AccountDeletationInProgressException implements UiException {
  final String message;

  AccountDeletationInProgressException(
      {this.message = 'Account in Deletation process'})
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
            errorMessage: 'Esta conta encontra-se em processo de exclusão\n'
                'Esse processo pode levar até 7 dias úteis para ser efetuado\n'
                'Após a exclusão será possível criar uma nova conta com os mesmos dados.\n',
            onOk: onSuccess),
        barrierDismissible: false,
      );
    }
  }
}
