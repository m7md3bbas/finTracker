List<DateTime> _generateDatesForTwoYears() {
  final start = DateTime.now();
  final end = DateTime(start.year + 2, start.month, start.day);
  final days = <DateTime>[];
  for (int i = 0; i <= end.difference(start).inDays; i++) {
    days.add(start.add(Duration(days: i)));
  }
  return days;
}
