import 'package:flutter/material.dart';

class WarningDialog extends StatefulWidget {
  final String errorMessage;
  final VoidCallback? onOk;

  const WarningDialog({super.key, this.errorMessage = '', this.onOk});

  @override
  State<WarningDialog> createState() => _WarningDialogState();
}

class _WarningDialogState extends State<WarningDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text(
        'Aviso',
        textAlign: TextAlign.center,
      ),
      content: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.warning_amber,
              size: 56,
              color: Colors.amber,
            ),
          ),
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            title: Text(
              'Atenção',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            subtitle: Text(
              widget.errorMessage,
              style: Theme.of(context).textTheme.titleSmall,
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
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Colors.green.shade700),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'OK',
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
