import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';
import 'package:smart_study/src/data/services/user_data_services.dart';
import 'package:smart_study/src/presentation/viewmodel/auth_provide.dart';
import 'package:smart_study/src/utils/helpers/date_helper.dart';

class CompletedDaysNotifier extends StateNotifier<Set<WeekDay>> {
  CompletedDaysNotifier(this._userData) : super({}) {
    _init();
  }

  final UserDataServices _userData;

  void _init() {
    // Listen to Firestore updates
    _userData.dayRef().snapshots().listen((snapshot) {
      final completed = <WeekDay>{};
      for (final doc in snapshot.docs) {
        final weekId = doc['weekId'] as String?;
        if (doc['isCompleted'] == true && weekId == currentWeekId()) {
          completed.add(WeekDay.values[doc['day']]);
        }
      }
      state = completed;
    });
  }

  Future<void> resetCompletedDays() async {
    final snapshot = await _userData
        .dayRef()
        .where('weekId', isEqualTo: currentWeekId())
        .get();

    for (final doc in snapshot.docs) {
      await doc.reference.update({'isCompleted': false});
    }

    state = {}; // update local state
  }
}

// Provider
final completedDaysProviderNot =
    StateNotifierProvider<CompletedDaysNotifier, Set<WeekDay>>((ref) {
      final userData = ref.read(userDataServiceProvider);
      return CompletedDaysNotifier(userData);
    });
