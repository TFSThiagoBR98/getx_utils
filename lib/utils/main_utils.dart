import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
// import 'package:money2/money2.dart';

import 'func_utils.dart';

Future<void> initFlutterApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("settings");
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });
}

final NumberFormat lformatMoney = NumberFormat.currency(
  locale: "pt_BR",
  symbol: "R\$",
);

final NumberFormat lformatDouble = NumberFormat.currency(
  locale: "pt_BR",
  symbol: "",
);

String stringDecimalToMoney(String decimalValue) {
  return decimal2money(Decimal.tryParse(decimalValue) ?? Decimal.zero);
}

Decimal money2decimal(String value) {
  return Decimal.parse(lformatMoney.parse(value).toStringAsFixed(8));
}

String decimal2money(Decimal value) {
  return lformatMoney.format(DecimalIntl(value));
}

Decimal string2decimal(String value) {
  return Decimal.parse(lformatDouble.parse(value).toStringAsFixed(8));
}

String decimal2string(Decimal value) {
  return lformatDouble.format(DecimalIntl(value));
}

// final Currency brlCurrency = Currency.create('BRL', 2, symbol: "R\$");

// Money centsToMoney(int cents) {
//   return Money.fromIntWithCurrency(cents, brlCurrency);
// }

// String moneyToString(Money money) {
//   return money.toString();
// }

// Money stringToMoney(String money) {
//   return brlCurrency.parse(money);
// }

// BigInt moneyToCents(Money money) {
//   return money.minorUnits;
// }

void runWhenContextAvaliable(ContextCallback callback) {
  Timer.periodic(const Duration(seconds: 1), (Timer t) async {
    if (Get.context != null) {
      callback(Get.context!);
      t.cancel();
    }
  });
}
