// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studySchedule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudyScheduleAdapter extends TypeAdapter<StudySchedule> {
  @override
  final int typeId = 1;

  @override
  StudySchedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudySchedule(
      id: fields[0] as String,
      subjectId: fields[1] as String,
      day: fields[2] as WeekDay,
      minutes: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StudySchedule obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.subjectId)
      ..writeByte(2)
      ..write(obj.day)
      ..writeByte(3)
      ..write(obj.minutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WeekDayAdapter extends TypeAdapter<WeekDay> {
  @override
  final int typeId = 2;

  @override
  WeekDay read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WeekDay.mon;
      case 1:
        return WeekDay.tue;
      case 2:
        return WeekDay.wed;
      case 3:
        return WeekDay.thu;
      case 4:
        return WeekDay.fri;
      case 5:
        return WeekDay.sat;
      case 6:
        return WeekDay.sun;
      default:
        return WeekDay.mon;
    }
  }

  @override
  void write(BinaryWriter writer, WeekDay obj) {
    switch (obj) {
      case WeekDay.mon:
        writer.writeByte(0);
        break;
      case WeekDay.tue:
        writer.writeByte(1);
        break;
      case WeekDay.wed:
        writer.writeByte(2);
        break;
      case WeekDay.thu:
        writer.writeByte(3);
        break;
      case WeekDay.fri:
        writer.writeByte(4);
        break;
      case WeekDay.sat:
        writer.writeByte(5);
        break;
      case WeekDay.sun:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeekDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
