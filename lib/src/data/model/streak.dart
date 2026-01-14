class Streak {
  final int current;
  final String lastCompletedDay;

  Streak({required this.current, required this.lastCompletedDay});

  factory Streak.fromMap(Map<String, dynamic> map) {
    return Streak(
      current: map['current'] ?? 0,
      lastCompletedDay: map['lastCompletedDay'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'current': current, 'lastCompletedDay': lastCompletedDay};
  }
}
