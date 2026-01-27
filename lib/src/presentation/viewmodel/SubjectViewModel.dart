import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:smart_study/src/data/model/Subject.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';
import 'package:smart_study/src/data/services/user_data_services.dart';
import 'package:smart_study/src/presentation/viewmodel/auth_provide.dart';

class SubjectViewModel extends Notifier<List<Subject>> {
  StreamSubscription? _subscription;

  @override
  List<Subject> build() {
    final auth = ref.watch(authStateProvider);

    auth.whenData((user) {
      _subscription?.cancel();

      if (user == null) {
        state = [];
        return;
      }

      final userData = ref.read(userDataServiceProvider);

      _subscription = userData.subjectRef().snapshots().listen((snapshot) {
        state = snapshot.docs
            .map((doc) => Subject(id: doc.id, name: doc['name']))
            .toList();
      });
    });

    // ✅ initial state ONLY
    ref.onDispose(() {
      _subscription?.cancel();
    });

    return [];
  }

  Future<void> addSubject(Subject subject) async {
    final userData = ref.read(userDataServiceProvider);
    if (subject.name == "") {
      return;
    }
    await userData.subjectRef().doc(subject.id).set({'name': subject.name});
  }

  Future<void> removeSubject(String id) async {
    final userData = ref.read(userDataServiceProvider);

    await userData.subjectRef().doc(id).delete();

    final schedules = await userData
        .studyScheduleRef()
        .where('subjectId', isEqualTo: id)
        .get();

    for (final doc in schedules.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> clearSubjects() async {
    final userData = ref.read(userDataServiceProvider);

    final subjects = await userData.subjectRef().get();
    for (final doc in subjects.docs) {
      await doc.reference.delete();
    }

    final schedules = await userData.studyScheduleRef().get();
    for (final doc in schedules.docs) {
      await doc.reference.delete();
    }

    final sessions = await userData.sessionRef().get();
    for (final doc in sessions.docs) {
      await doc.reference.delete();
    }
  }
}

final subjectViewModelProvider =
    NotifierProvider<SubjectViewModel, List<Subject>>(SubjectViewModel.new);
