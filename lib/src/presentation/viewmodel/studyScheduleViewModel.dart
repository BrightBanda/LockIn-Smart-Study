import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';

class Studyscheduleviewmodel extends Notifier<List<StudySchedule>> {
  @override
  List<StudySchedule> build() {
    return [];
  }

  void addSchedule(StudySchedule schedule) {
    state = [...state, schedule];
  }

  void removeSchedule(String scheduleId) {
    state = state.where((s) => s.id != scheduleId).toList();
  }
}

final studyScheduleProvider =
    NotifierProvider<Studyscheduleviewmodel, List<StudySchedule>>(
      Studyscheduleviewmodel.new,
    );
