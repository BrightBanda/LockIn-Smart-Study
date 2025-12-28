import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';
import 'package:smart_study/src/data/model/studySession.dart';
import 'package:smart_study/src/presentation/viewmodel/studyScheduleViewModel.dart';

class StudySessionNotifier extends Notifier<Map<String, Studysession>> {
  late Box<Studysession> _box;
  final Map<String, Timer> _timers = {};

  @override
  Map<String, Studysession> build() {
    _box = Hive.box<Studysession>('sessions');

    ref.onDispose(() {
      for (final timer in _timers.values) {
        timer.cancel();
      }
      _timers.clear();
    });

    return Map<String, Studysession>.from(_box.toMap());
  }

  void startSession(StudySchedule schedule) {
    final id = schedule.id;
    final totalSeconds = schedule.minutes * 60;

    final session =
        state[id] ??
        Studysession(remainingSeconds: totalSeconds, isRunning: false);

    if (session.remainingSeconds <= 0) {
      resetSession(schedule);
    }

    final running = session.copyWith(isRunning: true);
    _save(id, running);

    _timers[id]?.cancel();
    _timers[id] = _timers[id] = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = state[id];
      if (current == null || !current.isRunning) return;

      final nextSeconds = current.remainingSeconds - 1;

      if (nextSeconds <= 0) {
        // SAVE 0 FIRST
        _save(id, current.copyWith(remainingSeconds: 0, isRunning: false));

        _timers[id]?.cancel();
        _timers.remove(id);

        // MARK SCHEDULE COMPLETE
        ref.read(studyScheduleProvider.notifier).markCompleted(id);
        return;
      }

      _save(id, current.copyWith(remainingSeconds: nextSeconds));
    });
  }

  void stopSession(String id) {
    _timers[id]?.cancel();
    _timers.remove(id);

    final session = state[id];
    if (session == null) return;

    _save(id, session.copyWith(isRunning: false));
  }

  void resetSession(StudySchedule schedule) {
    _timers[schedule.id]?.cancel();
    _timers.remove(schedule.id);

    _save(
      schedule.id,
      Studysession(remainingSeconds: schedule.minutes * 60, isRunning: false),
    );
  }

  void clearSessions() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();

    _box.clear();
    state = {};
  }

  void _save(String id, Studysession session) {
    _box.put(id, session);
    state = {...state, id: session};
  }
}

final studySessionProvider =
    NotifierProvider<StudySessionNotifier, Map<String, Studysession>>(
      StudySessionNotifier.new,
    );
