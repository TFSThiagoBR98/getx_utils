import 'package:flutter/material.dart' hide Builder;
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum GetXDateTimeControllerDisplayFormat { date, time, datetime }

class GetXDateTimeController<T> {
  late final Rxn<DateTime> dataRx;
  DateTime? get data => dataRx.value;
  set data(DateTime? value) => dataRx.value = value;

  final Rx<TextEditingController> _controller = TextEditingController().obs;
  TextEditingController get controller => _controller.value;
  set controller(TextEditingController value) => _controller.value = value;

  final GetXDateTimeControllerDisplayFormat format;

  final String displayDateFormat = "dd/MM/yyyy";
  final String displayTimeFormat = "HH:mm:ss";

  final String internalDateFormat = "yyyy-MM-dd";
  final String internalTimeFormat = "HH:mm:ss";

  String get displayFormat {
    if (format == GetXDateTimeControllerDisplayFormat.date) {
      return displayDateFormat;
    } else if (format == GetXDateTimeControllerDisplayFormat.time) {
      return displayTimeFormat;
    } else {
      return "$displayDateFormat $displayTimeFormat";
    }
  }

  String get internalFormat {
    if (format == GetXDateTimeControllerDisplayFormat.date) {
      return internalDateFormat;
    } else if (format == GetXDateTimeControllerDisplayFormat.time) {
      return internalTimeFormat;
    } else {
      return "$internalDateFormat $internalTimeFormat";
    }
  }

  String? toInternalFormat() {
    if (data == null) return null;
    try {
      return DateFormat(internalFormat).format(data!);
    } on FormatException {
      return null;
    }
  }

  void setData(String value) {
    try {
      data = DateFormat(internalFormat).parse(value);
      controller.text = DateFormat(displayFormat).format(data!);
    } on FormatException {
      data = null;
      controller.text = "";
    }
  }

  Future<DateTime?> selectPeriod() async {
    if (format == GetXDateTimeControllerDisplayFormat.date || format == GetXDateTimeControllerDisplayFormat.datetime) {
      var range = await showDatePicker(
        initialDate: data ?? DateTime(2019),
        firstDate: DateTime(1900),
        useRootNavigator: true,
        initialEntryMode: DatePickerEntryMode.calendar,
        textDirection: null,
        lastDate: DateTime.now().add(const Duration(days: 1)),
        context: Get.context!,
      );

      if (range != null) {
        if (data != null) {
          data = DateTime(range.year, range.month, range.day, data!.hour, data!.minute);
        } else {
          data = DateTime(range.year, range.month, range.day, 0, 0);
        }
      }
    }

    if (format == GetXDateTimeControllerDisplayFormat.time || format == GetXDateTimeControllerDisplayFormat.datetime) {
      var range = await showTimePicker(
        initialTime: data != null ? TimeOfDay.fromDateTime(data!) : const TimeOfDay(hour: 00, minute: 00),
        useRootNavigator: true,
        initialEntryMode: TimePickerEntryMode.input,
        context: Get.context!,
      );

      if (range != null) {
        if (data != null) {
          data = DateTime(data!.year, data!.month, data!.day, range.hour, range.minute);
        } else {
          data = DateTime(2019, 1, 1, range.hour, range.minute);
        }
      }
    }

    if (data == null) {
      controller.text = "";
      return null;
    }

    controller.text = DateFormat(displayFormat).format(data!);
    return data;
  }

  GetXDateTimeController(this.format) {
    dataRx = Rxn<DateTime>();
  }
}
