part of map_view_module;

class CardTypeMapping {
  final String merchSiteKey;
  final List<String> cardholderKeys;
  final List<String> adminKeys;
  final List<String> guestKeys;
  final FuelType fuelType;

  CardTypeMapping({
    required this.merchSiteKey,
    required this.cardholderKeys,
    required this.adminKeys,
    required this.guestKeys,
    required this.fuelType,
  });

  factory CardTypeMapping.fromJson(Map<String, dynamic> json) {
    return CardTypeMapping(
        merchSiteKey: json['merchSiteKey'] ?? '',
        cardholderKeys: _getList(json['cardholderKeys']),
        adminKeys: _getList(json['adminKeys']),
        guestKeys: _getList(json['guestKeys']),
        fuelType: _getFuelType(json['fuelType']));
  }

  static FuelType _getFuelType(dynamic value) {
    return value != null
        ? fuelTypeValues.map[value.toString()] ?? FuelType.diesel
        : FuelType.diesel;
  }

  static List<String> _getList(dynamic value) {
    return value != null
        ? (value as List).map((e) => e.toString()).toList()
        : [];
  }
}

enum FuelType {
  diesel('Diesel'),
  gas('Gas'),
  cng('CNG');

  const FuelType(this.value);
  final String value;
}

final fuelTypeValues = EnumValues({
  'Diesel': FuelType.diesel,
  'Gas': FuelType.gas,
  'CNG': FuelType.cng,
});
