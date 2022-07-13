import 'package:flutter/material.dart';

import '../utils/func_utils.dart';

abstract class UiException implements Exception {
  Future<void> callDialog({
    ErrorCallback? onError,
    VoidCallback? onRetry,
    VoidCallback? onSuccess,
  });
}
