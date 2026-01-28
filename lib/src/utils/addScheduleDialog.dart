import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:smart_study/src/data/model/Subject.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';
import 'package:smart_study/src/presentation/viewmodel/SubjectViewModel.dart';
import 'package:smart_study/src/utils/helpers/app_colors.dart';

class AddScheduleDialog extends ConsumerStatefulWidget {
  const AddScheduleDialog({super.key});

  @override
  ConsumerState<AddScheduleDialog> createState() => _AddScheduleDialogState();
}

class _AddScheduleDialogState extends ConsumerState<AddScheduleDialog> {
  WeekDay selectedDay = WeekDay.mon;
  String? selectedSubjectId;
  String hoursStr = '';
  String minutesStr = '';

  @override
  Widget build(BuildContext context) {
    final subjects = ref.watch(subjectViewModelProvider);

    final appColors = Theme.of(context).extension<AppColors>()!;

    return AlertDialog(
      backgroundColor: appColors.card,
      title: Text(
        'Add Schedule',
        style: TextStyle(color: appColors.textPrimary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              DropdownButton<WeekDay>(
                value: selectedDay,
                items: WeekDay.values
                    .map(
                      (day) => DropdownMenuItem(
                        value: day,
                        child: Text(
                          day.name.toUpperCase(),
                          style: TextStyle(color: appColors.textPrimary),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedDay = value);
                  }
                },
              ),

              const SizedBox(width: 12),

              DropdownButton<String>(
                hint: Text(
                  'Select Subject',
                  style: TextStyle(color: appColors.textSecondary),
                ),
                value: selectedSubjectId,
                items: subjects
                    .map(
                      (s) => DropdownMenuItem(
                        value: s.id,
                        child: Text(
                          s.name,
                          style: TextStyle(color: appColors.textSecondary),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedSubjectId = value);
                },
              ),
            ],
          ),

          Row(
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(color: appColors.textPrimary),
                  decoration: InputDecoration(labelText: 'Hours'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => hoursStr = v,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  style: TextStyle(color: appColors.textPrimary),
                  decoration: const InputDecoration(labelText: 'Minutes'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => minutesStr = v,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            if (selectedSubjectId == null) return;

            final hours = int.tryParse(hoursStr) ?? 0;
            final minutes = (int.tryParse(minutesStr) ?? 0).clamp(0, 59);

            Navigator.pop(
              context,
              StudySchedule(
                id: DateTime.now().toIso8601String(),
                subjectId: selectedSubjectId!,
                day: selectedDay,
                minutes: (hours * 60) + minutes,
              ),
            );
          },
          child: const Text('ADD'),
        ),
      ],
    );
  }
}
