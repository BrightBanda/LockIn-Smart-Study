import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';
import 'package:smart_study/src/presentation/viewmodel/auth_provide.dart';

class StudyScheduleViewModel extends Notifier<List<StudySchedule>> {
  @override
  List<StudySchedule> build() {
    _listen();
    return [];
  }

  void _listen() {
    final userData = ref.read(userDataServiceProvider);

    userData.studyScheduleRef().snapshots().listen((snapshot) {
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
  }
}

final studyScheduleProvider =
    NotifierProvider<StudyScheduleViewModel, List<StudySchedule>>(
      StudyScheduleViewModel.new,
    );
