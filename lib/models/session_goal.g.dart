// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_goal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionGoalAdapter extends TypeAdapter<SessionGoal> {
  @override
  final int typeId = 12;

  @override
  SessionGoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionGoal(
      sessionId: fields[0] as String,
      type: fields[1] as GoalType,
      targetValue: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SessionGoal obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.sessionId)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.targetValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GoalAchievementAdapter extends TypeAdapter<GoalAchievement> {
  @override
  final int typeId = 13;

  @override
  GoalAchievement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoalAchievement(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      type: fields[2] as GoalType,
      targetValue: fields[3] as double,
      actualValue: fields[4] as double,
      sessionId: fields[5] as String,
      cubeType: fields[6] as CubeType,
    );
  }

  @override
  void write(BinaryWriter writer, GoalAchievement obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.targetValue)
      ..writeByte(4)
      ..write(obj.actualValue)
      ..writeByte(5)
      ..write(obj.sessionId)
      ..writeByte(6)
      ..write(obj.cubeType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalAchievementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GoalTypeAdapter extends TypeAdapter<GoalType> {
  @override
  final int typeId = 11;

  @override
  GoalType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GoalType.ao5;
      case 1:
        return GoalType.ao12;
      case 2:
        return GoalType.bestTime;
      case 3:
        return GoalType.solveCount;
      default:
        return GoalType.ao5;
    }
  }

  @override
  void write(BinaryWriter writer, GoalType obj) {
    switch (obj) {
      case GoalType.ao5:
        writer.writeByte(0);
        break;
      case GoalType.ao12:
        writer.writeByte(1);
        break;
      case GoalType.bestTime:
        writer.writeByte(2);
        break;
      case GoalType.solveCount:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
