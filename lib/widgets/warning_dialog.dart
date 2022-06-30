import 'package:flutter/material.dart';

class WarningDialog extends StatefulWidget {
  final String errorMessage;
  final VoidCallback? onOk;

  const WarningDialog({Key? key, this.errorMessage = "", this.onOk}) : super(key: key);

  @override
  State<WarningDialog> createState() => _WarningDialogState();
}

class _WarningDialogState extends State<WarningDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text("Aviso"),
      content: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        leading: const Icon(
          Icons.warning_amber,
          size: 40,
          color: Colors.amber,
        ),
        title: Text(
          "Atenção",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        subtitle: Text(
          widget.errorMessage,
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (widget.onOk != null) {
                        widget.onOk!();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade700),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )),
              ),
            )
          ],
        ),
      ],
    );
  }
}
