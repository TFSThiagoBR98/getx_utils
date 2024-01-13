import 'package:flutter/material.dart';

import '../utils/func_utils.dart';

abstract class UiException implements Exception {
  Future<void> callDialog(
    BuildContext context, {
    ErrorCallback? onError,
    VoidCallback? onRetry,
    VoidCallback? onSuccess,
  });
}
