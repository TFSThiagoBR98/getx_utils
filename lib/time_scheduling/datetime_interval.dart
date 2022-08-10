class DateTimeInterval {
  final DateTime start;
  final DateTime end;

  const DateTimeInterval({required this.start, required this.end});

  @override
  String toString() {
    return "${start.toString()} ${end.toString()}";
  }
}
