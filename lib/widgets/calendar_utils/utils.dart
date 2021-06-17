import 'dart:math';

/// Example event class.
class Event {
  final String classTime;
  final String className;
  final int scheduleId;
  final int classLength;

  const Event(this.scheduleId, this.className, this.classTime, this.classLength);

  @override
  String toString() => classTime;
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

var rng = Random();