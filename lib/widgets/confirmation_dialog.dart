import 'package:flutter/material.dart';

class ConfirmationDialog extends StatefulWidget {
  final String message;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({Key? key, this.message = "", this.onConfirm, this.onCancel}) : super(key: key);

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text("Confirmar ação"),
      content: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        leading: Icon(
          Icons.error,
          color: Theme.of(context).hintColor,
        ),
        title: Text(
          "Você deseja confirmar a ação abaixo?",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        subtitle: Text(
          widget.message,
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
                      if (widget.onCancel != null) {
                        widget.onCancel!();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade700),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Cancelar",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (widget.onConfirm != null) {
                        widget.onConfirm!();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade700),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )),
              ),
            ),
          ],
        )
      ],
    );
  }
}
