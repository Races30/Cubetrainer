// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_solve.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrainingSolveAdapter extends TypeAdapter<TrainingSolve> {
  @override
  final int typeId = 8;

  @override
  TrainingSolve read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrainingSolve(
      id: fields[0] as String,
      cube: fields[1] as String,
      scramble: fields[2] as String,
      totalTimeMs: fields[3] as int,
      phaseTimes: (fields[4] as Map).cast<String, int>(),
      movesCount: (fields[5] as Map?)?.cast<String, int>(),
      penalty: fields[6] as String,
      tags: (fields[7] as List).cast<String>(),
      sessionId: fields[8] as String,
      sessionType: fields[9] as ExerciseType,
      date: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TrainingSolve obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cube)
      ..writeByte(2)
      ..write(obj.scramble)
      ..writeByte(3)
      ..write(obj.totalTimeMs)
      ..writeByte(4)
      ..write(obj.phaseTimes)
      ..writeByte(5)
      ..write(obj.movesCount)
      ..writeByte(6)
      ..write(obj.penalty)
      ..writeByte(7)
      ..write(obj.tags)
      ..writeByte(8)
      ..write(obj.sessionId)
      ..writeByte(9)
      ..write(obj.sessionType)
      ..writeByte(10)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrainingSolveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
