import 'package:dio/dio.dart';
import 'package:ferry/typed_links.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';
import 'package:universal_io/io.dart';

import '../exceptions/account_deletation_in_progress.dart';
import '../exceptions/auth_exception.dart';
import '../exceptions/auth_wrong_exception.dart';
import '../exceptions/graphql_error_exception.dart';
import '../exceptions/outdated_client_exception.dart';
import '../exceptions/payment_refused_exception.dart';
import '../exceptions/permission_exception.dart';
import '../exceptions/register_must_verify_email_exception.dart';
import '../exceptions/server_error_exception.dart';
import '../exceptions/validation_exception.dart';
import '../widgets/error_dialog.dart';

Future<T> runFutureWithErrorDialog<T>(
    {required Future<T> Function() callback,
    required VoidCallback onError,
    ProgressDialog? dialog,
    VoidCallback? onRetry,
    VoidCallback? onSuccess}) async {
  try {
    return await callback();
  } catch (e) {
    dialog?.dismiss();
    displayErrorDialog(e, onError: onError, onRetry: onRetry, onSuccess: onSuccess);
    rethrow;
  }
}

void rethrowAuth(GraphQLErrorException exception) {
  if (exception.errors != null) {
    for (final error in exception.errors!) {
      switch (error.message) {
        case 'Unauthenticated.':
        case 'Not Authenticated':
          throw AuthException();
        case 'invalid_grant':
          throw AuthWrongException();
        case 'Outdated Client':
          throw OutdatedClientException();
        case 'This action is unauthorized.':
          throw PermissionException();
        case 'PAYMENT_REFUSED':
          throw PaymentRefusedException(
            code: error.extensions?['code'] as String?,
            reason: error.extensions?['reason'] as String?,
            operation: error.extensions?['operation'] as String?,
          );
        case 'Account Terminated.':
          throw AccountDeletationInProgressException();
        case 'Internal server error':
          throw ServerErrorException();
        default:
          if (error.message.contains('Validation failed')) {
            throw ValidationException(fields: error.extensions?['validation'] as Map?);
          } else {
            throw Exception('Unknown Error');
          }
      }
    }
  }

  if (exception.linkException != null) {
    if (exception.linkException is ServerException && exception.linkException!.originalException is DioError) {
      throw exception.linkException!.originalException! as DioError;
    } else if (exception.linkException is ServerException && exception.linkException!.originalException is Exception) {
      throw exception.linkException!.originalException! as Exception;
    } else if (exception.linkException is LinkException && exception.linkException!.originalException is DioError) {
      throw exception.linkException!.originalException! as DioError;
    } else if (exception.linkException is LinkException && exception.linkException!.originalException is Exception) {
      throw exception.linkException!.originalException! as Exception;
    } else {
      throw exception;
    }
  }
}

void displayErrorDialog(dynamic error, {required Function onError, VoidCallback? onRetry, VoidCallback? onSuccess}) {
  if (error is AuthException) {
    error.callDialog(onRetry: onRetry, onSuccess: onSuccess).whenComplete(() => onError);
  } else if (error is PermissionException) {
    error.callDialog(onRetry: onRetry, onSuccess: onSuccess).whenComplete(() => onError);
  } else if (error is AuthWrongException) {
    error.callDialog(onRetry: onRetry, onSuccess: onSuccess).whenComplete(() => onError);
  } else if (error is RegisterMustVerifyEmailException) {
    error.callDialog(onSuccess: onSuccess).whenComplete(() => onSuccess ?? () {});
  } else if (error is OutdatedClientException) {
    error.callDialog(onRetry: onRetry, onSuccess: onSuccess).whenComplete(() => onError);
  } else if (error is ValidationException) {
    error.callDialog(onRetry: onRetry, onSuccess: onSuccess).whenComplete(() => onError);
  } else if (error is PaymentRefusedException) {
    error.callDialog(onRetry: onRetry, onSuccess: onSuccess).whenComplete(() => onError);
  } else if (error is AccountDeletationInProgressException) {
    error.callDialog(onRetry: onRetry, onSuccess: onSuccess).whenComplete(() => onError);
  } else if (error is ServerErrorException) {
    error.callDialog(onRetry: onRetry, onSuccess: onSuccess).whenComplete(() => onError);
  } else if (error is DioError) {
    if (error.type == DioErrorType.connectTimeout ||
        error.type == DioErrorType.receiveTimeout ||
        error.type == DioErrorType.sendTimeout) {
      Get.dialog<void>(
        ErrorDialog(
            errorMessage: 'Falha ao executar a ação\n'
                'Tempo esgotado aguardando resposta do servidor\n'
                'Verifique sua conexão com a internet e tente novamente.\n'
                'Caso o problema persista e não seja sua internet, entre em contato com o suporte.\n',
            onRetry: onRetry),
        barrierDismissible: false,
      ).whenComplete(() => onError);
    } else if (error.type == DioErrorType.other) {
      Get.dialog<void>(
        ErrorDialog(
            errorMessage: 'Falha ao conectar ao Servidor\n'
                'Verifique sua conexão com a internet e tente novamente\n',
            onRetry: onRetry),
        barrierDismissible: false,
      ).whenComplete(() => onError);
    } else if (error.response == null) {
      Get.dialog<void>(
        ErrorDialog(
            errorMessage: 'O Servidor não enviou uma resposta\n'
                'Verifique sua conexão com a internet e tente novamente\n',
            onRetry: onRetry),
        barrierDismissible: false,
      ).whenComplete(() => onError);
    } else {
      if (error.response?.statusCode == null) {
        Get.dialog<void>(
          ErrorDialog(
              errorMessage: 'Erro desconhecido na conexão com o servidor\n'
                  'Verifique sua conexão com a internet e tente novamente\n'
                  'Detalhes do Erro: Código de Estado HTTP está Nulo \n',
              onRetry: onRetry),
          barrierDismissible: false,
        ).whenComplete(() => onError);
      } else if (error.response?.statusCode == 460) {
        Get.dialog<void>(
          ErrorDialog(
              errorMessage: 'Este aplicativo está desatualizado\n'
                  'Por favor faça uma atualização na loja de aplicativos de seu dispositivo\n',
              onRetry: onRetry),
          barrierDismissible: false,
        ).whenComplete(() => onError);
      } else if (error.response?.statusCode == 429) {
        Get.dialog<void>(
          ErrorDialog(
              errorMessage: 'Você fez várias requisições em um curto periodo de tempo\n'
                  'Muitas tentativas de conexão, tente mais tarde\n',
              onRetry: onRetry),
          barrierDismissible: false,
        ).whenComplete(() => onError);
      } else if (error.response!.statusCode! >= 500 || error.response!.statusCode! <= 599) {
        Get.dialog<void>(
          ErrorDialog(
              errorMessage: 'Falha no servidor\n'
                  'Ocorreu um problema no nosso sistema\n'
                  'Aguarde um pouco e tente novamente\n'
                  'Caso o problema persista entre em contato com o suporte.\n',
              onRetry: onRetry),
          barrierDismissible: false,
        ).whenComplete(() => onError);
      } else {
        Get.dialog<void>(
          ErrorDialog(
              errorMessage: 'Erro desconhecido na conexão com o servidor\n'
                  'Verifique sua conexão com a internet e tente novamente\n'
                  'Detalhes do Erro $error \n',
              onRetry: onRetry),
          barrierDismissible: false,
        ).whenComplete(() => onError);
      }
    }
  } else if (error is SocketException) {
    Get.dialog<void>(
      ErrorDialog(
          errorMessage: 'Falha ao conectar-se ao servidor\n'
              'Verifique sua conexão com a internet e tente novamente\n',
          onRetry: onRetry),
      barrierDismissible: false,
    ).whenComplete(() => onError);
  } else {
    Get.dialog<void>(
      ErrorDialog(
          errorMessage: 'Falha ao executar a ação\n'
              'Erro: $error\n',
          onRetry: onRetry),
      barrierDismissible: false,
    ).whenComplete(() => onError);
  }
}
