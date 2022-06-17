import 'package:flutter/material.dart';

import 'input_formfield.dart';

class ListTop extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? labelText;

  const ListTop({Key? key, required this.title, this.controller, this.onChanged, this.labelText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                child: InputFormfield(controller: controller, onChanged: onChanged, labelText: labelText),
              ))
            ],
          )
        ],
      ),
    );
  }
}
