// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'studySession.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudysessionAdapter extends TypeAdapter<Studysession> {
  @override
  final int typeId = 3;

  @override
  Studysession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Studysession(
      remainingSeconds: fields[0] as int,
      isRunning: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Studysession obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.remainingSeconds)
      ..writeByte(1)
      ..write(obj.isRunning);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudysessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
