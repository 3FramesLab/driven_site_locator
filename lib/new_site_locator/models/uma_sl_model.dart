class UmaSLModel {
  dynamic filters;
  dynamic mapRadiusCircle;
  dynamic cardTypeMapping;
  dynamic discountAgainstBrands;
  dynamic defaultCardType;
  dynamic defaultPrimaryBusiness;
  dynamic defaultProductType;
  dynamic merchSite24Hours;
  dynamic maxDestinationInDistanceMatrix;
  dynamic topFuelBrands;
  dynamic amenitiesMapping;
  dynamic clusterDensity;
  dynamic mapRadiusInMiles;
  dynamic showAllAmenities;
  dynamic defaultSiteSource;
  dynamic siteSourceMapping;
  dynamic displayFuelPrice;
  dynamic clusterAlgorithm;
  dynamic autoSearchSiteIntervalInMs;
  dynamic unbrandedStoreNames;
  dynamic stopClusterAtZoomLevel;
  dynamic adjustDuplicateLatLng;

  UmaSLModel({
    this.filters,
    this.mapRadiusCircle,
    this.cardTypeMapping,
    this.discountAgainstBrands,
    this.defaultCardType,
    this.defaultPrimaryBusiness,
    this.defaultProductType,
    this.merchSite24Hours,
    this.maxDestinationInDistanceMatrix,
    this.topFuelBrands,
    this.amenitiesMapping,
    this.clusterDensity,
    this.mapRadiusInMiles,
    this.showAllAmenities,
    this.defaultSiteSource,
    this.siteSourceMapping,
    this.displayFuelPrice,
    this.clusterAlgorithm,
    this.autoSearchSiteIntervalInMs,
    this.unbrandedStoreNames,
    this.stopClusterAtZoomLevel,
    this.adjustDuplicateLatLng,
  });

  factory UmaSLModel.fromJson(Map<String, dynamic> json) {
    return UmaSLModel(
      filters: json['filtersNew'],
      mapRadiusCircle: json['mapRadiusCircle'],
      cardTypeMapping: json['cardTypeMapping'],
      discountAgainstBrands: json['discountAgainstBrandsNew'],
      defaultCardType: json['defaultCardType'],
      defaultPrimaryBusiness: json['defaultPrimaryBusiness'],
      defaultProductType: json['defaultProductType'],
      merchSite24Hours: json['merchSite24Hours'],
      maxDestinationInDistanceMatrix: json['maxDestinationInDistanceMatrix'],
      topFuelBrands: json['topFuelBrands'],
      amenitiesMapping: json['amenitiesMapping'],
      clusterDensity: json['clusterDensity'],
      mapRadiusInMiles: json['mapRadiusInMiles'],
      showAllAmenities: json['showAllAmenities'],
      defaultSiteSource: json['defaultSiteSource'],
      siteSourceMapping: json['siteSourceMapping'],
      displayFuelPrice: json['displayFuelPrice'],
      clusterAlgorithm: json['clusterAlgorithm'],
      autoSearchSiteIntervalInMs: json['autoSearchSiteIntervalInMs'],
      unbrandedStoreNames: json['unbrandedStoreNames'],
      stopClusterAtZoomLevel: json['stopClusterAtZoomLevel'],
      adjustDuplicateLatLng: json['adjustDuplicateLatLng'],
    );
  }
}
