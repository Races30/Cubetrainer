// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scramble_history_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScrambleHistoryItemAdapter extends TypeAdapter<ScrambleHistoryItem> {
  @override
  final int typeId = 3;

  @override
  ScrambleHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScrambleHistoryItem(
      scramble: fields[0] as String,
      cubeType: fields[1] as CubeType,
      date: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ScrambleHistoryItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.scramble)
      ..writeByte(1)
      ..write(obj.cubeType)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScrambleHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
