import 'package:flutter/material.dart';

import '../utils/func_utils.dart';
import '../utils/main_utils.dart';
import '../widgets/error_dialog.dart';
import 'ui_exception.dart';

class PaymentRefusedException implements UiException {
  final String message;
  final String? code;
  final String? reason;
  final String? operation;

  PaymentRefusedException(
      {this.code = 'PAYMENT_REFUSED',
      this.reason = 'Entre em contato com a Operadora',
      this.operation = 'DECLINED',
      this.message = 'Seu Pagamento foi Recusado'})
      : super();

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
          errorMessage: 'Seu pagamento foi Recusado.\n'
              'Ocorreu um problema ao tentar fazer o pagamento.\n'
              '$reason\n'
              'Verifique a forma de pagamento selecionada e tente novamente.\n',
          onOk: onSuccess,
        ),
        barrierDismissible: false,
      );
    }
  }
}
