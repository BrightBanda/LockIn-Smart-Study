import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';
import 'package:smart_study/src/data/model/studySession.dart';
import 'package:smart_study/src/presentation/viewmodel/auth_provide.dart';
import 'package:smart_study/src/presentation/viewmodel/studyScheduleViewModel.dart';

class StudySessionNotifier extends Notifier<Map<String, Studysession>> {
  final Map<String, Timer> _timers = {};
  StreamSubscription? _subscription;

  @override
  Map<String, Studysession> build() {
    ref.keepAlive();

    final auth = ref.watch(authStateProvider);

    auth.whenData((user) {
      _subscription?.cancel();
      _clearTimers();

      if (user == null) {
        state = {};
        return;
      }

      _startListening();
    });

    ref.onDispose(() {
      _subscription?.cancel();
      _clearTimers();
    });

    return {};
  }

  void _startListening() {
    _subscription?.cancel(); // ✅ ADD THIS

    final userData = ref.read(userDataServiceProvider);

    _subscription = userData.sessionRef().snapshots().listen((snapshot) {
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

    final current = state[id];

    // 🟢 CASE 1: session does NOT exist yet → create it
    if (current == null) {
      final newSession = Studysession(
        remainingSeconds: schedule.minutes * 60,
        isRunning: true,
      );

      state = {...state, id: newSession};

      await userData.sessionRef().doc(id).set({
        'remainingSeconds': newSession.remainingSeconds,
        'isRunning': true,
      });

      _startTimer(id);
      return;
    }

    // 🟡 CASE 2: already running → do nothing
    if (current.isRunning) return;

    // 🔵 CASE 3: paused → resume
    if (current.remainingSeconds <= 0) return;

    state = {...state, id: current.copyWith(isRunning: true)};
    await userData.sessionRef().doc(id).update({'isRunning': true});

    _startTimer(id);
  }

  Future<void> stopSession(String id) async {
    final userData = ref.read(userDataServiceProvider);

    _timers[id]?.cancel();
    _timers.remove(id);

    final current = state[id];
    if (current != null) {
      state = {...state, id: current.copyWith(isRunning: false)};
    }

    await userData.sessionRef().doc(id).update({'isRunning': false});
  }

  void _clearTimers() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
  }

  void _startTimer(String id) {
    _timers[id]?.cancel();

    _timers[id] = Timer.periodic(const Duration(seconds: 1), (_) async {
      final current = state[id];
      if (current == null || !current.isRunning) return;

      final next = current.remainingSeconds - 1;

      if (next <= 0) {
        _timers[id]?.cancel();

        state = {
          ...state,
          id: current.copyWith(remainingSeconds: 0, isRunning: false),
        };

        final userData = ref.read(userDataServiceProvider);
        await userData.sessionRef().doc(id).update({
          'remainingSeconds': 0,
          'isRunning': false,
        });

        ref.read(studyScheduleProvider.notifier).markCompleted(id);
        return;
      }

      state = {...state, id: current.copyWith(remainingSeconds: next)};

      final userData = ref.read(userDataServiceProvider);
      await userData.sessionRef().doc(id).update({'remainingSeconds': next});
    });
  }

  Future<void> resetSession(StudySchedule schedule) async {
    final userData = ref.read(userDataServiceProvider);

    await userData.sessionRef().doc(schedule.id).set({
      'remainingSeconds': schedule.minutes * 60,
      'isRunning': false,
    });

    await userData.studyScheduleRef().doc(schedule.id).update({
      'isCompleted': false,
    });
  }
}

final studySessionProvider =
    NotifierProvider<StudySessionNotifier, Map<String, Studysession>>(
      StudySessionNotifier.new,
    );
