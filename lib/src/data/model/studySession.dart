class Studysession {
  final int remainingSeconds;
  final bool isRunning;

  const Studysession({required this.remainingSeconds, required this.isRunning});

  Studysession copyWith({int? remainingSeconds, bool? isRunning}) {
    return Studysession(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
