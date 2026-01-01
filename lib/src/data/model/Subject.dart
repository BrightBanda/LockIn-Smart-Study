import 'package:hive/hive.dart';

part 'Subject.g.dart';

@HiveType(typeId: 0)
class Subject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  Subject({required this.id, required this.name});

  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  factory Subject.fromMap(Map<String, dynamic> map) =>
      Subject(id: map['id'], name: map['name']);
}
