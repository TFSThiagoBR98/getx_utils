class TFSListItem<T> {
  final String? image;
  final String label;
  final String id;
  final T? item;

  TFSListItem({this.image, required this.label, required this.id, this.item});
}
