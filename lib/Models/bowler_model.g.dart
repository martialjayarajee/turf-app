// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bowler_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BowlerModelAdapter extends TypeAdapter<BowlerModel> {
  @override
  final int typeId = 1;

  @override
  BowlerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BowlerModel(
      name: fields[0] as String,
      runs: fields[1] as int,
      wickets: fields[2] as int,
      overs: fields[3] as double,
      economy: fields[4] as double,
      balls: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BowlerModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.runs)
      ..writeByte(2)
      ..write(obj.wickets)
      ..writeByte(3)
      ..write(obj.overs)
      ..writeByte(4)
      ..write(obj.economy)
      ..writeByte(5)
      ..write(obj.balls);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BowlerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
