import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class TFSAutoBinderView<C> extends GetView<C> {
  TFSAutoBinderView({super.key, Bindings? binding}) {
    binding?.dependencies();
  }
}

abstract class TFSFullView<T extends GetxController> extends StatefulWidget {
  TFSFullView({super.key, Bindings? binding}) {
    binding?.dependencies();
  }
}

abstract class GetFullViewState<L extends StatefulWidget,
    T extends GetxController> extends State<L> {
  final String? tag = null;

  T get controller => GetInstance().find<T>(tag: tag);

  @override
  Widget build(BuildContext context);
}
