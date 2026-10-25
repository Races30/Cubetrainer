// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solve.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SolveAdapter extends TypeAdapter<Solve> {
  @override
  final int typeId = 0;

  @override
  Solve read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Solve(
      id: fields[0] as String,
      cube: fields[1] as String,
      scramble: fields[2] as String,
      timeMs: fields[3] as int,
      penalty: fields[4] as String,
      date: fields[5] as DateTime,
      cubeType: fields[6] as CubeType?,
      sessionId: fields[7] == null ? 'main' : fields[7] as String,
      splits: (fields[8] as Map?)?.cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Solve obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cube)
      ..writeByte(2)
      ..write(obj.scramble)
      ..writeByte(3)
      ..write(obj.timeMs)
      ..writeByte(4)
      ..write(obj.penalty)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.cubeType)
      ..writeByte(7)
      ..write(obj.sessionId)
      ..writeByte(8)
      ..write(obj.splits);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SolveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CubeTypeAdapter extends TypeAdapter<CubeType> {
  @override
  final int typeId = 1;

  @override
  CubeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CubeType.threeByThree;
      case 1:
        return CubeType.twoByTwo;
      case 2:
        return CubeType.fourByFour;
      case 3:
        return CubeType.fiveByFive;
      case 4:
        return CubeType.sixBySix;
      case 5:
        return CubeType.sevenBySeven;
      case 6:
        return CubeType.megaminx;
      case 7:
        return CubeType.pyraminx;
      default:
        return CubeType.threeByThree;
    }
  }

  @override
  void write(BinaryWriter writer, CubeType obj) {
    switch (obj) {
      case CubeType.threeByThree:
        writer.writeByte(0);
        break;
      case CubeType.twoByTwo:
        writer.writeByte(1);
        break;
      case CubeType.fourByFour:
        writer.writeByte(2);
        break;
      case CubeType.fiveByFive:
        writer.writeByte(3);
        break;
      case CubeType.sixBySix:
        writer.writeByte(4);
        break;
      case CubeType.sevenBySeven:
        writer.writeByte(5);
        break;
      case CubeType.megaminx:
        writer.writeByte(6);
        break;
      case CubeType.pyraminx:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CubeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
