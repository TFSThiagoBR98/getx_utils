import 'package:flutter/material.dart';

class ContinueCreateDialog extends StatefulWidget {
  final String message;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ContinueCreateDialog(
      {super.key, this.message = '', this.onConfirm, this.onCancel});

  @override
  State<ContinueCreateDialog> createState() => _ContinueCreateDialogState();
}

class _ContinueCreateDialogState extends State<ContinueCreateDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Continuar a criar'),
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
              'Você deseja continuar a criar ${widget.message}?',
              style: Theme.of(context).textTheme.titleMedium,
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
                      if (widget.onCancel != null) {
                        widget.onCancel!();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red.shade700),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Finalizar',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (widget.onConfirm != null) {
                        widget.onConfirm!();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.green.shade700),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Continuar a criar',
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
