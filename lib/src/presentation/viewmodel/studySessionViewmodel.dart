import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';
import 'package:smart_study/src/data/model/studySession.dart';
import 'package:smart_study/src/presentation/viewmodel/auth_provide.dart';
import 'package:smart_study/src/presentation/viewmodel/studyScheduleViewModel.dart';

class StudySessionNotifier extends Notifier<Map<String, Studysession>> {
  final Map<String, Timer> _timers = {};

  @override
  Map<String, Studysession> build() {
    _listen();
    ref.onDispose(_clearTimers);
    return {};
  }

  void _listen() {
    final userData = ref.read(userDataServiceProvider);

    userData.sessionRef().snapshots().listen((snapshot) {
      final map = <String, Studysession>{};

      for (final doc in snapshot.docs) {
        map[doc.id] = Studysession(
          remainingSeconds: doc['remainingSeconds'],
          isRunning: doc['isRunning'],
        );
      }

      state = map;
    });
  }

  Future<void> startSession(StudySchedule schedule) async {
    final userData = ref.read(userDataServiceProvider);
    final id = schedule.id;

    await userData.sessionRef().doc(id).set({
      'remainingSeconds': schedule.minutes * 60,
      'isRunning': true,
    });

    _timers[id]?.cancel();
    _timers[id] = Timer.periodic(const Duration(seconds: 1), (_) async {
      final current = state[id];
      if (current == null || !current.isRunning) return;

      final next = current.remainingSeconds - 1;

      if (next <= 0) {
        await userData.sessionRef().doc(id).update({
          'remainingSeconds': 0,
          'isRunning': false,
        });

        ref.read(studyScheduleProvider.notifier).markCompleted(id);
        _timers[id]?.cancel();
        return;
      }

      await userData.sessionRef().doc(id).update({'remainingSeconds': next});
    });
  }

  Future<void> stopSession(String id) async {
    final userData = ref.read(userDataServiceProvider);

    _timers[id]?.cancel();
    _timers.remove(id);

    await userData.sessionRef().doc(id).update({'isRunning': false});
  }

  Future<void> resetSession(StudySchedule schedule) async {
    final userData = ref.read(userDataServiceProvider);

    await userData.sessionRef().doc(schedule.id).set({
      'remainingSeconds': schedule.minutes * 60,
      'isRunning': false,
    });
  }

  void _clearTimers() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
  }
}

final studySessionProvider =
    NotifierProvider<StudySessionNotifier, Map<String, Studysession>>(
      StudySessionNotifier.new,
    );
