// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseTypeAdapter extends TypeAdapter<ExerciseType> {
  @override
  final int typeId = 2;

  @override
  ExerciseType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExerciseType.cross;
      case 1:
        return ExerciseType.f2l;
      case 2:
        return ExerciseType.oll;
      case 3:
        return ExerciseType.pll;
      case 4:
        return ExerciseType.recognition;
      case 5:
        return ExerciseType.lookahead;
      case 6:
        return ExerciseType.beautifulPatterns;
      case 7:
        return ExerciseType.randomCube;
      case 8:
        return ExerciseType.mixed;
      default:
        return ExerciseType.cross;
    }
  }

  @override
  void write(BinaryWriter writer, ExerciseType obj) {
    switch (obj) {
      case ExerciseType.cross:
        writer.writeByte(0);
        break;
      case ExerciseType.f2l:
        writer.writeByte(1);
        break;
      case ExerciseType.oll:
        writer.writeByte(2);
        break;
      case ExerciseType.pll:
        writer.writeByte(3);
        break;
      case ExerciseType.recognition:
        writer.writeByte(4);
        break;
      case ExerciseType.lookahead:
        writer.writeByte(5);
        break;
      case ExerciseType.beautifulPatterns:
        writer.writeByte(6);
        break;
      case ExerciseType.randomCube:
        writer.writeByte(7);
        break;
      case ExerciseType.mixed:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
