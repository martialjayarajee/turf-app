// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScoreModelAdapter extends TypeAdapter<ScoreModel> {
  @override
  final int typeId = 2;

  @override
  ScoreModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScoreModel(
      totalRuns: fields[0] as int,
      wickets: fields[1] as int,
      currentBall: fields[2] as int,
      overs: fields[3] as double,
      crr: fields[4] as double,
      nrr: fields[5] as double,
      strikeBatsmanIndex: fields[6] as int,
      currentBowlerIndex: fields[7] as int,
      currentOver: (fields[8] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ScoreModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.totalRuns)
      ..writeByte(1)
      ..write(obj.wickets)
      ..writeByte(2)
      ..write(obj.currentBall)
      ..writeByte(3)
      ..write(obj.overs)
      ..writeByte(4)
      ..write(obj.crr)
      ..writeByte(5)
      ..write(obj.nrr)
      ..writeByte(6)
      ..write(obj.strikeBatsmanIndex)
      ..writeByte(7)
      ..write(obj.currentBowlerIndex)
      ..writeByte(8)
      ..write(obj.currentOver);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoreModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
