import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:smart_study/src/data/model/Subject.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';

class Subjectviewmodel extends Notifier<List<Subject>> {
  final _box = Hive.box<Subject>('subjects');
  @override
  List<Subject> build() {
    // Initial list of subjects
    return _box.values.toList();
  }

  void addSubject(Subject subject) {
    _box.put(subject.id, subject);
    state = _box.values.toList();
  }

  void removeSubject(String id) {
    _box.delete(id);

    final scheduleBox = Hive.box<StudySchedule>('schedules');
    final toDelete = scheduleBox.values
        .where((s) => s.subjectId == id)
        .map((s) => s.id)
        .toList();

    for (final sid in toDelete) {
      scheduleBox.delete(sid);
    }

    state = _box.values.toList();
  }

  void clearSubjects() {
    _box.clear();
    state = [];
  }

  void markAsCompleted(String id) {
    state = state
        .map(
          (subject) => subject.id == id
              ? Subject(
                  id: subject.id,
                  name: subject.name,
                  //time: subject.time,
                  //isCompleted: true,
                )
              : subject,
        )
        .toList();
  }
}

final subjectViewModelProvider =
    NotifierProvider<Subjectviewmodel, List<Subject>>(() {
      return Subjectviewmodel();
    });
