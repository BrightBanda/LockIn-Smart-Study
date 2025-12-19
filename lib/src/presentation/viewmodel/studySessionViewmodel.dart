import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/data/model/Subject.dart';
import 'package:smart_study/src/data/model/studySession.dart';

class StudySessionNotifier extends Notifier<Map<String, Studysession>> {
  Map<String, Timer> _timers = {};
  @override
  Map<String, Studysession> build() {
    // Initial state
    return {};
  }

  void startSession(Subject subject) {
    final subjectId = subject.id;

    final currentSession =
        state[subjectId] ??
        Studysession(remainingSeconds: subject.time * 60, isRunning: false);

    // Mark as running
    state = {...state, subjectId: currentSession.copyWith(isRunning: true)};

    // Cancel existing timer for this subject
    _timers[subjectId]?.cancel();

    _timers[subjectId] = Timer.periodic(const Duration(seconds: 1), (timer) {
      final session = state[subjectId];
      if (session == null || !session.isRunning) {
        timer.cancel();
        return;
      }

      if (session.remainingSeconds <= 0) {
        timer.cancel();
        state = {...state, subjectId: session.copyWith(isRunning: false)};
        return;
      }

      state = {
        ...state,
        subjectId: session.copyWith(
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

  void resetSession(Subject subject) {
    final subjectId = subject.id;

    _timers[subjectId]?.cancel();
    _timers.remove(subjectId);

    state = {
      ...state,
      subjectId: Studysession(
        remainingSeconds: subject.time * 60,
        isRunning: false,
      ),
    };
  }
}

final studySessionProvider =
    NotifierProvider<StudySessionNotifier, Map<String, Studysession>>(
      StudySessionNotifier.new,
    );
