import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/presentation/viewmodel/completedDayNotifier.dart';
import 'package:smart_study/src/presentation/viewmodel/streakViewmodel.dart';
import 'package:smart_study/src/presentation/viewmodel/studySessionViewmodel.dart';

class ResetButton extends ConsumerWidget {
  const ResetButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.restart_alt, color: Colors.red),
      tooltip: 'Reset Progress',
      onPressed: () async {
        final completedDaysNotifier = ref.read(
          completedDaysProviderNot.notifier,
        );
        final streakNotifier = ref.read(streakProvider.notifier);
        final studySessionNotifier = ref.read(studySessionProvider.notifier);
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Reset all progress?'),
            content: const Text(
              'This will reset completed days and streak.\nThis action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Reset', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );

        if (confirmed != true) return;

        // Reset completed days and streak
        completedDaysNotifier.resetCompletedDays();
        streakNotifier.resetStreak();
        //studySessionNotifier.resetAllSessions();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Progress reset')));
      },
    );
  }
}
