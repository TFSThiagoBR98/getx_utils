import 'package:intl/intl.dart';

import '../app/tfs_datetime_controller.dart';

String fetchTimeLeftFromDuration(Duration duration) {
  var microseconds = duration.inMicroseconds;

  var hours = microseconds ~/ Duration.microsecondsPerHour;
  microseconds = microseconds.remainder(Duration.microsecondsPerHour);

  if (microseconds < 0) microseconds = -microseconds;

  var minutes = microseconds ~/ Duration.microsecondsPerMinute;
  microseconds = microseconds.remainder(Duration.microsecondsPerMinute);

  var minutesPadding = minutes < 10 ? '0' : '';

  var seconds = microseconds ~/ Duration.microsecondsPerSecond;
  microseconds = microseconds.remainder(Duration.microsecondsPerSecond);

  var secondsPadding = seconds < 10 ? '0' : '';

  return '$hours:'
      '$minutesPadding$minutes:'
      '$secondsPadding$seconds';
}

double percentageLeftFromPadding(String startDateTime, String? targetDateTime) {
  if (targetDateTime != null) {
    DateTime now = DateTime.now().toUtc();
    DateTime start = fromInternal(
        startDateTime, TFSDateTimeControllerDisplayFormat.datetime)!;
    DateTime end = fromInternal(
        targetDateTime, TFSDateTimeControllerDisplayFormat.datetime)!;
    Duration total = end.difference(start);
    Duration left = end.difference(now);
    double percentage = (left.inMilliseconds / total.inMilliseconds);
    return percentage;
  } else {
    return 1;
  }
}

const String displayDateFormat = 'dd/MM/yyyy';
const String displayTimeFormat = 'HH:mm:ss';

const String internalDateFormat = 'yyyy-MM-dd';
const String internalTimeFormat = 'HH:mm:ss';

String displayFormat(TFSDateTimeControllerDisplayFormat format) {
  if (format == TFSDateTimeControllerDisplayFormat.date) {
    return displayDateFormat;
  } else if (format == TFSDateTimeControllerDisplayFormat.time) {
    return displayTimeFormat;
  } else {
    return '$displayDateFormat $displayTimeFormat';
  }
}

String internalFormat(TFSDateTimeControllerDisplayFormat format) {
  if (format == TFSDateTimeControllerDisplayFormat.date) {
    return internalDateFormat;
  } else if (format == TFSDateTimeControllerDisplayFormat.time) {
    return internalTimeFormat;
  } else {
    return '$internalDateFormat $internalTimeFormat';
  }
}

String? toInternalFormat(
    DateTime? data, TFSDateTimeControllerDisplayFormat format) {
  if (data == null) return null;
  try {
    return DateFormat(internalFormat(format)).format(data.toUtc());
  } on FormatException {
    return null;
  }
}

String? fromInternalToDisplayFormat(
    String value, TFSDateTimeControllerDisplayFormat format) {
  try {
    DateTime? data = fromInternal(value, format);
    if (data == null) return null;
    return DateFormat(displayFormat(format)).format(data.toLocal());
  } on FormatException {
    return null;
  }
}

String? toDisplayFormat(
    DateTime? data, TFSDateTimeControllerDisplayFormat format) {
  if (data == null) return null;
  try {
    return DateFormat(displayFormat(format)).format(data);
  } on FormatException {
    return null;
  }
}

DateTime? fromInternal(
    String value, TFSDateTimeControllerDisplayFormat format) {
  try {
    return DateFormat(internalFormat(format)).parse(value, true);
  } on FormatException {
    return null;
  }
}

DateTime? fromDisplay(String value, TFSDateTimeControllerDisplayFormat format) {
  try {
    return DateFormat(displayFormat(format)).parse(value, false);
  } on FormatException {
    return null;
  }
}
