import 'package:hive/hive.dart';

part 'Subject.g.dart';

@HiveType(typeId: 0)
class Subject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  Subject({required this.id, required this.name});
}
