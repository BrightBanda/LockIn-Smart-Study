import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';
import 'package:smart_study/src/presentation/viewmodel/auth_provide.dart';
import 'package:smart_study/src/presentation/viewmodel/streakViewmodel.dart';
import 'package:smart_study/src/utils/helpers/date_helper.dart';

final completedDaysProvider = StreamProvider<Set<WeekDay>>((ref) {
  final userData = ref.read(userDataServiceProvider);

  return userData.dayRef().snapshots().map((snapshot) {
    print('🔥 Snapshot received with ${snapshot.docs.length} docs'); // Debug

    final completed = <WeekDay>{};

    for (final doc in snapshot.docs) {
      final weekId = doc['weekId'] as String?;
      final isCompleted = doc['isCompleted'] == true;
      final day = doc['day'];

      if (isCompleted && weekId == currentWeekId()) {
        if (day != null &&
            day is int &&
            day >= 0 &&
            day < WeekDay.values.length) {
          completed.add(WeekDay.values[day]);
          ref.read(streakProvider.notifier).onDayCompleted();
        }
      }
    }
    return completed;
  });
});
