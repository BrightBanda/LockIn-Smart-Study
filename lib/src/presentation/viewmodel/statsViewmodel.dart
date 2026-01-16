import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/data/model/stats.dart';
import 'package:smart_study/src/presentation/viewmodel/auth_provide.dart';

class Statsviewmodel extends Notifier<AsyncValue<Stats>> {
  StreamSubscription? _subjectSub;
  StreamSubscription? _scheduleSub;

  int totalMinutes = 0;
  int totalSubjects = 0;
  int totalSchedules = 0;

  @override
  AsyncValue<Stats> build() {
    ref.keepAlive();

    final auth = ref.watch(authStateProvider);

    auth.whenData((user) async {
      _cancelSubs();

      if (user == null) {
        state = const AsyncValue.loading();
        return;
      }

      final userData = ref.read(userDataServiceProvider);

      //member since
      final memberSince = user.metadata.creationTime ?? DateTime.now();

      //subjects
      _subjectSub = userData.subjectRef().snapshots().listen((snapshot) {
        totalSubjects = snapshot.size;
        _emit(memberSince);
      });

      //schedules
      _scheduleSub = userData.studyScheduleRef().snapshots().listen((snapshot) {
        totalSchedules = snapshot.size;
        totalMinutes = 0;
        for (final doc in snapshot.docs) {
          totalMinutes += doc['minutes'] as int;
        }
        _emit(memberSince);
      });

      ref.onDispose(() {
        _cancelSubs();
      });
    });
    return const AsyncValue.loading();
  }

  void _emit(DateTime memberSince) {
    state = AsyncValue.data(
      Stats(
        totalStudyMinutes: totalMinutes,
        totalSubjects: totalSubjects,
        totalSchedules: totalSchedules,
        memberSince: memberSince,
      ),
    );
  }

  void _cancelSubs() {
    _subjectSub?.cancel();
    _scheduleSub?.cancel();
  }
}

final statsViewmodelProvider =
    NotifierProvider<Statsviewmodel, AsyncValue<Stats>>(Statsviewmodel.new);
