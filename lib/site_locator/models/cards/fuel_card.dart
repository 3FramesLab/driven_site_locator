import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:hive/hive.dart';

part 'fuel_card.g.dart';

@HiveType(typeId: SiteLocatorConstants.fuelCardTypeId)
class FuelCard {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? cardNickName;
  @HiveField(2)
  final String? cardToken;
  @HiveField(3)
  final String? cardLastFourDigit;
  @HiveField(4)
  final String? cardProductType;
  @HiveField(5)
  final String? accountCode;
  @HiveField(6)
  final String? customerId;
  @HiveField(7)
  bool? isFavoriteCard;
  @HiveField(8)
  int? createdDate;
  @HiveField(9)
  int? modifiedDate;

  FuelCard({
    this.id,
    this.cardNickName,
    this.cardToken,
    this.cardLastFourDigit,
    this.cardProductType,
    this.accountCode,
    this.customerId,
    this.isFavoriteCard,
    this.createdDate,
    this.modifiedDate,
  });
}
