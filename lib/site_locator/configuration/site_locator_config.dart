import 'dart:async';

import 'package:driven_common/globals.dart';
import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/data/model/entitlement_repository.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/configuration/fuel_brands_configuration/fuel_brands_source.dart';
import 'package:driven_site_locator/site_locator/configuration/site_locator_discount.dart';
import 'package:driven_site_locator/site_locator/configuration/site_locator_fuels.dart';
import 'package:driven_site_locator/site_locator/configuration/z_site_locator_flavors_log.dart';
import 'package:driven_site_locator/site_locator/constants/site_filters_constants.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';
import 'package:driven_site_locator/site_locator/data/models/site_filter.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/models/config_properties_model.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/use_cases/get_map_zoom_level_use_case.dart';
import 'package:driven_site_locator/site_locator/site_locator_map/core/custom_pin_markers/custom_pin.dart';
import 'package:driven_site_locator/site_locator/use_cases/diesel_prices/display_diesel_price_usecase.dart';
import 'package:driven_site_locator/site_locator/use_cases/diesel_prices/get_diesel_prices_pack_usecase.dart';
import 'package:driven_site_locator/site_locator/utilities/math_utils.dart';
import 'package:get/get.dart';

class SiteLocatorConfig {
  // static final EntitlementRepository _entitlementRepository = Get.find();
  static final _entitlementRepository = SiteLocatorEntitlementUtils.instance;
  static final _displayDieselPriceUseCase =
      Get.put(DisplayDieselPriceUseCase());

  static const String notApplicable = 'N/A';
  static const String fmDiscountKey = 'fmDiscountNetwork';
  static const String mcDiscountKey = 'mcDiscountNetwork';

  static bool isDisplayMapEnabled = false;
  static bool isClusterFeatureEnabled = false;
  static double defaultMapRadius = 2.5;
  static double defaultMapRadiusInMeters =
      MathUtil.milesToMeters(defaultMapRadius);
  static String defaultBrandLogoPath = SiteLocatorAssets.fuelManBrandLogo;
  static String defaultComdataSiteBrandLogoPath =
      SiteLocatorAssets.comdataSiteBrandLogoDFC;
  static int defaultClusterDensity = 10;
  static int fuelPriceCacheDuration = 0;

  static String pricingSource = 'SIMS';
  static String defaultFuelType = 'Unleaded';
  static String summaryAPIQueryParam = 'fuelman=Y';
  static bool isDiscountFeatureEnabled = true;
  static String discountIndicator = 'fmDiscountNetwork';
  static String helpCenterUrl = 'https://help.ifleet.com/driven/';
  static bool isFeeDisclaimerEnabled = false;
  static List<String> _quickFiltersConfigData = [
    'fuel',
    'service',
    'discounts',
    'gallonUp',
    'favorites',
  ];
  static List<SiteFilter> quickFilterOptions = <SiteFilter>[];
  static List<String> fuelBrandsTopShortList = <String>[
    'exxon',
    'shell',
    'bp',
    'ta',
    'circle k',
  ];
  static List<SiteFilter> fuelBrandsDisplayList = <SiteFilter>[];
  static ConfigPropertiesModel? configProperties;
  static EnhancedSiteFilter? _enhancedSiteFilter;
  static double mapZoomLevel = 12.6;

  static final GetMapZoomLevelUseCase _getMapZoomLevelUseCase =
      Get.put(GetMapZoomLevelUseCase());

  static bool isEmptyAminities = false;

  static Future<void> init({
    bool setup = true,
    Map<String, dynamic>? configDataJson,
  }) async {
    await _setupConfigData(setup: setup);
  }

  static Future<void> _setupConfigData({
    bool setup = true,
    Map<String, dynamic>? configDataJson,
  }) async {
    try {
      await _getConfigData(configDataJson: configDataJson);
      await _setEnhancedFilterJson();
      _setIsDisplayMapEnabled();
      _getMapRadius();
      _getHelpCenterUrl();
      _setDefaultBrandLogoPath();
      _setDefaultFuelType();
      _setSummaryAPIQueryParam();
      _setIsDiscountFeatureEnabled();
      _setDiscountIndicator();
      _setFeeDisclaimerEnabled();
      _setQuickFilterOptions();
      _generateFuelBrandOptionsList();
      _logConfigInfo();
      _setIsClusterFeatureEnabled();
      _setClusterDensity();
      _setFuelPriceCacheDuration();
      if (isDisplayMapEnabled) {
        await CustomPin.initEvents(setup: setup, canCacheAllLogos: setup);
      }
    } catch (e) {
      Globals().dynatrace.logError(
            name: 'error in site locator config init method',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  static Future<void> _getConfigData({
    Map<String, dynamic>? configDataJson,
  }) async {
    // final json = await ConfigProperties.setup();
    // if (json != null) {
    //   configProperties = ConfigPropertiesModel.fromJson(json);
    // }
    if (configDataJson != null) {
      configProperties = ConfigPropertiesModel.fromJson(configDataJson);
    }
  }

  static void _setIsDisplayMapEnabled() =>
      isDisplayMapEnabled = _entitlementRepository.isSiteLocatorFeatureEnabled;

  static void _setIsDiscountFeatureEnabled() =>
      _entitlementRepository.isDiscountFeatureEnabled;

  static void _setFeeDisclaimerEnabled() =>
      isFeeDisclaimerEnabled = _entitlementRepository.isFeeDisclaimerEnabled;

  static List<SiteFilter> getFuelBrandsDisplayList() => fuelBrandsDisplayList;

  static void _logConfigInfo() {
    final _fuelBrandsTopShortList = (configProperties
            ?.fuelBrandsTopShortList[AppUtils.flavor] as List<dynamic>)
        .toStringList();
    SiteLocatorFlavorsLog.configInfo(
        _quickFiltersConfigData, _fuelBrandsTopShortList);
  }

  static void _getMapRadius() {
    if (configProperties?.mapRadius[AppUtils.flavor] != null) {
      defaultMapRadius =
          double.parse(configProperties?.mapRadius[AppUtils.flavor]);
    }
    getDefaultMapZoomLevel();
    defaultMapRadiusInMeters = MathUtil.milesToMeters(defaultMapRadius);
  }

  static void getDefaultMapZoomLevel() => mapZoomLevel =
      _getMapZoomLevelUseCase.execute(GetMapZoomLevelParams(defaultMapRadius));

  static void _getHelpCenterUrl() {
    if (configProperties?.helpCenter[AppUtils.flavor] != null) {
      helpCenterUrl = configProperties?.helpCenter[AppUtils.flavor];
    }
  }

  static void _setDefaultBrandLogoPath() {
    if (configProperties?.defaultBrandLogo[AppUtils.flavor] != null) {
      final logoFileName = configProperties?.defaultBrandLogo[AppUtils.flavor];
      defaultBrandLogoPath = '${SiteLocatorAssets.assetPath}/$logoFileName';
    }
  }

  static void _setDefaultFuelType() {
    if (configProperties?.defaultFuelType[AppUtils.flavor] != null) {
      defaultFuelType = configProperties?.defaultFuelType[AppUtils.flavor];
    }
  }

  static void _setDiscountIndicator() {
    if (configProperties?.discountIndicator[AppUtils.flavor] != null) {
      discountIndicator = configProperties?.discountIndicator[AppUtils.flavor];
    }
  }

  static void _setSummaryAPIQueryParam() {
    if (configProperties?.summaryAPIQueryParam[AppUtils.flavor] != null) {
      summaryAPIQueryParam =
          configProperties?.summaryAPIQueryParam[AppUtils.flavor];
    }
  }

  static void _setIsClusterFeatureEnabled() {
    isClusterFeatureEnabled = _entitlementRepository.isClusterFeatureEnabled;
  }

  static void _setClusterDensity() {
    if (configProperties?.clusterDensity[AppUtils.flavor] != null) {
      defaultClusterDensity =
          int.parse(configProperties?.clusterDensity[AppUtils.flavor]);
    }
  }

  static void _setFuelPriceCacheDuration() {
    if (configProperties?.fuelPriceCacheDuration != null &&
        configProperties?.fuelPriceCacheDuration[AppUtils.flavor] != null) {
      fuelPriceCacheDuration =
          int.parse(configProperties?.fuelPriceCacheDuration[AppUtils.flavor]);
    }
  }

  static void _setQuickFilterOptions() {
    if (configProperties?.quickFilterOptions[AppUtils.flavor] != null) {
      _quickFiltersConfigData = (configProperties
              ?.quickFilterOptions[AppUtils.flavor] as List<dynamic>)
          .toStringList();
    }

    final quickFilterOptionsList = <SiteFilter>[];
    for (int i = 0; i < SiteFilters.quickFiltersList.length; i++) {
      for (final String item in _quickFiltersConfigData) {
        if (SiteFilters.quickFiltersList[i].key.contains(item)) {
          quickFilterOptionsList.add(SiteFilters.quickFiltersList[i]);
        }
      }
    }
    quickFilterOptions = quickFilterOptionsList;
  }

  static void _generateFuelBrandOptionsList() {
    if (configProperties?.fuelBrandsTopShortList[AppUtils.flavor] != null) {
      fuelBrandsTopShortList = (configProperties
              ?.fuelBrandsTopShortList[AppUtils.flavor] as List<dynamic>)
          .toStringList();
    }

    final List<SiteFilter> fuelBrandList = [];
    int displayOrder = fuelBrandsTopShortList.length;
    for (final element in fuelAllBrandsListSource.entries) {
      bool isTopVisible = false;
      int displayOrderToSet = 0;
      if (fuelBrandsTopShortList.contains(element.key)) {
        displayOrderToSet = fuelBrandsTopShortList.indexOf(element.key) + 1;
        isTopVisible = true;
      } else {
        displayOrderToSet = displayOrder + 1;
        displayOrder = displayOrderToSet;
      }
      fuelBrandList.add(SiteFilter(
        type: FilterTypeEnum.enhancedFilter,
        key: element.key,
        label: element.value,
        serviceType: ServiceTypeEnum.fuelBrand,
        order: displayOrderToSet,
        isTopVisible: isTopVisible,
      ));
    }

    fuelBrandsDisplayList =
        (fuelBrandList..sort((a, b) => a.order.compareTo(b.order)));
  }

  static Map<String, dynamic> addQueryParams(Map<String, dynamic> jsonData) {
    final segments = summaryAPIQueryParam.split('&');
    for (int i = 0; i < segments.length; i++) {
      final param = segments[i];
      final paramSegments = param.split('=');
      final paramKey = paramSegments.first;
      final paramValue = paramSegments.last;
      jsonData[paramKey] = paramValue;
    }
    return jsonData;
  }

  static Future<void> _setEnhancedFilterJson() async {
    String jsonPath = SiteLocatorAssets.enhancedFilterConfig;
    if (isEmptyAminities) {
      jsonPath = SiteLocatorAssets.enhancedFilterConfigEmptyAminities;
    }
    final enhancedFilterJson = await AppUtils.readJsonFile(jsonPath);
    _enhancedSiteFilter = EnhancedSiteFilter.fromJson(enhancedFilterJson);
  }

  static List<SiteFilter> get amenitiesDisplayList =>
      _enhancedSiteFilter?.amenities ?? [];

  static List<SiteFilter> get locationFeaturesDisplayList =>
      _enhancedSiteFilter?.locationFeatures ?? [];

  static List<SiteFilter> get locationTypeList =>
      _enhancedSiteFilter?.locationTypes ?? [];

  static double getFuelPrice(SiteLocation siteLocation) {
    if (AppUtils.isComdata) {
      final param = DieselPricesPackParam(siteLocation: siteLocation);
      final dieselPriceEntity = _displayDieselPriceUseCase.execute(param);
      return dieselPriceEntity.priceNumeric;
    }
    return SiteLocatorFuels.getData(siteLocation).price;
  }

  static String getFuelTitle(SiteLocation siteLocation) =>
      SiteLocatorFuels.getData(siteLocation).type;

  static String getFuelDisplayPrice(SiteLocation siteLocation) =>
      SiteLocatorFuels.getData(siteLocation).displayPrice;

  static FuelData getFuelData(SiteLocation siteLocation) =>
      SiteLocatorFuels.getData(siteLocation);

  static bool hasDiscountNetwork(SiteLocation siteLocation) =>
      SiteLocatorDiscount.isEligible(siteLocation);

  static bool hasGallonNetwork(SiteLocation siteLocation) =>
      siteLocation.locationType?.gallonUp != null &&
      siteLocation.locationType?.gallonUp == Status.Y;
}
