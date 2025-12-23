enum WeekDay { mon, tue, wed, thu, fri, sat, sun }

class StudySchedule {
  final String id; // unique per day-session
  final String subjectId; // link to subject
  final WeekDay day;
  final int minutes;

  StudySchedule({
    required this.id,
    required this.subjectId,
    required this.day,
    required this.minutes,
  });
}
