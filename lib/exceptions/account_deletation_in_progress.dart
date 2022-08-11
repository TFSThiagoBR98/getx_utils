import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/func_utils.dart';
import '../widgets/warning_dialog.dart';
import 'ui_exception.dart';

class AccountDeletationInProgressException implements UiException {
  final String message;

  AccountDeletationInProgressException({this.message = 'Account in Deletation process'}) : super();

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
        WarningDialog(
            errorMessage: 'Esta conta encontra-se em processo de exclusão\n'
                'Esse processo pode levar até 7 dias úteis para ser efetuado\n'
                'Após a exclusão será possível criar uma nova conta com os mesmos dados.\n',
            onOk: onSuccess),
        barrierDismissible: false,
      );
    }
  }
}
