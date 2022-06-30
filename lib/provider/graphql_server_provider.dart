import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import "package:gql_dio_link/gql_dio_link.dart";
import 'package:ferry/ferry.dart';
import 'package:ndialog/ndialog.dart';
import 'package:universal_io/io.dart';
import '../exceptions/auth_exception.dart';
import '../exceptions/auth_wrong_exception.dart';
import '../exceptions/permission_exception.dart';
import '../exceptions/outdated_client_exception.dart';
import '../exceptions/register_must_verify_email_exception.dart';
import '../widgets/error_dialog.dart';
import '../widgets/warning_dialog.dart';

abstract class GraphQLServerProvider {
  static final logger = Logger('GraphQLServerProvider');

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
      Get.dialog(
        ErrorDialog(
            errorMessage: "Falha ao executar a ação\n"
                "Você não está conectado a sua conta, por favor faça o login\n",
            onRetry: onRetry),
        barrierDismissible: false,
      ).whenComplete(() => onError);
    } else if (error is PermissionException) {
      Get.dialog(
        ErrorDialog(
            errorMessage: "Falha ao executar a ação\n"
                "Você não tem permissão para executar esta ação\n",
            onRetry: onRetry),
        barrierDismissible: false,
      ).whenComplete(() => onError);
    } else if (error is AuthWrongException) {
      Get.dialog(
        ErrorDialog(
            errorMessage: "Falha ao executar a ação\n"
                "Usuário ou senha inválidos\n",
            onRetry: onRetry),
        barrierDismissible: false,
      ).whenComplete(() => onError);
    } else if (error is RegisterMustVerifyEmailException) {
      Get.dialog(
        WarningDialog(
            errorMessage: "Registro efetuado com sucesso\n"
                "Por favor verifique seu email para ativar sua conta\n",
            onOk: onSucess),
        barrierDismissible: false,
      ).whenComplete(() => onSucess ?? () {});
    } else if (error is OutdatedClientException) {
      Get.dialog(
        ErrorDialog(
            errorMessage: "Falha ao executar a ação\n"
                "Este aplicativo está desatualizado\n"
                "Por favor faça uma atualização na loja de aplicativos de seu dispositivo\n",
            onRetry: onRetry),
        barrierDismissible: false,
      ).whenComplete(() => onError);
    } else if (error is ServerException) {
      Get.dialog(
        ErrorDialog(
            errorMessage: "Falha ao executar a ação\n"
                "Falha no servidor\n"
                "Ocorreu um problema no nosso sistema\n"
                "Aguarde um pouco e tente novamente\n"
                "Caso o problema persista entre em contato com o suporte.\n",
            onRetry: onRetry),
        barrierDismissible: false,
      ).whenComplete(() => onError);
    } else if (error is DioError) {
      if (error.type == DioErrorType.connectTimeout) {
        Get.dialog(
          ErrorDialog(
              errorMessage: "Falha ao executar a ação\n"
                  "Tempo esgotado aguardando resposta do servidor\n"
                  "Verifique sua conexão com a internet e tente novamente.\n"
                  "Caso o problema persista e não seja sua internet, entre em contato com o suporte.\n",
              onRetry: onRetry),
          barrierDismissible: false,
        ).whenComplete(() => onError);
      } else if (error.response == null) {
        Get.dialog(
          ErrorDialog(
              errorMessage: "Falha ao executar a ação\n"
                  "O Servidor não enviou uma resposta\n"
                  "Verifique sua conexão com a internet e tente novamente\n",
              onRetry: onRetry),
          barrierDismissible: false,
        ).whenComplete(() => onError);
      } else {
        if (error.response?.statusCode == 460) {
          Get.dialog(
            ErrorDialog(
                errorMessage: "Falha ao executar a ação\n"
                    "Este aplicativo está desatualizado\n"
                    "Por favor faça uma atualização na loja de aplicativos de seu dispositivo\n",
                onRetry: onRetry),
            barrierDismissible: false,
          ).whenComplete(() => onError);
        } else if (error.response?.statusCode == 429) {
          Get.dialog(
            ErrorDialog(
                errorMessage: "Falha ao executar a ação\n"
                    "Você fez várias requisições em um curto periodo de tempo\n"
                    "Muitas tentativas de conexão, tente mais tarde\n",
                onRetry: onRetry),
            barrierDismissible: false,
          ).whenComplete(() => onError);
        } else if (error.response?.statusCode == 500 || error.response?.statusCode == 502) {
          Get.dialog(
            ErrorDialog(
                errorMessage: "Falha ao executar a ação\n"
                    "Falha no servidor\n"
                    "Ocorreu um problema no nosso sistema\n"
                    "Aguarde um pouco e tente novamente\n"
                    "Caso o problema persista entre em contato com o suporte.\n",
                onRetry: onRetry),
            barrierDismissible: false,
          ).whenComplete(() => onError);
        } else {
          Get.dialog(
            ErrorDialog(
                errorMessage: "Falha ao executar a ação\n"
                    "Erro desconhecido na conexão com o servidor\n"
                    "Verifique sua conexão com a internet e tente novamente\n"
                    "Detalhes $error \n",
                onRetry: onRetry),
            barrierDismissible: false,
          ).whenComplete(() => onError);
        }
      }
    } else if (error is SocketException) {
      Get.dialog(
        ErrorDialog(
            errorMessage: "Falha ao executar a ação\n"
                "Falha ao conectar-se ao servidor\n"
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

  Future<OperationResponse<TData, TVars>> fetchFromGraphQl<TData, TVars>(OperationRequest<TData, TVars> request) async {
    var resp = await (await graphQlClient()).request(request).first;
    if (resp.hasErrors) {
      if (resp.graphqlErrors?.first.message == "Unauthenticated." ||
          resp.graphqlErrors?.first.message == "Not Authenticated") {
        throw AuthException(message: resp.graphqlErrors?.first.message ?? "");
      }

      if (resp.graphqlErrors?.first.message == "invalid_grant") {
        throw AuthWrongException(message: resp.graphqlErrors?.first.message ?? "");
      }

      if (resp.graphqlErrors?.first.message == "Outdated Client") {
        throw OutdatedClientException();
      }

      if (resp.graphqlErrors?.first.message == "This action is unauthorized.") {
        throw PermissionException(message: "Esta ação não está autorizada");
      }

      if (resp.graphqlErrors?.first.message == "Internal server error") {
        throw ServerException(originalException: throw Exception("Failed to execute the request - SERVER ERROR"));
      }

      if (resp.linkException != null) {
        if (resp.linkException is ServerException) {
          if (resp.linkException?.originalException is Exception) {
            throw (resp.linkException?.originalException as Exception);
          }
          throw resp.linkException as ServerException;
        } else if (resp.linkException is LinkException) {
          if (resp.linkException?.originalException is DioError) {
            throw (resp.linkException?.originalException as DioError);
          } else {
            throw resp.linkException as LinkException;
          }
        } else {
          throw Exception("Failed to execute the request - LINK: ${resp.linkException}");
        }
      }

      if (resp.graphqlErrors != null && resp.graphqlErrors!.isNotEmpty) {
        throw Exception("Failed to execute the request - GRAPHQL: ${resp.graphqlErrors}");
      }

      throw Exception("Failed to execute the request - UNKNOWN");
    } else {
      logger.finest("Request executed with SUCCESS");

      return resp;
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

  Future<Client> graphQlClient() async {
    return Client(link: DioLink("/graphql", client: await dio()));
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
