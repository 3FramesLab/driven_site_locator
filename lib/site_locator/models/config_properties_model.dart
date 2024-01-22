class ConfigPropertiesModel {
  dynamic mapRadius;
  dynamic helpCenter;
  dynamic discountIndicator;
  dynamic defaultBrandLogo;
  dynamic defaultFuelType;
  dynamic summaryAPIQueryParam;
  dynamic fuelBrandsTopShortList;
  dynamic quickFilterOptions;
  dynamic clusterDensity;
  dynamic fuelPriceCacheDuration;

  ConfigPropertiesModel({
    this.mapRadius,
    this.helpCenter,
    this.discountIndicator,
    this.defaultBrandLogo,
    this.defaultFuelType,
    this.summaryAPIQueryParam,
    this.fuelBrandsTopShortList,
    this.quickFilterOptions,
    this.clusterDensity,
    this.fuelPriceCacheDuration,
  });

  ConfigPropertiesModel.fromJson(Map<String, dynamic> json) {
    mapRadius = json['mapRadius'];
    helpCenter = json['helpCenter'];
    discountIndicator = json['discountIndicator'];
    defaultBrandLogo = json['defaultBrandLogo'];
    defaultFuelType = json['defaultFuelType'];
    summaryAPIQueryParam = json['summaryAPIQueryParam'];
    fuelBrandsTopShortList = json['fuelBrandsTopShortList'];
    quickFilterOptions = json['quickFilterOptions'];
    clusterDensity = json['clusterDensity'];
    fuelPriceCacheDuration = json['fuelPriceCacheDuration'];
  }
}
