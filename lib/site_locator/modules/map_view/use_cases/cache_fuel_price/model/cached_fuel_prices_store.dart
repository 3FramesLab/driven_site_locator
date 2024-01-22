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
    return '${customerId}_$siteIdentifier';
  }
}

class CachedFuelPriceData {
  final String? siteIdentifier;
  final double? dieselNet;
  final double? dieselRetail;
  final String? asOfDate;
  final int? timeStamp;

  CachedFuelPriceData({
    this.siteIdentifier,
    this.dieselNet,
    this.dieselRetail,
    this.asOfDate,
    this.timeStamp,
  });
}
