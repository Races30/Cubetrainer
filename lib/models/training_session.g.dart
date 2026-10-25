// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrainingSessionAdapter extends TypeAdapter<TrainingSession> {
  @override
  final int typeId = 4;

  @override
  TrainingSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrainingSession(
      sessionId: fields[0] as String,
      type: fields[1] as ExerciseType,
      date: fields[2] as DateTime,
      totalSolves: fields[3] as int,
      successPercentage: fields[4] as double,
      metadata: (fields[5] as Map).cast<String, String>(),
      targetMs: fields[6] as int,
      evaluationMode: fields[7] as EvaluationMode,
    );
  }

  @override
  void write(BinaryWriter writer, TrainingSession obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.sessionId)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.totalSolves)
      ..writeByte(4)
      ..write(obj.successPercentage)
      ..writeByte(5)
      ..write(obj.metadata)
      ..writeByte(6)
      ..write(obj.targetMs)
      ..writeByte(7)
      ..write(obj.evaluationMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrainingSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EvaluationModeAdapter extends TypeAdapter<EvaluationMode> {
  @override
  final int typeId = 5;

  @override
  EvaluationMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EvaluationMode.avg;
      case 1:
        return EvaluationMode.best;
      default:
        return EvaluationMode.avg;
    }
  }

  @override
  void write(BinaryWriter writer, EvaluationMode obj) {
    switch (obj) {
      case EvaluationMode.avg:
        writer.writeByte(0);
        break;
      case EvaluationMode.best:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EvaluationModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
