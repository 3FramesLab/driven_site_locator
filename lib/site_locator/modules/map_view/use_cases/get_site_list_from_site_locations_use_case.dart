part of map_view_module;

class GetSiteListFromSiteLocationsUseCase
    extends BaseUseCase<List<Site>, GetSiteListFromSiteLocationsParams> {
  @override
  List<Site> execute(GetSiteListFromSiteLocationsParams param) =>
      param.siteLocationsList.map(siteItem).toList();

  Site siteItem(SiteLocation siteLocation) {
    return Site(
      id: siteLocation.masterIdentifier ?? '',
      shopName: siteLocation.locationName ?? '',
      latitude: siteLocation.siteLatitude ?? 0,
      longitude: siteLocation.siteLongitude ?? 0,
      price: getPriceData(siteLocation),
      hasDiscount: getDiscountFlag(siteLocation),
      hasGallonUp: getGallonUpFlag(siteLocation),
      brandLogoIdentifier: getBrandLogoIdentifier(siteLocation),
    );
  }

  String? getPriceData(SiteLocation siteLocation) {
    final fuelPrice = SiteLocatorConfig.getFuelPrice(siteLocation);
    return fuelPrice == 0 ? null : SiteInfoUtils.getFuelPriceString(fuelPrice);
  }

  bool getDiscountFlag(SiteLocation siteLocation) =>
      SiteLocatorConfig.isDiscountFeatureEnabled &&
      SiteLocatorConfig.hasDiscountNetwork(siteLocation);

  String getBrandLogoIdentifier(SiteLocation siteLocation) =>
      SiteInfoUtils.getPinDropBrandLogoIdentifier(siteLocation);

  bool getGallonUpFlag(SiteLocation siteLocation) =>
      SiteLocatorConfig.hasGallonNetwork(siteLocation);
}

class GetSiteListFromSiteLocationsParams {
  final List<SiteLocation> siteLocationsList;

  GetSiteListFromSiteLocationsParams({required this.siteLocationsList});
}
