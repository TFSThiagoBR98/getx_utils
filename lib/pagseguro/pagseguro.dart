import 'package:fast_rsa/fast_rsa.dart';

abstract class PagSeguro {
  Future<String> encryptCard(
      {required String number,
      required String securityCode,
      required String expMonth,
      required String expYear,
      required String holder,
      required String publicKey}) async {
    var now = DateTime.now().millisecondsSinceEpoch;
    var message = "$number;$securityCode;$expMonth;$expYear;$holder;$now";
    var result = await RSA.encryptPKCS1v15(message, publicKey);
    return result;
  }
}
