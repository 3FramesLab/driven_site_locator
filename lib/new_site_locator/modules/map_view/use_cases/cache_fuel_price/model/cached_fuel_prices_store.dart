class CachedAllFuelPricesStore {
  int? recentTimeStamp;
  Map<String, CachedFuelPriceData?>? data;
  CachedAllFuelPricesStore({
    required this.recentTimeStamp,
    required this.data,
  });
}

class CachedFuelPriceKey {
  final String customerId;
  final String siteIdentifier;

  CachedFuelPriceKey(
    this.customerId,
    this.siteIdentifier,
  );

  @override
  String toString() {
    return '${customerId.toLowerCase()}_$siteIdentifier';
  }
}

class CachedFuelPriceData {
  final String? siteIdentifier;
  final double? dieselNet;
  final double? dieselRetail;
  final String? asOfDate;
  final double? gasNet;
  final double? gasRetail;
  final String? gasAsOfDate;
  final int? timeStamp;

  CachedFuelPriceData({
    this.siteIdentifier,
    this.dieselNet,
    this.dieselRetail,
    this.asOfDate,
    this.gasNet,
    this.gasRetail,
    this.gasAsOfDate,
    this.timeStamp,
  });
}
