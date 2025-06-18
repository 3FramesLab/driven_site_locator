// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'structured_formatting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StructuredFormattingAdapter extends TypeAdapter<StructuredFormatting> {
  @override
  final int typeId = 7;

  @override
  StructuredFormatting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StructuredFormatting(
      mainText: fields[0] as String?,
      secondaryText: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StructuredFormatting obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.mainText)
      ..writeByte(1)
      ..write(obj.secondaryText);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StructuredFormattingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
