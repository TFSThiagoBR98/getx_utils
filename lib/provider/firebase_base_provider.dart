import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:ndialog/ndialog.dart';
import 'package:universal_io/io.dart';
import 'package:hive/hive.dart';
import '../exceptions/account_deletation_in_progress.dart';
import '../exceptions/payment_refused_exception.dart';
import '../exceptions/validation_exception.dart';
import '../exceptions/auth_exception.dart';
import '../exceptions/auth_wrong_exception.dart';
import '../exceptions/permission_exception.dart';
import '../exceptions/outdated_client_exception.dart';
import '../exceptions/register_must_verify_email_exception.dart';
import '../widgets/error_dialog.dart';
import '../widgets/warning_dialog.dart';

abstract class FirebaseBaseProvider {
  static final logger = Logger('FirebaseBaseProvider');

  abstract BuildContext context;
  abstract String apiUrl;

  Future<String> getUserAgent();

  void runCallbackOnMessageError(
      {required Future<void> Function() callback,
      ProgressDialog? dialog,
      required Function onError,
      VoidCallback? onRetry,
      VoidCallback? onSucess}) {
    callback().then((value) => null).onError((error, stackTrace) {
      logger.severe("Failed to run callback", error, stackTrace);
      dialog?.dismiss();
      onErrorDialogs(error, onError: onError, onRetry: onRetry, onSucess: onSucess);
    });
  }

  Future<List<T>> fetchPaginateResult<T>(Future<List<T>> Function() onData, Function onError,
      {VoidCallback? onRetry, VoidCallback? onSucess}) async {
    try {
      var list = await onData();
      return list;
    } catch (e, stackTrace) {
      logger.severe("Failed to fetch paginated result from api", e, stackTrace);
      onErrorDialogs(e, onError: onError, onRetry: onRetry, onSucess: onSucess);
      rethrow;
    }
  }

  void onErrorDialogs(error, {required Function onError, VoidCallback? onRetry, VoidCallback? onSucess}) {
    if (error is AuthException) {
      error.callDialog(onRetry: onRetry, onSuccess: onSucess).whenComplete(() => onError);
    } else if (error is PermissionException) {
      error.callDialog(onRetry: onRetry, onSuccess: onSucess).whenComplete(() => onError);
    } else if (error is AuthWrongException) {
      error.callDialog(onRetry: onRetry, onSuccess: onSucess).whenComplete(() => onError);
    } else if (error is RegisterMustVerifyEmailException) {
      error.callDialog(onSuccess: onSucess).whenComplete(() => onSucess ?? () {});
    } else if (error is OutdatedClientException) {
      error.callDialog(onRetry: onRetry, onSuccess: onSucess).whenComplete(() => onError);
    } else if (error is ValidationException) {
      error.callDialog(onRetry: onRetry, onSuccess: onSucess).whenComplete(() => onError);
    } else if (error is PaymentRefusedException) {
      error.callDialog(onRetry: onRetry, onSuccess: onSucess).whenComplete(() => onError);
    } else if (error is AccountDeletationInProgressException) {
      error.callDialog(onRetry: onRetry, onSuccess: onSucess).whenComplete(() => onError);
    }
    if (error is DioError) {
      if (error.type == DioErrorType.connectTimeout ||
          error.type == DioErrorType.receiveTimeout ||
          error.type == DioErrorType.sendTimeout) {
        Get.dialog(
          ErrorDialog(
              errorMessage: "Falha ao executar a ação\n"
                  "Tempo esgotado aguardando resposta do servidor\n"
                  "Verifique sua conexão com a internet e tente novamente.\n"
                  "Caso o problema persista e não seja sua internet, entre em contato com o suporte.\n",
              onRetry: onRetry),
          barrierDismissible: false,
        ).whenComplete(() => onError);
      } else if (error.type == DioErrorType.other) {
        Get.dialog(
          ErrorDialog(
              errorMessage: "Falha ao conectar ao Servidor\n"
                  "Verifique sua conexão com a internet e tente novamente\n",
              onRetry: onRetry),
          barrierDismissible: false,
        ).whenComplete(() => onError);
      } else if (error.response == null) {
        Get.dialog(
          ErrorDialog(
              errorMessage: "O Servidor não enviou uma resposta\n"
                  "Verifique sua conexão com a internet e tente novamente\n",
              onRetry: onRetry),
          barrierDismissible: false,
        ).whenComplete(() => onError);
      } else {
        if (error.response?.statusCode == 460) {
          Get.dialog(
            ErrorDialog(
                errorMessage: "Este aplicativo está desatualizado\n"
                    "Por favor faça uma atualização na loja de aplicativos de seu dispositivo\n",
                onRetry: onRetry),
            barrierDismissible: false,
          ).whenComplete(() => onError);
        } else if (error.response?.statusCode == 429) {
          Get.dialog(
            ErrorDialog(
                errorMessage: "Você fez várias requisições em um curto periodo de tempo\n"
                    "Muitas tentativas de conexão, tente mais tarde\n",
                onRetry: onRetry),
            barrierDismissible: false,
          ).whenComplete(() => onError);
        } else if (error.response?.statusCode == 500 || error.response?.statusCode == 502) {
          Get.dialog(
            ErrorDialog(
                errorMessage: "Falha no servidor\n"
                    "Ocorreu um problema no nosso sistema\n"
                    "Aguarde um pouco e tente novamente\n"
                    "Caso o problema persista entre em contato com o suporte.\n",
                onRetry: onRetry),
            barrierDismissible: false,
          ).whenComplete(() => onError);
        } else {
          Get.dialog(
            ErrorDialog(
                errorMessage: "Erro desconhecido na conexão com o servidor\n"
                    "Verifique sua conexão com a internet e tente novamente\n"
                    "Detalhes do Erro $error \n",
                onRetry: onRetry),
            barrierDismissible: false,
          ).whenComplete(() => onError);
        }
      }
    } else if (error is SocketException) {
      Get.dialog(
        ErrorDialog(
            errorMessage: "Falha ao conectar-se ao servidor\n"
                "Verifique sua conexão com a internet e tente novamente\n",
            onRetry: onRetry),
        barrierDismissible: false,
      ).whenComplete(() => onError);
    } else {
      Get.dialog(
        ErrorDialog(
            errorMessage: "Falha ao executar a ação\n"
                "Erro: $error\n",
            onRetry: onRetry),
        barrierDismissible: false,
      ).whenComplete(() => onError);
    }
  }

  Future<Dio> dio() async {
    return Dio(BaseOptions(
      baseUrl: "https://$apiUrl/",
      headers: await getHeaders(),
      connectTimeout: 15000,
      contentType: "application/json; charset=utf-8",
    ));
  }

  Future<Map<String, dynamic>> getHeaders() async {
    var headers = {
      "accept": "application/json",
      "user-agent": await getUserAgent(),
      "authorization": accessToken != null ? "Bearer $accessToken" : "Bearer null",
    };
    return headers;
  }

  String? get accessToken {
    final login = Hive.box("settings");
    return login.get("accessToken", defaultValue: null) as String?;
  }

  set accessToken(String? value) {
    final login = Hive.box("settings");
    login.put("accessToken", value);
  }

  String? get refreshToken {
    final login = Hive.box("settings");
    return login.get("refreshToken", defaultValue: null) as String?;
  }

  set refreshToken(String? value) {
    final login = Hive.box("settings");
    login.put("refreshToken", value);
  }

  DateTime? get expiresIn {
    final login = Hive.box("settings");
    return DateTime.fromMillisecondsSinceEpoch((login.get("expiresIn", defaultValue: 0) as int?) ?? 0);
  }

  set expiresIn(DateTime? value) {
    final login = Hive.box("settings");
    login.put("expiresIn", value?.millisecondsSinceEpoch);
  }
}
