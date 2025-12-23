import 'package:flutter_riverpod/legacy.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';

final selectedDayProvider = StateProvider.autoDispose<WeekDay>((ref) {
  return WeekDay.mon;
});
