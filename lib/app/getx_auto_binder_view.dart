import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class GetxAutoBinderView<C> extends GetView<C> {
  GetxAutoBinderView({Key? key, Bindings? binding}) : super(key: key) {
    binding?.dependencies();
  }
}

abstract class GetxFullView<T extends GetxController> extends StatefulWidget {
  GetxFullView({Key? key, Bindings? binding}) : super(key: key) {
    binding?.dependencies();
  }
}

abstract class GetFullViewState<L extends StatefulWidget, T extends GetxController> extends State<L> {
  final String? tag = null;

  T get controller => GetInstance().find<T>(tag: tag);

  @override
  Widget build(BuildContext context);
}
