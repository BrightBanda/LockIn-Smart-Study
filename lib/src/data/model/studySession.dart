import 'package:hive_flutter/hive_flutter.dart';

part 'studySession.g.dart';

@HiveType(typeId: 3)
class Studysession {
  @HiveField(0)
  final int remainingSeconds;

  @HiveField(1)
  final bool isRunning;

  const Studysession({required this.remainingSeconds, required this.isRunning});

  Studysession copyWith({
    int? remainingSeconds,
    bool? isRunning,
    int? lastUpdatedMillis,
  }) {
    return Studysession(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
    );
  }

  Map<String, dynamic> toMap() => {
    'remainingSeconds': remainingSeconds,
    'isRunning': isRunning,
  };

  factory Studysession.fromMap(Map<String, dynamic> map) => Studysession(
    remainingSeconds: map['remainingSeconds'],
    isRunning: map['isRunning'],
  );
}
