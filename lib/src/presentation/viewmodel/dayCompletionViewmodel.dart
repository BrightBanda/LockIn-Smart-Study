import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';
import 'package:smart_study/src/presentation/viewmodel/auth_provide.dart';
import 'package:smart_study/src/presentation/viewmodel/streakViewmodel.dart';
import 'package:smart_study/src/utils/helpers/date_helper.dart';

final completedDaysProvider = StreamProvider<Set<WeekDay>>((ref) {
  final userData = ref.read(userDataServiceProvider);

  return userData.dayRef().snapshots().map((snapshot) {
    final completed = <WeekDay>{};

    for (final doc in snapshot.docs) {
      final weekId = doc['weekId'] as String?;
      if (doc['isCompleted'] == true && weekId == currentWeekId()) {
        completed.add(WeekDay.values[doc['day']]);
        ref.read(streakProvider.notifier).onDayCompleted();
      }
    }
    return completed;
  });
});
