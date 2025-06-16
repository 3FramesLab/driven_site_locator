part of map_view_module;

class FuelPrices extends Decodable<List<FuelPrices>> {
  String? locationId;
  String? dieselRetail;
  String? dieselNet;
  String? asOfDate;

  // unleaded
  String? gasRetail;
  String? gasNet;
  String? gasAsOfDate;

  FuelPrices({
    this.locationId,
    this.dieselRetail,
    this.dieselNet,
    this.asOfDate,
    this.gasRetail,
    this.gasNet,
    this.gasAsOfDate,
  });

  FuelPrices.fromJson(Map<String, dynamic> json) {
    locationId = json['locationId'];
    dieselRetail = json['dieselRetail'];
    dieselNet = json['dieselNet'];
    asOfDate = json['asOfDate'];
    gasRetail = json['gasRetail'];
    gasNet = json['gasNet'];
    gasAsOfDate = json['gasAsOfDate'];
  }

  Map<String, dynamic> toJson() => {
        'locationId': locationId,
        'dieselRetail': dieselRetail,
        'dieselNet': dieselNet,
        'asOfDate': asOfDate,
        'gasRetail': gasRetail,
        'gasNet': gasNet,
        'gasAsOfDate': gasAsOfDate,
      };

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
