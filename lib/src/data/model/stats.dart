class Stats {
  final int totalStudyMinutes;
  final int totalSubjects;
  final int totalSchedules;
  final DateTime memberSince;

  Stats({
    required this.totalStudyMinutes,
    required this.totalSubjects,
    required this.totalSchedules,
    required this.memberSince,
  });

  double get totalStudyHours => totalStudyMinutes / 60;
}
