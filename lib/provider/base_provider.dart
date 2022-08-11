import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

abstract class BaseProvider {
  Logger logger();

  abstract BuildContext context;
}
