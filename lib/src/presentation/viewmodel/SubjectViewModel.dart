import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/data/model/Subject.dart';

class Subjectviewmodel extends Notifier<List<Subject>> {
  @override
  List<Subject> build() {
    // Initial list of subjects
    return [
      Subject(id: '1', name: 'Mathematics', time: 40, isCompleted: false),
      Subject(id: '2', name: 'Physics', time: 35, isCompleted: true),
      Subject(id: '3', name: 'Chemistry', time: 30, isCompleted: false),
    ];
  }

  void addSubject(Subject subject) {
    state = [...state, subject];
  }

  void removeSubject(String id) {
    state = state.where((subject) => subject.id != id).toList();
  }

  void markAsCompleted(String id) {
    state = state
        .map(
          (subject) => subject.id == id
              ? Subject(
                  id: subject.id,
                  name: subject.name,
                  time: subject.time,
                  isCompleted: true,
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
