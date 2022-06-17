import 'package:flutter/material.dart';

class ListExpandedItem extends StatelessWidget {
  final String id;
  final String name;

  final ValueChanged<String>? onEdit;
  final ValueChanged<String>? onDelete;

  const ListExpandedItem({Key? key, required this.id, required this.name, this.onEdit, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: const CircleAvatar(backgroundImage: AssetImage("assets/images/shampoo.jpg")),
      title: Text(
        name,
        style: Theme.of(context).textTheme.headline6,
      ),
      tilePadding: const EdgeInsets.all(14.0),
      trailing: SizedBox(
        width: 125,
        child: ButtonBar(
          children: [
            IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                iconSize: 32,
                onPressed: onEdit != null ? () => onEdit!(id) : null,
                icon: const Icon(Icons.edit_outlined)),
            IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              iconSize: 32,
              onPressed: onDelete != null ? () => onDelete!(id) : null,
              icon: const Icon(Icons.delete_outline_rounded),
            )
          ],
        ),
      ),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(8),
                  height: 70,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder?>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                    ),
                    onPressed: onEdit != null ? () => onEdit!(id) : null,
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text("Editar"),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(8),
                  height: 70,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder?>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                    ),
                    onPressed: onDelete != null ? () => onDelete!(id) : null,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text("Apagar"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
