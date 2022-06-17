import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

abstract class MainUtils {
  static Future<void> initFlutterApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    await Hive.openBox("settings");
    Logger.root.level = Level.ALL; // defaults to Level.INFO
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
}
