part of map_view_module;

class GetSiteListFromSiteLocationsUseCase
    extends BaseUseCase<List<Site>, GetSiteListFromSiteLocationsParams> {
  @override
  List<Site> execute(GetSiteListFromSiteLocationsParams param) =>
      param.siteLocationsList.map(siteItem).toList();

  Site siteItem(SiteLocation siteLocation) {
    return Site(
      isServiceStation: getIsServiceStation(siteLocation),
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

  // String? getRandomBrandLogo(SiteLocation siteLocation) {
  //   List<String?> list = [null, null];
  //   if (siteLocation.locationType?.truckStop == Status.Y) {
  //     list = [
  //       'ta',
  //       // 'loves',
  //       // null,
  //       // null,
  //       // null,
  //       // 'circle k',
  //       // 'quiktrip',
  //       // 'racetrac',
  //       // 'road ranger',
  //       // 'royal farms',
  //       // 'rutters',
  //       // 'sapp bros',
  //       // 'sheetz',
  //       // null,
  //     ];
  //   }

  //   final _random = Random();
  //   return list[_random.nextInt(list.length)];
  // }

  bool getIsServiceStation(SiteLocation siteLocation) {
    return siteLocation.primaryBusiness == 'VM';
  }

  double? getPriceData(SiteLocation siteLocation) {
    return DcSiteLocatorUtils.getFuelPriceForMarker(siteLocation);
  }

  // bool getDiscountFlag(SiteLocation siteLocation) =>
  //     SiteLocatorConfig.isDiscountFeatureEnabled &&
  //     SiteLocatorConfig.hasDiscountNetwork(siteLocation);

  bool getDiscountFlag(SiteLocation siteLocation) => false;

  String getBrandLogoIdentifier(SiteLocation siteLocation) =>
      SiteInfoUtils.getPinDropBrandLogoIdentifier(siteLocation);

  // bool getGallonUpFlag(SiteLocation siteLocation) =>
  //     SiteLocatorConfig.hasGallonNetwork(siteLocation);

  bool getGallonUpFlag(SiteLocation siteLocation) => false;
}

class GetSiteListFromSiteLocationsParams {
  final List<SiteLocation> siteLocationsList;

  GetSiteListFromSiteLocationsParams({required this.siteLocationsList});
}
