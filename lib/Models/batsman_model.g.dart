// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batsman_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BatsmanModelAdapter extends TypeAdapter<BatsmanModel> {
  @override
  final int typeId = 0;

  @override
  BatsmanModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BatsmanModel(
      name: fields[0] as String,
      runs: fields[1] as int,
      balls: fields[2] as int,
      fours: fields[3] as int,
      sixes: fields[4] as int,
      strikeRate: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BatsmanModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.runs)
      ..writeByte(2)
      ..write(obj.balls)
      ..writeByte(3)
      ..write(obj.fours)
      ..writeByte(4)
      ..write(obj.sixes)
      ..writeByte(5)
      ..write(obj.strikeRate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BatsmanModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
