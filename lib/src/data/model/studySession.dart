import 'package:hive_flutter/hive_flutter.dart';

part 'studySession.g.dart';

@HiveType(typeId: 3)
class Studysession {
  @HiveField(0)
  final int remainingSeconds;

  @HiveField(1)
  final bool isRunning;

  @HiveField(2)
  final int lastUpdatedMillis;

  const Studysession({
    required this.remainingSeconds,
    required this.isRunning,
    required this.lastUpdatedMillis,
  });

  Studysession copyWith({
    int? remainingSeconds,
    bool? isRunning,
    int? lastUpdatedMillis,
  }) {
    return Studysession(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      lastUpdatedMillis: lastUpdatedMillis ?? this.lastUpdatedMillis,
    );
  }

  Map<String, dynamic> toMap() => {
    'remainingSeconds': remainingSeconds,
    'isRunning': isRunning,
    'lastUpdatedMillis': lastUpdatedMillis,
  };

  factory Studysession.fromMap(Map<String, dynamic> map) => Studysession(
    remainingSeconds: map['remainingSeconds'],
    isRunning: map['isRunning'],
    lastUpdatedMillis: map['lastUpdatedMillis'],
  );
}
