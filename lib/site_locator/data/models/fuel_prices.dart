import 'package:driven_common/data/data_sources/remote/decodable.dart';

class FuelPrices extends Decodable<List<FuelPrices>> {
  String? locationId;
  String? dieselRetail;
  String? dieselNet;
  String? asOfDate;

  FuelPrices({
    this.locationId,
    this.dieselRetail,
    this.dieselNet,
    this.asOfDate,
  });

  FuelPrices.fromJson(Map<String, dynamic> json) {
    locationId = json['locationId'];
    dieselRetail = json['dieselRetail'];
    dieselNet = json['dieselNet'];
    asOfDate = json['asOfDate'];
  }

  @override
  List<FuelPrices> decode(dynamic data) {
    final siteList = <FuelPrices>[];
    if (data.isNotEmpty) {
      for (final element in data['fuelPrices']) {
        siteList.add(FuelPrices.fromJson(element));
      }
    }
    return siteList;
  }
}
