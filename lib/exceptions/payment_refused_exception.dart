import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_utils/exceptions/ui_exception.dart';

import '../utils/func_utils.dart';
import '../widgets/error_dialog.dart';

class PaymentRefusedException implements UiException {
  final String message;
  final String? code;
  final String? reason;
  final String? operation;

  PaymentRefusedException(
      {this.code = "PAYMENT_REFUSED",
      this.reason = "Entre em contato com a Operadora",
      this.operation = "DECLINED",
      this.message = "Seu Pagamento foi Recusado"})
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
      await Get.dialog(
        ErrorDialog(
          errorMessage: "Seu pagamento foi Recusado.\n"
              "Ocorreu um problema durante ao tentar fazer o pagamento pelo seu cartão.\n"
              "$reason\n"
              "Verifique a forma de pagamento selecionada e tente novamente.\n",
          onOk: onSuccess,
        ),
        barrierDismissible: false,
      );
    }
  }
}
