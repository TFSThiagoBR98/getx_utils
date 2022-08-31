import 'package:flutter/material.dart';

class AddMediaWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? cardColor;

  const AddMediaWidget({Key? key, required this.onTap, this.cardColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: SizedBox(
            width: 220,
            child: Stack(
              children: [
                Center(
                  child: InkWell(
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.add_circle_rounded,
                            size: 75,
                          ),
                          Text('Adicionar imagem'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
