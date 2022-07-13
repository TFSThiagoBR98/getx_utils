import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:sodium_libs/sodium_libs.dart' as sodium_lib;
import 'package:fast_rsa/fast_rsa.dart';

abstract class PagSeguro {
  static Future<String> cryptoServerData({required String data, required Uint8List publicKey}) async {
    final sodium = await sodium_lib.SodiumInit.init();
    final Uint8List messageBytes = data.toCharArray().unsignedView();
    final Uint8List sealMessage = sodium.crypto.box.seal(message: messageBytes, publicKey: publicKey);
    return base64Encode(sealMessage);
  }

  static String generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<String> addNounce({
    required String data,
    required Uint8List publicKey,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    final message = "$data;$now;$nonce";
    var result = await cryptoServerData(data: message, publicKey: publicKey);
    return result;
  }

  static Future<String> cryptoCardDataPagSeguro(
      {required String number,
      required String securityCode,
      required String expMonth,
      required String expYear,
      required String holder,
      required String publicKey}) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final message = "$number;$securityCode;$expMonth;$expYear;$holder;$now";
    final result = await RSA.encryptPKCS1v15(message, publicKey);
    return result;
  }
}
