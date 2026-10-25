// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oll_pll_solve.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OllPllSolveAdapter extends TypeAdapter<OllPllSolve> {
  @override
  final int typeId = 9;

  @override
  OllPllSolve read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OllPllSolve(
      caseId: fields[0] as String,
      timeMs: fields[1] as int,
      date: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, OllPllSolve obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.caseId)
      ..writeByte(1)
      ..write(obj.timeMs)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OllPllSolveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
