import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/presentation/viewmodel/SubjectViewModel.dart';
import 'package:smart_study/src/presentation/viewmodel/studyScheduleViewModel.dart';

class ClearDataDialog extends ConsumerWidget {
  const ClearDataDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.delete_forever, color: Colors.red),
      title: const Text('Clear all data', style: TextStyle(color: Colors.red)),
      onTap: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Clear all data?'),
            content: const Text(
              'This will permanently delete all subjects and schedules.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          ref.read(subjectViewModelProvider.notifier).clearSubjects();
          ref.read(studyScheduleProvider.notifier).clearSchedules();
        }
      },
    );
  }
}
