import 'datetime_interval.dart';

typedef PeriodIntervalFilter = PeriodIteratorValidation Function(DateTimeInterval current);

enum PeriodIteratorValidation { valid, invalid, endIterator }

class DateTimePeriod implements Iterator<DateTimeInterval> {
  final DateTimeInterval dateTimeBetween;
  final Duration interval;
  final List<PeriodIntervalFilter> filters;

  DateTimePeriod({required this.interval, required this.dateTimeBetween, this.filters = const []});

  static const nextMaxAttempts = 1000;

  DateTimeInterval? _current;
  PeriodIteratorValidation? _iteratorValidation;

  @override
  DateTimeInterval get current => _current!;

  PeriodIteratorValidation _endTimeFilter(DateTimeInterval current) {
    if (interval.isNegative
        ? current.start.isAfter(dateTimeBetween.end)
        : current.start.isBefore(dateTimeBetween.end)) {
      return PeriodIteratorValidation.valid;
    }

    return PeriodIteratorValidation.endIterator;
  }

  DateTimeInterval fromStartTime({required DateTime start, required Duration duration}) {
    return DateTimeInterval(start: start, end: start.add(duration));
  }

  void _rewind() {
    _current = fromStartTime(start: dateTimeBetween.start, duration: interval);
    _iteratorValidation = null;
  }

  void _incrementCurrentDateUntilValid() {
    var attempts = 0;
    do {
      _current = fromStartTime(start: _current!.start.add(interval), duration: interval);
      _iteratorValidation = null;
      if (++attempts > nextMaxAttempts) {
        throw Exception('Could not find next valid date.');
      }
    } while (_validateCurrentDate() == PeriodIteratorValidation.invalid);
  }

  PeriodIteratorValidation _validateCurrentDate() {
    if (_current == null) {
      _rewind();
    }

    // Check after the first rewind to avoid repeating the initial validation.
    return _iteratorValidation ?? (_iteratorValidation = _checkFilters());
  }

  // Run the filters
  PeriodIteratorValidation _checkFilters() {
    var intFilters = filters.toList();
    intFilters.add(_endTimeFilter);

    for (final funct in intFilters) {
      var ret = funct(current);
      switch (ret) {
        case PeriodIteratorValidation.invalid:
        case PeriodIteratorValidation.endIterator:
          return ret;
        case PeriodIteratorValidation.valid:
          continue;
      }
    }

    return PeriodIteratorValidation.valid;
  }

  @override
  bool moveNext() {
    if (_current == null) {
      _rewind();
    }

    if (_iteratorValidation != PeriodIteratorValidation.endIterator) {
      _incrementCurrentDateUntilValid();
      return true;
    } else {
      return false;
    }
  }

  List<DateTimeInterval> toList({bool growable = true}) {
    // Save iterator state
    DateTimeInterval? sCurrent = _current;
    PeriodIteratorValidation? sPeriodIteratorValidation = _iteratorValidation;

    var list = <DateTimeInterval>[];
    while (moveNext()) {
      list.add(current);
    }

    // Check iterator state
    _current = sCurrent;
    _iteratorValidation = sPeriodIteratorValidation;

    return list.toList(growable: growable);
  }
}
