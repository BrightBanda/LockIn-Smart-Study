import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/data/model/streak.dart';
import 'package:smart_study/src/presentation/viewmodel/auth_provide.dart';
import 'package:smart_study/src/utils/helpers/date_helper.dart';

class StreakNotifier extends Notifier<AsyncValue<Streak>> {
  @override
  AsyncValue<Streak> build() {
    ref.keepAlive();

    final auth = ref.watch(authStateProvider);

    auth.whenData((user) async {
      if (user == null) {
        state = AsyncValue.data(Streak(current: 0, lastCompletedDay: ''));
        return;
      }

      final doc = await ref.read(userDataServiceProvider).streakRef().get();

      if (!doc.exists) {
        state = AsyncValue.data(Streak(current: 0, lastCompletedDay: ''));
        return;
      }

      state = AsyncValue.data(Streak.fromMap(doc.data()!));
    });

    return const AsyncValue.loading();
  }

  Future<void> onDayCompleted() async {
    final currentStreak =
        state.value ?? Streak(current: 0, lastCompletedDay: '');

    final today = todayId();
    final yesterday = yesterdayId();

    int newStreak = 1;

    if (currentStreak.lastCompletedDay == today) {
      return; // already counted today
    }

    if (currentStreak.lastCompletedDay == yesterday) {
      newStreak = currentStreak.current + 1;
    }

    final updated = Streak(current: newStreak, lastCompletedDay: today);

    state = AsyncValue.data(updated);

    await ref.read(userDataServiceProvider).streakRef().set(updated.toMap());
  }

  Future<void> resetStreak() async {
    final reset = Streak(current: 0, lastCompletedDay: '');

    state = AsyncValue.data(reset);

    await ref.read(userDataServiceProvider).streakRef().set(reset.toMap());
  }
}

final streakProvider = NotifierProvider<StreakNotifier, AsyncValue<Streak>>(
  StreakNotifier.new,
);
