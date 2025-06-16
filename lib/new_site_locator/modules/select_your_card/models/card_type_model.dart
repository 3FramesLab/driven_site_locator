// ignore_for_file: must_be_immutable

part of select_your_card_module;

class CardTypeModel extends Equatable {
  String key;
  String title;
  String subtitle;
  FuelType fuelType;
  List<String> cards;

  CardTypeModel({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.cards,
    this.fuelType = FuelType.diesel,
  });

  @override
  List<Object?> get props => [key, title, subtitle];
}
