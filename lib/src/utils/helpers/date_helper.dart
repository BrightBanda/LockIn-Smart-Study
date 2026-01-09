String todayId() {
  final now = DateTime.now();
  return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
}

String currentWeekId() {
  final now = DateTime.now();
  final week = ((now.day - now.weekday + 10) / 7).floor();
  return '${now.year}-W$week';
}
