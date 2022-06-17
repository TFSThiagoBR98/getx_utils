import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.touch,
        PointerDeviceKind.unknown
      };
}
