import 'package:hive_flutter/hive_flutter.dart';

part 'studySession.g.dart';

@HiveType(typeId: 3)
class Studysession {
  @HiveField(0)
  final int remainingSeconds;

  @HiveField(1)
  final bool isRunning;

  const Studysession({required this.remainingSeconds, required this.isRunning});

  Studysession copyWith({int? remainingSeconds, bool? isRunning}) {
    return Studysession(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
