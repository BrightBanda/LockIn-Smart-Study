import 'package:hive/hive.dart';

part 'studySchedule.g.dart';

@HiveType(typeId: 2)
enum WeekDay {
  @HiveField(0)
  mon,
  @HiveField(1)
  tue,
  @HiveField(2)
  wed,
  @HiveField(3)
  thu,
  @HiveField(4)
  fri,
  @HiveField(5)
  sat,
  @HiveField(6)
  sun,
}

@HiveType(typeId: 1)
class StudySchedule {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String subjectId;

  @HiveField(2)
  final WeekDay day;

  @HiveField(3)
  final int minutes;

  StudySchedule({
    required this.id,
    required this.subjectId,
    required this.day,
    required this.minutes,
  });
}
