import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/data/model/entitlement_repository.dart';
import 'package:driven_site_locator/site_locator/configuration/site_locator_config.dart';
import 'package:driven_site_locator/site_locator/constants/site_filter_keys_constants.dart';
import 'package:driven_site_locator/site_locator/constants/site_filters_constants.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/data/models/enhanced_filter_model.dart';
import 'package:driven_site_locator/site_locator/data/models/site_filter.dart';

final _entitlementRepository = SiteLocatorEntitlementUtils.instance;

final EnhancedFilterModel _amenities = EnhancedFilterModel(
  filterHeader: SiteLocatorConstants.amenitiesHeading,
  filterItems: SiteFilters.amenitiesList,
  serviceType: ServiceTypeEnum.amenities,
);

final EnhancedFilterModel _locationFeatures = EnhancedFilterModel(
  filterHeader: SiteLocatorConstants.locationFeaturesHeading,
  filterItems: SiteFilters.featuresList
      .where((e) => e.flavors.contains(AppUtils.flavor))
      .toList(),
  serviceType: ServiceTypeEnum.features,
);

final EnhancedFilterModel _fuels = EnhancedFilterModel(
  filterHeader: SiteLocatorConstants.fuelsHeading,
  filterItems: SiteFilters.fuelTypeList,
  serviceType: ServiceTypeEnum.fuelType,
);

final EnhancedFilterModel _locationType = EnhancedFilterModel(
  filterHeader: SiteLocatorConstants.locationTypeHeading,
  filterItems: SiteFilters.locationTypeList
      .where((e) => e.flavors.contains(AppUtils.flavor))
      .toList(),
  serviceType: ServiceTypeEnum.locationType,
);

final EnhancedFilterModel fuelBrand = EnhancedFilterModel(
  filterHeader: AppUtils.isComdata
      ? SiteLocatorConstants.locationBrand
      : SiteLocatorConstants.fuelBrand,
  filterItems: SiteLocatorConfig.getFuelBrandsDisplayList(),
  serviceType: ServiceTypeEnum.fuelBrand,
);

List<EnhancedFilterModel> enhancedFilterData = [
  if (_entitlementRepository.isAmenitiesFilterEnabled) ...[
    _amenities,
  ],
  if (_entitlementRepository.isLocationFeatureFilterEnabled) ...[
    _locationFeatures,
  ],
  if (_entitlementRepository.isFuelsFilterEnabled) ...[
    _fuels,
  ],
  if (_entitlementRepository.isLocationTypeFilterEnabled) ...[
    _locationType,
  ],
  if (_entitlementRepository.isFuelBrandsFilterEnabled) ...[
    fuelBrand,
  ],
];

final favoriteQuickFilter = SiteFilters.quickFiltersList
    .firstWhere((filter) => filter.key == QuickFilterKeys.favorites);

final fuelQuickFilter = SiteFilters.quickFiltersList
    .firstWhere((e) => e.key == QuickFilterKeys.fuel);

final serviceQuickFilter = SiteFilters.quickFiltersList
    .firstWhere((e) => e.key == QuickFilterKeys.service);

final discountsQuickFilter = SiteFilters.quickFiltersList
    .firstWhere((e) => e.key == QuickFilterKeys.discounts);

final gallonQuickFilter = SiteFilters.quickFiltersList
    .firstWhere((e) => e.key == QuickFilterKeys.gallonUp);
