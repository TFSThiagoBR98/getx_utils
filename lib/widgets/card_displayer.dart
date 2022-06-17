import 'package:flutter/material.dart';

class CardDisplayer extends StatelessWidget {
  final List<Widget> children;

  const CardDisplayer({Key? key, this.children = const <Widget>[]}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: children)));
  }
}
