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
    _box.delete(scheduleId);
    state = _box.values.toList();
  }

  void clearSchedules() {
    _box.clear();
    state = [];
  }

  void markCompleted(String scheduleId) {
    state = state.map((s) {
      if (s.id == scheduleId) {
        final updated = s.copyWith(isCompleted: true);
        Hive.box<StudySchedule>('schedules').put(scheduleId, updated);
        return updated;
      }
      return s;
    }).toList();
  }
}

final studyScheduleProvider =
    NotifierProvider<Studyscheduleviewmodel, List<StudySchedule>>(
      Studyscheduleviewmodel.new,
    );
