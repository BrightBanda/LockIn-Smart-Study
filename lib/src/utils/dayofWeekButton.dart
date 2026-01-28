import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';
import 'package:smart_study/src/presentation/viewmodel/dayCompletionViewmodel.dart';
import 'package:smart_study/src/presentation/viewmodel/selectedDayViewModel.dart';
import 'package:smart_study/src/utils/helpers/app_colors.dart';

class Dayofweekbutton extends ConsumerWidget {
  final String day;

  const Dayofweekbutton({super.key, required this.day});

  WeekDay _toWeekDay(String day) {
    switch (day) {
      case 'Mon':
        return WeekDay.mon;
      case 'Tue':
        return WeekDay.tue;
      case 'Wed':
        return WeekDay.wed;
      case 'Thu':
        return WeekDay.thu;
      case 'Fri':
        return WeekDay.fri;
      case 'Sat':
        return WeekDay.sat;
      case 'Sun':
        return WeekDay.sun;
      default:
        return WeekDay.mon;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final buttonDay = _toWeekDay(day);

    final isSelected = selectedDay == buttonDay;

    final completedDays = ref
        .watch(completedDaysProvider)
        .maybeWhen(data: (d) => d, orElse: () => <WeekDay>{});

    final isCompleted = completedDays.contains(buttonDay);
    final appColors = Theme.of(context).extension<AppColors>()!;

    Color backgroundColor;
    Color foregroundColor;

    if (isSelected && isCompleted) {
      backgroundColor = appColors.surface;
      foregroundColor = Colors.greenAccent;
    } else if (isSelected) {
      backgroundColor = appColors.card;
      foregroundColor = appColors.textPrimary;
    } else if (isCompleted) {
      backgroundColor = Colors.green;
      foregroundColor = Colors.white;
    } else {
      backgroundColor = Colors.grey[300]!;
      foregroundColor = Colors.black;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 2,
        ),
        onPressed: () {
          ref.read(selectedDayProvider.notifier).state = buttonDay;
        },
        child: Text(day),
      ),
    );
  }
}
