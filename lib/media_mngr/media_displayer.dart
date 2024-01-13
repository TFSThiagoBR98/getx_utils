import 'package:flutter/material.dart';

class MediaDisplayer extends StatelessWidget {
  final ImageProvider image;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Color? cardColor;

  const MediaDisplayer(
      {super.key,
      required this.image,
      this.onTap,
      this.onDelete,
      this.cardColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Stack(
          fit: StackFit.loose,
          children: [
            Image(
              image: image,
              height: 200,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
              ),
            )
          ],
        ),
      ),
    );
  }
}
