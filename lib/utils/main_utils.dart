import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:money2/money2.dart';

import 'func_utils.dart';

abstract class MainUtils {
  static Future<void> initFlutterApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    await Hive.openBox("settings");
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  static final NumberFormat lformatMoney = NumberFormat.currency(
    locale: "pt_BR",
    symbol: "R\$",
  );

  static final NumberFormat lformatDouble = NumberFormat.currency(
    locale: "pt_BR",
    symbol: "",
  );

  static final Currency brlCurrency = Currency.create('BRL', 2, symbol: "R\$");

  static String stringDecimalToMoney(String decimalValue) {
    return decimal2money(Decimal.tryParse(decimalValue) ?? Decimal.zero);
  }

  static Decimal money2decimal(String value) {
    return Decimal.parse(MainUtils.lformatMoney.parse(value).toStringAsFixed(8));
  }

  static String decimal2money(Decimal value) {
    return MainUtils.lformatMoney.format(DecimalIntl(value));
  }

  static Decimal string2decimal(String value) {
    return Decimal.parse(MainUtils.lformatDouble.parse(value).toStringAsFixed(8));
  }

  static String decimal2string(Decimal value) {
    return MainUtils.lformatDouble.format(DecimalIntl(value));
  }

  static Money centsToMoney(int cents) {
    return Money.fromIntWithCurrency(cents, brlCurrency);
  }

  static String moneyToString(Money money) {
    return money.toString();
  }

  static Money stringToMoney(String money) {
    return brlCurrency.parse(money);
  }

  static BigInt moneyToCents(Money money) {
    return money.minorUnits;
  }

  static void runWhenContextAvaliable(ContextCallback callback) {
    Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      if (Get.context != null) {
        callback(Get.context!);
        t.cancel();
      }
    });
  }
}
