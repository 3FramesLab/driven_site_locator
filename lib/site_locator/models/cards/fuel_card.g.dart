// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fuel_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FuelCardAdapter extends TypeAdapter<FuelCard> {
  @override
  final int typeId = 101;

  @override
  FuelCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FuelCard(
      id: fields[0] as int?,
      cardNickName: fields[1] as String?,
      cardToken: fields[2] as String?,
      cardLastFourDigit: fields[3] as String?,
      cardProductType: fields[4] as String?,
      accountCode: fields[5] as String?,
      customerId: fields[6] as String?,
      isFavoriteCard: fields[7] as bool?,
      createdDate: fields[8] as int?,
      modifiedDate: fields[9] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, FuelCard obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cardNickName)
      ..writeByte(2)
      ..write(obj.cardToken)
      ..writeByte(3)
      ..write(obj.cardLastFourDigit)
      ..writeByte(4)
      ..write(obj.cardProductType)
      ..writeByte(5)
      ..write(obj.accountCode)
      ..writeByte(6)
      ..write(obj.customerId)
      ..writeByte(7)
      ..write(obj.isFavoriteCard)
      ..writeByte(8)
      ..write(obj.createdDate)
      ..writeByte(9)
      ..write(obj.modifiedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FuelCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
