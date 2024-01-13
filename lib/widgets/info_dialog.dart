import 'package:flutter/material.dart';

class InfoDialog extends StatefulWidget {
  final String errorMessage;
  final VoidCallback? onOk;

  const InfoDialog({super.key, this.errorMessage = '', this.onOk});

  @override
  State<InfoDialog> createState() => _InfoDialogState();
}

class _InfoDialogState extends State<InfoDialog> {
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
              Icons.info_outline,
              size: 56,
              color: Colors.blue,
            ),
          ),
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            title: Text(
              'Informação',
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
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.green.shade700),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
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
