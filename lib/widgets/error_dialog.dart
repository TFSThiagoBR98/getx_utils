import 'package:flutter/material.dart';

class ErrorDialog extends StatefulWidget {
  final String errorMessage;
  final VoidCallback? onRetry;
  final VoidCallback? onOk;

  const ErrorDialog({Key? key, this.errorMessage = "", this.onRetry, this.onOk}) : super(key: key);

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text("Ocorreu um problema"),
      content: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.error_outline, size: 56, color: Colors.red),
          ),
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            title: Text(
              "Ocorreu um problema ao executar a ação",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            subtitle: Text(
              widget.errorMessage,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (widget.onOk != null) {
                        widget.onOk!();
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )),
              ),
            )
          ],
        ),
        if (widget.onRetry != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onRetry!();
                        if (widget.onRetry != null) {
                          widget.onRetry!();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.shade700),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Tentar novamente",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )),
                ),
              )
            ],
          )
      ],
    );
  }
}
