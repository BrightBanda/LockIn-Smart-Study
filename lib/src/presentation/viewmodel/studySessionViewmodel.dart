import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:smart_study/src/data/model/Subject.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';
import 'package:smart_study/src/data/model/studySession.dart';

class StudySessionNotifier extends Notifier<Map<String, Studysession>> {
  Map<String, Timer> _timers = {};
  @override
  Map<String, Studysession> build() {
    // Initial state
    return {};
  }

  void startSession(StudySchedule schedule) {
    final scheduleId = schedule.id;
    final totalSeconds = schedule.minutes * 60;

    final currentSession =
        state[scheduleId] ??
        Studysession(remainingSeconds: totalSeconds, isRunning: false);

    // Mark as running
    state = {...state, scheduleId: currentSession.copyWith(isRunning: true)};

    // Cancel existing timer for this subject
    _timers[scheduleId]?.cancel();

    _timers[scheduleId] = Timer.periodic(const Duration(seconds: 1), (timer) {
      final session = state[scheduleId];
      if (session == null || !session.isRunning) {
        timer.cancel();
        return;
      }

      if (session.remainingSeconds <= 0) {
        timer.cancel();
        state = {...state, scheduleId: session.copyWith(isRunning: false)};
        return;
      }

      state = {
        ...state,
        scheduleId: session.copyWith(
          remainingSeconds: session.remainingSeconds - 1,
        ),
      };
    });
  }

  void stopSession(String subjectId) {
    _timers[subjectId]?.cancel();
    _timers.remove(subjectId);

    final session = state[subjectId];
    if (session == null) return;

    state = {...state, subjectId: session.copyWith(isRunning: false)};
  }

  void resetSession(StudySchedule schedule) {
    final scheduleId = schedule.id;

    _timers[scheduleId]?.cancel();
    _timers.remove(scheduleId);

    state = {
      ...state,
      scheduleId: Studysession(
        remainingSeconds: schedule.minutes * 60,
        isRunning: false,
      ),
    };
  }
}

final studySessionProvider =
    NotifierProvider<StudySessionNotifier, Map<String, Studysession>>(
      StudySessionNotifier.new,
    );
