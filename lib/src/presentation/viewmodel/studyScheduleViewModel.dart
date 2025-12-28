import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';

class Studyscheduleviewmodel extends Notifier<List<StudySchedule>> {
  final _box = Hive.box<StudySchedule>('schedules');
  @override
  List<StudySchedule> build() {
    return _box.values.toList();
  }

  void addSchedule(StudySchedule schedule) {
    _box.put(schedule.id, schedule);
    state = _box.values.toList();
  }

  void removeSchedule(String scheduleId) {
    //state = state.where((s) => s.id != scheduleId).toList();
    _box.delete(scheduleId);
    state = _box.values.toList();
  }

  void clearData() {
    _box.clear();
    state = [];
  }
}

final studyScheduleProvider =
    NotifierProvider<Studyscheduleviewmodel, List<StudySchedule>>(
      Studyscheduleviewmodel.new,
    );
