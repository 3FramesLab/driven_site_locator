// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'predictions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PredictionsAdapter extends TypeAdapter<Predictions> {
  @override
  final int typeId = 6;

  @override
  Predictions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Predictions(
      description: fields[0] as String?,
      placeId: fields[1] as String?,
      reference: fields[2] as String?,
      structuredFormatting: fields[3] as StructuredFormatting?,
    )..modifiedOn = fields[4] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, Predictions obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.description)
      ..writeByte(1)
      ..write(obj.placeId)
      ..writeByte(2)
      ..write(obj.reference)
      ..writeByte(3)
      ..write(obj.structuredFormatting)
      ..writeByte(4)
      ..write(obj.modifiedOn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PredictionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
