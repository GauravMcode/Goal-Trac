// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      fields[6] as int,
      fields[0] as String,
      fields[1] as String,
      fields[5] as String,
      fields[4] as String?,
      (fields[2] as List?)?.cast<String>(),
      (fields[3] as List?)?.cast<DateTime>(),
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.taskName)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.dailyTimeRange)
      ..writeByte(3)
      ..write(obj.dateTimeRange)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.notifyChoice)
      ..writeByte(6)
      ..write(obj.taskID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TaskAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
