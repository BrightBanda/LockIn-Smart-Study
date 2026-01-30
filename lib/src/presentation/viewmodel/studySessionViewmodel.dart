import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';
import 'package:smart_study/src/data/model/studySession.dart';
import 'package:smart_study/src/presentation/viewmodel/auth_provide.dart';

class StudySessionNotifier extends Notifier<Map<String, Studysession>> {
  final Map<String, Timer> _timers = {};

  @override
  Map<String, Studysession> build() {
    ref.keepAlive();

    final auth = ref.watch(authStateProvider);
    auth.whenData((user) {
      _clearTimers();

      if (user == null) {
        state = {};
        return;
      }

      _restoreFromHive();
    });

    ref.onDispose(_clearTimers);
    return {};
  }

  // ----------------------------------
  // Restore sessions after app restart
  // ----------------------------------
  void _restoreFromHive() {
    final box = Hive.box<Studysession>('sessions');
    final now = DateTime.now().millisecondsSinceEpoch;

    final restored = <String, Studysession>{};

    for (final key in box.keys) {
      final session = box.get(key);
      if (session == null) continue;

      if (!session.isRunning) {
        restored[key] = session;
        continue;
      }

      final elapsed = ((now - session.lastUpdatedMillis) / 1000).floor();

      final remaining = session.remainingSeconds - elapsed;

      final updated = remaining <= 0
          ? session.copyWith(
              remainingSeconds: 0,
              isRunning: false,
              lastUpdatedMillis: now,
            )
          : session.copyWith(
              remainingSeconds: remaining,
              isRunning: true,
              lastUpdatedMillis: now,
            );

      box.put(key, updated);
      restored[key] = updated;

      if (updated.isRunning) {
        _startTimer(key);
      }
    }

    state = restored;
  }

  // ------------------
  // Start session
  // ------------------
  Future<void> startSession(StudySchedule schedule) async {
    final box = Hive.box<Studysession>('sessions');
    final now = DateTime.now().millisecondsSinceEpoch;

    final session = Studysession(
      remainingSeconds: schedule.minutes * 60,
      isRunning: true,
      lastUpdatedMillis: now,
    );

    await box.put(schedule.id, session);
    state = {...state, schedule.id: session};

    _startTimer(schedule.id);
  }

  // ------------------
  // Stop session
  // ------------------
  Future<void> stopSession(String id) async {
    _timers[id]?.cancel();
    _timers.remove(id);

    final box = Hive.box<Studysession>('sessions');
    final session = box.get(id);
    if (session == null) return;

    final updated = session.copyWith(
      isRunning: false,
      lastUpdatedMillis: DateTime.now().millisecondsSinceEpoch,
    );

    await box.put(id, updated);
    state = {...state, id: updated};
  }

  // ------------------
  // Reset session
  // ------------------
  Future<void> resetSession(StudySchedule schedule) async {
    _timers[schedule.id]?.cancel();
    _timers.remove(schedule.id);

    final box = Hive.box<Studysession>('sessions');

    final reset = Studysession(
      remainingSeconds: schedule.minutes * 60,
      isRunning: false,
      lastUpdatedMillis: DateTime.now().millisecondsSinceEpoch,
    );

    await box.put(schedule.id, reset);
    state = {...state, schedule.id: reset};
  }

  // ------------------
  // Internal timer
  // ------------------
  void _startTimer(String id) {
    _timers[id]?.cancel();

    _timers[id] = Timer.periodic(const Duration(seconds: 1), (_) async {
      final box = Hive.box<Studysession>('sessions');
      final session = box.get(id);
      if (session == null || !session.isRunning) return;

      final updated = session.copyWith(
        remainingSeconds: session.remainingSeconds - 1,
        lastUpdatedMillis: DateTime.now().millisecondsSinceEpoch,
      );

      if (updated.remainingSeconds <= 0) {
        _timers[id]?.cancel();
        _timers.remove(id);

        final finished = updated.copyWith(
          remainingSeconds: 0,
          isRunning: false,
        );

        await box.put(id, finished);
        state = {...state, id: finished};
        return;
      }

      await box.put(id, updated);
      state = {...state, id: updated};
    });
  }

  Future<void> resetAllSessions() async {
    _clearTimers();

    final sessionBox = Hive.box<Studysession>('sessions');
    final updatedState = <String, Studysession>{};

    for (final key in sessionBox.keys) {
      final session = sessionBox.get(key);
      if (session == null) continue;

      final resetSession = session.copyWith(
        remainingSeconds: session.remainingSeconds,
        isRunning: false,
      );

      await sessionBox.put(key, resetSession);
      updatedState[key as String] = resetSession;
    }

    state = updatedState;
  }

  void _clearTimers() {
    for (final t in _timers.values) {
      t.cancel();
    }
    _timers.clear();
  }
}

final studySessionProvider =
    NotifierProvider<StudySessionNotifier, Map<String, Studysession>>(
      StudySessionNotifier.new,
    );
