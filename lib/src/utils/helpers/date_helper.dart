import 'package:smart_study/src/data/model/studySchedule.dart';

/*String todayId() {
  final now = DateTime.now();
  return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
}*/
int isoWeekNumber(DateTime date) {
  final thursday = date.add(Duration(days: 3 - ((date.weekday + 6) % 7)));
  final firstThursday = DateTime(thursday.year, 1, 4);
  return 1 + ((thursday.difference(firstThursday).inDays) / 7).floor();
}

String dayCompletionId(WeekDay day) {
  final now = DateTime.now();
  final week = currentWeekId();
  return "$week-${day.name}";
}

String currentWeekId() {
  final now = DateTime.now();
  final week = isoWeekNumber(now);
  return '${now.year}-W$week';
}
