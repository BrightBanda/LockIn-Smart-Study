import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';
import 'package:smart_study/src/presentation/viewmodel/selectedDayViewModel.dart';

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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.black : Colors.grey[300],
          foregroundColor: isSelected ? Colors.white : Colors.black,
        ),
        onPressed: () {
          ref.read(selectedDayProvider.notifier).state = buttonDay;
        },
        child: Text(day),
      ),
    );
  }
}
