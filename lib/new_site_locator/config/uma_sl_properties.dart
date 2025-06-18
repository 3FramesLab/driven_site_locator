part of sl_config_module;

class UmaSLProperties {
  static UmaSLModel? configProperties;

  static List<Filter> filters = [];
  static double mapRadiusCircle = 250;
  static List<CardTypeMapping> cardTypeMapping = [];
  static List<DiscountAgainstBrand> discountAgainstBrands = [];
  static String defaultCardType = ''; // for merch sites
  static String defaultPrimaryBusiness = ''; // for merch sites
  static String defaultProductType = ''; // for merch sites
  static String merchSite24HoursMessage = '';
  static int maxDestinationInDistanceMatrix = 25;
  static List<String> topFuelBrands = [];
  static Map<String, String> merchSiteAmenitiesMapping = {};
  static int clusterDensity = 10;
  static double defaultMapRadius = 2.5;
  static double defaultMapRadiusInMeters =
      MathUtil.milesToMeters(defaultMapRadius);
  static double mapZoomLevel = 12.6;
  static bool showAllAmenities = false;
  static String defaultSiteSource = 'FN,MC,CDN,CFN';
  static Map<String, List<String>> siteSourceMapping = {
    'FN,MC,CDN,CFN': [],
  };
  static String displayFuelPrice = '';
  static int autoSearchSiteIntervalInMs = 2000;

  static final _getMapZoomLevelUseCase = GetMapZoomLevelUseCase();
  static ClusterAlgorithm clusterAlgorithm = ClusterAlgorithm.maxDist;

  static void init({Map<String, dynamic>? configJsonData}) {
    try {
      _getConfigData(configJsonData);
      _setFilters();
      _setMapRadiusCircle();
      _setCardTypeMapping();
      _setDiscountAgainstBrand();
      _setDefaultCardType();
      _setDefaultPrimaryBusiness();
      _setDefaultProductType();
      _setMerchSite24Hours();
      _setMaxDestinationInDistanceMatrix();
      _setTopFuelBrands();
      _setMapAmenitiesMapping();
      _setShowAllAmenities();
      _setDefaultSiteSource();
      _setSiteSourceMapping();
      _setDisplayFuelPrice();
      _setClusterDensity();
      _setAutoSearchSiteIntervalInMs();
      _getMapRadius();
      _setClusterAlgorithm();
    } catch (e) {
      Globals().dynatrace.logError(
            name: 'error in UMA SL properties init method',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  static void _getConfigData(Map<String, dynamic>? configJsonData) {
    if (configJsonData != null) {
      configProperties = UmaSLModel.fromJson(configJsonData);
    }
  }

  static void _setMapRadiusCircle() {
    try {
      if (configProperties?.mapRadiusCircle != null &&
          configProperties?.mapRadiusCircle[AppUtils.flavor] != null) {
        final mapRadiusCircleStr =
            configProperties?.mapRadiusCircle[AppUtils.flavor].toString();
        mapRadiusCircle = double.parse(mapRadiusCircleStr!);
      }
    } catch (e) {
      Globals().dynatrace.logError(
            name: 'error in fetching the map radius circle',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  static void _setCardTypeMapping() {
    try {
      if (configProperties?.cardTypeMapping != null &&
          configProperties?.cardTypeMapping[AppUtils.flavor] != null) {
        final jsonList =
            configProperties?.cardTypeMapping[AppUtils.flavor] as List;
        cardTypeMapping = [];
        for (final _json in jsonList) {
          cardTypeMapping.add(CardTypeMapping.fromJson(_json));
        }
      }
    } catch (e) {
      cardTypeMapping = [];
      Globals().dynatrace.logError(
            name: 'error in getting card type mapping',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  static void _setDiscountAgainstBrand() {
    try {
      if (configProperties?.discountAgainstBrands != null &&
          configProperties?.discountAgainstBrands[AppUtils.flavor] != null) {
        final jsonList =
            configProperties?.discountAgainstBrands[AppUtils.flavor] as List;
        discountAgainstBrands = [];
        for (final _json in jsonList) {
          discountAgainstBrands.add(DiscountAgainstBrand.fromJson(_json));
        }
      }
    } catch (e) {
      discountAgainstBrands = [];
      Globals().dynatrace.logError(
            name: 'error in fetching discount against the brands',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  static void _setDefaultCardType() {
    try {
      if (configProperties?.defaultCardType != null &&
          configProperties?.defaultCardType[AppUtils.flavor] != null) {
        defaultCardType =
            (configProperties?.defaultCardType[AppUtils.flavor] ?? '')
                .toString();
      }
    } catch (e) {
      defaultCardType = '';
      Globals().dynatrace.logError(
            name: 'error in fetching default card type',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  static void _setDefaultPrimaryBusiness() {
    try {
      if (configProperties?.defaultPrimaryBusiness != null &&
          configProperties?.defaultPrimaryBusiness[AppUtils.flavor] != null) {
        defaultPrimaryBusiness =
            (configProperties?.defaultPrimaryBusiness[AppUtils.flavor] ?? '')
                .toString();
      }
    } catch (e) {
      defaultPrimaryBusiness = '';
      Globals().dynatrace.logError(
            name: 'error in fetching default primary business',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  static void _setDefaultProductType() {
    try {
      if (configProperties?.defaultProductType != null &&
          configProperties?.defaultProductType[AppUtils.flavor] != null) {
        defaultProductType =
            (configProperties?.defaultProductType[AppUtils.flavor] ?? '')
                .toString();
      }
    } catch (e) {
      defaultProductType = '';
      Globals().dynatrace.logError(
            name: 'error in fetching default product type',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  static void _setMerchSite24Hours() {
    try {
      if (configProperties?.merchSite24Hours != null &&
          configProperties?.merchSite24Hours[AppUtils.flavor] != null) {
        merchSite24HoursMessage =
            (configProperties?.merchSite24Hours[AppUtils.flavor] ?? '')
                .toString();
      }
    } catch (e) {
      merchSite24HoursMessage = '';
      Globals().dynatrace.logError(
            name: 'error in fetching merch site 24 hours message',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  static void _setFilters() {
    try {
      if (configProperties?.filters != null &&
          configProperties?.filters[AppUtils.flavor] != null) {
        final jsonList = configProperties?.filters[AppUtils.flavor] as List;
        filters = jsonList.map((filter) => Filter.fromJson(filter)).toList();
      }
    } catch (e) {
      filters = [];
      Globals().dynatrace.logError(
            name: 'error in converting filters to List<Filter>',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  static void _setMaxDestinationInDistanceMatrix() {
    try {
      if (configProperties?.maxDestinationInDistanceMatrix != null) {
        maxDestinationInDistanceMatrix =
            configProperties?.maxDestinationInDistanceMatrix;
      }
    } catch (e) {
      maxDestinationInDistanceMatrix = 25;
      Globals().dynatrace.logError(
            name: 'error in fetching max destination in distance matrix',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  static void _setTopFuelBrands() {
    try {
      if (configProperties?.topFuelBrands != null &&
          configProperties?.topFuelBrands[AppUtils.flavor] != null) {
        topFuelBrands =
            (configProperties?.topFuelBrands[AppUtils.flavor] as List<dynamic>)
                .toStringList();
      }
    } catch (e) {
      topFuelBrands = [];
      Globals().dynatrace.logError(
            name: 'error in fetching top fuel brands',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  static void _setMapAmenitiesMapping() {
    try {
      if (configProperties?.amenitiesMapping != null) {
        merchSiteAmenitiesMapping =
            (configProperties?.amenitiesMapping as Map<String, dynamic>)
                .map((key, value) => MapEntry(key, value.toString()));
      }
    } catch (e) {
      merchSiteAmenitiesMapping = {};
      Globals().dynatrace.logError(
            name: 'error in fetching merch site amenities mapping',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  static void _setShowAllAmenities() {
    try {
      if (configProperties?.showAllAmenities != null &&
          configProperties?.showAllAmenities[AppUtils.flavor] != null) {
        showAllAmenities =
            configProperties?.showAllAmenities[AppUtils.flavor] ?? false;
      }
    } catch (e) {
      showAllAmenities = false;
      Globals().dynatrace.logError(
            name: 'error in fetching show all amenities',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  static void _setDefaultSiteSource() {
    try {
      if (configProperties?.defaultSiteSource != null &&
          configProperties?.defaultSiteSource[AppUtils.flavor] != null) {
        defaultSiteSource =
            (configProperties?.defaultSiteSource[AppUtils.flavor] ?? '')
                .toString();
      }
    } catch (e) {
      defaultSiteSource = 'FN,MC,CDN,CFN';
      Globals().dynatrace.logError(
            name: 'error in fetching site source for merch sites',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  static void _setSiteSourceMapping() {
    try {
      if (configProperties?.siteSourceMapping != null &&
          configProperties?.siteSourceMapping[AppUtils.flavor] != null) {
        final value = configProperties?.siteSourceMapping[AppUtils.flavor];
        if (value is Map<String, dynamic>) {
          siteSourceMapping = value.map(
            (key, val) => MapEntry(
              key,
              (val as List<dynamic>).map((e) => e.toString()).toList(),
            ),
          );
        }
      }
    } catch (e) {
      siteSourceMapping = {'FN,MC,CDN,CFN': []};
      Globals().dynatrace.logError(
            name: 'error in fetching site source for merch sites',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  static void _setDisplayFuelPrice() {
    try {
      if (configProperties?.displayFuelPrice != null &&
          configProperties?.displayFuelPrice[AppUtils.flavor] != null) {
        displayFuelPrice =
            (configProperties?.displayFuelPrice[AppUtils.flavor] ?? '')
                .toString();
      }
    } catch (e) {
      displayFuelPrice = '';
      Globals().dynatrace.logError(
            name: 'error in fetching display fuel price',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  static void _setClusterDensity() {
    try {
      if (configProperties?.clusterDensity != null &&
          configProperties?.clusterDensity[AppUtils.flavor] != null) {
        clusterDensity = configProperties?.clusterDensity[AppUtils.flavor];
      }
    } catch (e) {
      Globals().dynatrace.logError(
            name: 'error in fetching cluster density',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  static void _setAutoSearchSiteIntervalInMs() {
    try {
      if (configProperties?.autoSearchSiteIntervalInMs != null &&
          configProperties?.autoSearchSiteIntervalInMs[AppUtils.flavor] !=
              null) {
        autoSearchSiteIntervalInMs =
            configProperties?.autoSearchSiteIntervalInMs[AppUtils.flavor];
      }
    } catch (e) {
      autoSearchSiteIntervalInMs = 2000;
      Globals().dynatrace.logError(
            name: 'error in fetching auto search site interval in ms',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  static void _setClusterAlgorithm() {
    try {
      if (configProperties?.clusterAlgorithm != null &&
          configProperties?.clusterAlgorithm[AppUtils.flavor] != null) {
        final clusterAlgorithmStr =
            configProperties?.clusterAlgorithm[AppUtils.flavor];
        if (clusterAlgorithmStr == 'maxDist') {
          clusterAlgorithm = ClusterAlgorithm.maxDist;
        } else if (clusterAlgorithmStr == 'geoHash') {
          clusterAlgorithm = ClusterAlgorithm.geoHash;
        }
      }
    } catch (e) {
      clusterAlgorithm = ClusterAlgorithm.maxDist;
      Globals().dynatrace.logError(
            name: 'error in fetching cluster algorithm',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  static void _getMapRadius() {
    try {
      if (configProperties?.mapRadiusInMiles[AppUtils.flavor] != null) {
        defaultMapRadius =
            double.parse(configProperties?.mapRadiusInMiles[AppUtils.flavor]);
      }
      getDefaultMapZoomLevel();
      defaultMapRadiusInMeters = MathUtil.milesToMeters(defaultMapRadius);
    } catch (e) {
      Globals().dynatrace.logError(
            name: 'error in fetching map radius in miles',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  static void getDefaultMapZoomLevel() => mapZoomLevel =
      _getMapZoomLevelUseCase.execute(GetMapZoomLevelParams(defaultMapRadius));
}
