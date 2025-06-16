part of select_your_card_module;

class GetCardTypeForMerchSitesUseCase
    extends BaseUseCase<GetCardTypeForMerchSitesResponse, String> {
  @override
  GetCardTypeForMerchSitesResponse execute(String param) {
    FuelType fuelType =
        fuelTypeValues.map[UmaSLProperties.defaultProductType] ??
            FuelType.diesel;
    String merchSiteKey = '';

    try {
      if (param.isNotNullEmptyOrWhitespace) {
        for (final cardTypeMapping in UmaSLProperties.cardTypeMapping) {
          // Keep different if as we may have different computation ahead.
          if (cardTypeMapping.cardholderKeys.contains(param)) {
            merchSiteKey = cardTypeMapping.merchSiteKey;
            fuelType = cardTypeMapping.fuelType;
            break;
          }

          if (cardTypeMapping.adminKeys.contains(param)) {
            merchSiteKey = cardTypeMapping.merchSiteKey;
            fuelType = cardTypeMapping.fuelType;
            break;
          }

          if (cardTypeMapping.guestKeys.contains(param)) {
            merchSiteKey = cardTypeMapping.merchSiteKey;
            fuelType = cardTypeMapping.fuelType;
            break;
          }
        }
      }
    } catch (_) {}

    return GetCardTypeForMerchSitesResponse(
      key: merchSiteKey,
      fuelType: fuelType,
    );
  }
}

class GetCardTypeForMerchSitesResponse {
  final String key;
  final FuelType fuelType;

  GetCardTypeForMerchSitesResponse({
    required this.key,
    required this.fuelType,
  });
}
