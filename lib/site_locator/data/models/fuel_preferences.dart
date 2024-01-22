import 'package:driven_common/data/data_sources/remote/decodable.dart';
import 'package:driven_site_locator/site_locator/data/models/enum_values.dart';

class FuelPreferences extends Decodable<List<FuelPreferences>> {
  String? customerId;
  FuelPreferenceType? fuelPreferenceType;
  String? enableWhileInMotion;

  FuelPreferences({
    this.customerId,
    this.enableWhileInMotion,
    this.fuelPreferenceType = FuelPreferenceType.both,
  });

  FuelPreferences.fromJson(Map<String, dynamic> json) {
    fuelPreferenceType = _getFuelPreferenceType(json);
    enableWhileInMotion = json['enableWhileInMotion'];
  }

  FuelPreferenceType? _getFuelPreferenceType(Map<String, dynamic> json) {
    return json['displayPrices'] != null
        ? fuelPreferenceValues
            .map[json['displayPrices'].toString().toLowerCase()]
        : FuelPreferenceType.both;
  }

  @override
  List<FuelPreferences> decode(dynamic data) {
    final fuelPreferencesList = <FuelPreferences>[];
    if (data.isNotEmpty) {
      for (final key in data.keys) {
        final fuelPreference = FuelPreferences.fromJson(data[key]);
        fuelPreference.customerId = key.toString().toLowerCase();
        fuelPreferencesList.add(fuelPreference);
      }
    }
    return fuelPreferencesList;
  }
}

enum FuelPreferenceType {
  retail('retail'),
  net('net'),
  both('both');

  const FuelPreferenceType(this.value);
  final String value;
}

final fuelPreferenceValues = EnumValues({
  'retail': FuelPreferenceType.retail,
  'net': FuelPreferenceType.net,
  'both': FuelPreferenceType.both,
});
