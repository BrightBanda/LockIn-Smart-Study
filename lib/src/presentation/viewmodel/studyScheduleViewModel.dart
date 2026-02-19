import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';
import 'package:smart_study/src/data/services/user_data_services.dart';
import 'package:smart_study/src/presentation/viewmodel/auth_provide.dart';
import 'package:smart_study/src/utils/helpers/date_helper.dart';

class StudyScheduleViewModel extends Notifier<List<StudySchedule>> {
  StreamSubscription? _subscription;

  @override
  List<StudySchedule> build() {
    final authAsync = ref.watch(authStateProvider);

    authAsync.whenData((user) {
      // Cancel previous subscription if any
      _subscription?.cancel();

      if (user == null) {
        state = [];
        return;
      }

      final userData = ref.read(userDataServiceProvider);

      // Listen to Firestore schedules for this user
      _subscription = userData.studyScheduleRef().snapshots().listen((
        snapshot,
      ) {
        state = snapshot.docs.map((doc) {
          return StudySchedule(
            id: doc.id,
            subjectId: doc['subjectId'],
            day: WeekDay.values[doc['day']],
            minutes: doc['minutes'],
            isCompleted: doc['isCompleted'],
          );
        }).toList();
      });
    });

    // Initial empty state
    return [];
  }

  @override
  void dispose() {
    _subscription?.cancel();
  }

  Future<void> addSchedule(StudySchedule schedule) async {
    final userData = ref.read(userDataServiceProvider);

    await userData.studyScheduleRef().doc(schedule.id).set({
      'subjectId': schedule.subjectId,
      'day': schedule.day.index,
      'minutes': schedule.minutes,
      'isCompleted': false,
    });
  }

  Future<void> removeSchedule(String id) async {
    final userData = ref.read(userDataServiceProvider);
    await userData.studyScheduleRef().doc(id).delete();
  }

  Future<void> clearSchedules() async {
    final userData = ref.read(userDataServiceProvider);

    final schedules = await userData.studyScheduleRef().get();
    for (final doc in schedules.docs) {
      await doc.reference.delete();
    }

    final sessions = await userData.sessionRef().get();
    for (final doc in sessions.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> markCompleted(String id) async {
    final userData = ref.read(userDataServiceProvider);

    await userData.studyScheduleRef().doc(id).update({'isCompleted': true});

    final completedSchedule = state.firstWhere((s) => s.id == id);
    final day = completedSchedule.day;

    final dayCompleted = areAllSchedulesCompletedForDay(day);

    if (dayCompleted) {
      final docId = dayCompletionId(day);
      final weekId = currentWeekId();

      await userData.dayRef().doc(dayCompletionId(day)).set({
        'day': day.index,
        'isCompleted': true,
        'weekId': currentWeekId(),
        'completedAt': DateTime.now(),
      });
      final savedDoc = await userData.dayRef().doc(docId).get();
      if (savedDoc.exists) {
        print('✅ Document saved successfully: ${savedDoc.data()}');
      } else {
        print('❌ Document was NOT saved!');
      }

      // 🔍 Check all documents for current week
      final weekDocs = await userData
          .dayRef()
          .where('weekId', isEqualTo: weekId)
          .get();
      print('📊 Documents for week $weekId: ${weekDocs.docs.length}');
      for (final doc in weekDocs.docs) {
        print('   - ${doc.id}: ${doc.data()}');
      }
    }

    final allCompleted = state.isNotEmpty && state.every((s) => s.isCompleted);

    if (allCompleted) {
      await userData.weekRef().doc(currentWeekId()).set({
        'isCompleted': true,
        'completedAt': DateTime.now(),
      });
    }
  }

  bool areAllSchedulesCompletedForDay(WeekDay day) {
    final schedulesForDay = state
        .where((schedule) => schedule.day == day)
        .toList();
    if (schedulesForDay.isEmpty) return false;
    return schedulesForDay.every((schedule) => schedule.isCompleted);
  }
}

final studyScheduleProvider =
    NotifierProvider<StudyScheduleViewModel, List<StudySchedule>>(
      StudyScheduleViewModel.new,
    );
