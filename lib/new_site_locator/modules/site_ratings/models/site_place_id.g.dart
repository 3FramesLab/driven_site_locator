// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_place_id.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SitePlaceIdAdapter extends TypeAdapter<SitePlaceId> {
  @override
  final int typeId = 8;

  @override
  SitePlaceId read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SitePlaceId(
      masterIdentifier: fields[0] as String,
      placeId: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SitePlaceId obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.masterIdentifier)
      ..writeByte(1)
      ..write(obj.placeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SitePlaceIdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
