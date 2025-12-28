import 'package:hive/hive.dart';
import 'package:smart_study/src/data/model/Subject.dart';
import 'package:smart_study/src/data/model/studySchedule.dart';

class HiveServices {
  static Future<void> clearAllData() async {
    await Hive.box<Subject>('subjects').clear();
    await Hive.box<StudySchedule>('schedules').clear();
  }
}
