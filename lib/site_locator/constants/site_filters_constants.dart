import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/data/model/entitlement_repository.dart';
import 'package:driven_site_locator/site_locator/configuration/site_locator_config.dart';
import 'package:driven_site_locator/site_locator/constants/site_filter_keys_constants.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/data/models/site_filter.dart';

// class SiteFilters {

//   static SiteFilters? _singleton;
//   factory SiteFilters() => _singleton ?? _instance;
//   static SiteFilters get _instance => SiteFilters.init();

//   factory SiteFilters.init() {
//     _singleton = SiteFilters._internal();
//     return _singleton!;
//   }
//   SiteFilters._internal()
//       : quickFiltersList = getQuickFiltersList(),
//         amenitiesList = SiteLocatorConfig.amenitiesDisplayList,
//         featuresList = SiteLocatorConfig.locationFeaturesDisplayList,
//         fuelTypeList = getFuelTypeList(),
//         locationTypeList = getLocationTypeList(),
//         featuresPreferencesList = getFeaturesPreferencesList(),
//         cardholderLocationTypePreferences =
//             getCardholderLocationTypePreferences(),
//         cardholderLocationBrandsPreferences =
//             getCardholderLocationBrandsPreferences(),
//         cardholderFeaturesPreferences = getCardholderFeaturesPreferences();

//   static final _entitlementRepository = SiteLocatorEntitlementUtils.instance;

//   List<SiteFilter> quickFiltersList;
//   final List<SiteFilter> amenitiesList;
//   final List<SiteFilter> featuresList;
//   final List<SiteFilter> fuelTypeList;
//   final List<SiteFilter> locationTypeList;
//   final List<SiteFilter> featuresPreferencesList;
//   final List<SiteFilter> cardholderLocationTypePreferences;
//   final List<SiteFilter> cardholderLocationBrandsPreferences;
//   final List<SiteFilter> cardholderFeaturesPreferences;

//   static List<SiteFilter> getQuickFiltersList() {
//     return <SiteFilter>[
//       if (_entitlementRepository.isFuelQuickFilterEnabled) ...[
//         SiteFilter(
//           type: FilterTypeEnum.quickFilter,
//           key: AppUtils.isComdata
//               ? QuickFilterKeys.truckStop
//               : QuickFilterKeys.fuel,
//           label: QuickFilterLabel.fuel,
//           serviceType: ServiceTypeEnum.locationType,
//           order: 1,
//         ),
//       ],
//       if (_entitlementRepository.isServiceQuickFilterEnabled) ...[
//         SiteFilter(
//           type: FilterTypeEnum.quickFilter,
//           key: QuickFilterKeys.service,
//           label: QuickFilterLabel.service,
//           serviceType: ServiceTypeEnum.locationType,
//           order: 2,
//         ),
//       ],
//       if (_entitlementRepository.isDiscountsQuickFilterEnabled) ...[
//         SiteFilter(
//           type: FilterTypeEnum.quickFilter,
//           key: QuickFilterKeys.discounts,
//           label: QuickFilterLabel.discounts,
//           serviceType: ServiceTypeEnum.locationType,
//           order: 3,
//         ),
//       ],
//       if (_entitlementRepository.isGallonUpQuickFilterEnabled) ...[
//         SiteFilter(
//           type: FilterTypeEnum.quickFilter,
//           key: QuickFilterKeys.gallonUp,
//           label: QuickFilterLabel.gallonUp,
//           serviceType: ServiceTypeEnum.locationType,
//           order: 4,
//         ),
//       ],
//       if (_entitlementRepository.isFavoriteQuickFilterEnabled) ...[
//         SiteFilter(
//           type: FilterTypeEnum.quickFilter,
//           key: QuickFilterKeys.favorites,
//           label: QuickFilterLabel.favorites,
//           serviceType: ServiceTypeEnum.none,
//           order: 5,
//         ),
//       ],
//     ];
//   }

//   static List<SiteFilter> getFuelTypeList() => <SiteFilter>[
//         SiteFilter(
//           type: FilterTypeEnum.enhancedFilter,
//           key: FuelTypeFilterKeys.diesel,
//           label: FuelTypeFilterLabel.diesel,
//           serviceType: ServiceTypeEnum.fuelType,
//           order: 1,
//         ),
//         SiteFilter(
//           type: FilterTypeEnum.enhancedFilter,
//           key: FuelTypeFilterKeys.unleadedRegular,
//           label: FuelTypeFilterLabel.regularUnleaded,
//           serviceType: ServiceTypeEnum.fuelType,
//           order: 2,
//         ),
//         SiteFilter(
//           type: FilterTypeEnum.enhancedFilter,
//           key: FuelTypeFilterKeys.unleadedPremium,
//           label: FuelTypeFilterLabel.premiumUnleaded,
//           serviceType: ServiceTypeEnum.fuelType,
//           order: 3,
//         ),
//         SiteFilter(
//           type: FilterTypeEnum.enhancedFilter,
//           key: FuelTypeFilterKeys.unleadedPlus,
//           label: FuelTypeFilterLabel.unleadedPlus,
//           serviceType: ServiceTypeEnum.fuelType,
//           order: 4,
//         ),
//       ];

//   static List<SiteFilter> getLocationTypeList() =>
//       SiteLocatorConfig.locationTypeList;

//   static List<SiteFilter> getFeaturesPreferencesList() => [
//         SiteFilter(
//           type: FilterTypeEnum.preferredFilter,
//           key: AmenitiesFilterKeys.convenienceStore,
//           label: AmenitiesLabel.convenienceStore,
//           serviceType: ServiceTypeEnum.amenities,
//           order: 1,
//         ),
//         SiteFilter(
//           type: FilterTypeEnum.preferredFilter,
//           key: LocationFeatureFilterKeys.rigAccess,
//           label: SiteFeaturesLabel.rigAccess,
//           serviceType: ServiceTypeEnum.amenities,
//           order: 2,
//         ),
//         SiteFilter(
//           type: FilterTypeEnum.preferredFilter,
//           key: LocationFeatureFilterKeys.payAtPump,
//           label: SiteFeaturesLabel.payAtPump,
//           serviceType: ServiceTypeEnum.features,
//           order: 3,
//         ),
//       ];

//   static List<SiteFilter> getCardholderLocationTypePreferences() => [
//         SiteFilter(
//           type: FilterTypeEnum.preferredFilter,
//           key: LocationTypeFilterKeys.truckStop,
//           label: LocationTypeFilterLabel.truckStop,
//           serviceType: ServiceTypeEnum.locationType,
//           order: 1,
//         ),
//         SiteFilter(
//           type: FilterTypeEnum.preferredFilter,
//           key: LocationTypeFilterKeys.service,
//           label: LocationTypeFilterLabel.serviceStations,
//           serviceType: ServiceTypeEnum.locationType,
//           order: 2,
//         ),
//       ];

//   static List<SiteFilter> getCardholderLocationBrandsPreferences() => [
//         SiteFilter(
//           type: FilterTypeEnum.preferredFilter,
//           key: LocationBrandsFilterKeys.pilot,
//           label: LocationBrandsFilterLabel.pilot,
//           serviceType: ServiceTypeEnum.fuelBrand,
//           order: 1,
//         ),
//         SiteFilter(
//           type: FilterTypeEnum.preferredFilter,
//           key: LocationBrandsFilterKeys.loves,
//           label: LocationBrandsFilterLabel.loves,
//           serviceType: ServiceTypeEnum.fuelBrand,
//           order: 2,
//         ),
//         SiteFilter(
//           type: FilterTypeEnum.preferredFilter,
//           key: LocationBrandsFilterKeys.ta,
//           label: LocationBrandsFilterLabel.ta,
//           serviceType: ServiceTypeEnum.fuelBrand,
//           order: 3,
//         ),
//       ];

//   static List<SiteFilter> getCardholderFeaturesPreferences() => [
//         SiteFilter(
//           type: FilterTypeEnum.preferredFilter,
//           key: LocationFeatureFilterKeys.rigParking,
//           label: SiteFeaturesLabel.rigParking,
//           serviceType: ServiceTypeEnum.features,
//           order: 1,
//         ),
//         SiteFilter(
//           type: FilterTypeEnum.preferredFilter,
//           key: LocationFeatureFilterKeys.permits,
//           label: SiteFeaturesLabel.permits,
//           serviceType: ServiceTypeEnum.features,
//           order: 1,
//         )
//       ];
// }

class SiteFilters {
  // static final EntitlementRepository _entitlementRepository =
  //     Get.find<EntitlementRepository>();
  static final _entitlementRepository = SiteLocatorEntitlementUtils.instance;

  static List<SiteFilter> quickFiltersList = <SiteFilter>[
    if (_entitlementRepository.isFuelQuickFilterEnabled) ...[
      SiteFilter(
        type: FilterTypeEnum.quickFilter,
        key: AppUtils.isComdata
            ? QuickFilterKeys.truckStop
            : QuickFilterKeys.fuel,
        label: QuickFilterLabel.fuel,
        serviceType: ServiceTypeEnum.locationType,
        order: 1,
      ),
    ],
    if (_entitlementRepository.isServiceQuickFilterEnabled) ...[
      SiteFilter(
        type: FilterTypeEnum.quickFilter,
        key: QuickFilterKeys.service,
        label: QuickFilterLabel.service,
        serviceType: ServiceTypeEnum.locationType,
        order: 2,
      ),
    ],
    if (_entitlementRepository.isDiscountsQuickFilterEnabled) ...[
      SiteFilter(
        type: FilterTypeEnum.quickFilter,
        key: QuickFilterKeys.discounts,
        label: QuickFilterLabel.discounts,
        serviceType: ServiceTypeEnum.locationType,
        order: 3,
      ),
    ],
    if (_entitlementRepository.isGallonUpQuickFilterEnabled) ...[
      SiteFilter(
        type: FilterTypeEnum.quickFilter,
        key: QuickFilterKeys.gallonUp,
        label: QuickFilterLabel.gallonUp,
        serviceType: ServiceTypeEnum.locationType,
        order: 4,
      ),
    ],
    if (_entitlementRepository.isFavoriteQuickFilterEnabled) ...[
      SiteFilter(
        type: FilterTypeEnum.quickFilter,
        key: QuickFilterKeys.favorites,
        label: QuickFilterLabel.favorites,
        serviceType: ServiceTypeEnum.none,
        order: 5,
      ),
    ],
  ];

  static final amenitiesList = SiteLocatorConfig.amenitiesDisplayList;

  static final featuresList = SiteLocatorConfig.locationFeaturesDisplayList;

  static final fuelTypeList = <SiteFilter>[
    SiteFilter(
      type: FilterTypeEnum.enhancedFilter,
      key: FuelTypeFilterKeys.diesel,
      label: FuelTypeFilterLabel.diesel,
      serviceType: ServiceTypeEnum.fuelType,
      order: 1,
    ),
    SiteFilter(
      type: FilterTypeEnum.enhancedFilter,
      key: FuelTypeFilterKeys.unleadedRegular,
      label: FuelTypeFilterLabel.regularUnleaded,
      serviceType: ServiceTypeEnum.fuelType,
      order: 2,
    ),
    SiteFilter(
      type: FilterTypeEnum.enhancedFilter,
      key: FuelTypeFilterKeys.unleadedPremium,
      label: FuelTypeFilterLabel.premiumUnleaded,
      serviceType: ServiceTypeEnum.fuelType,
      order: 3,
    ),
    SiteFilter(
      type: FilterTypeEnum.enhancedFilter,
      key: FuelTypeFilterKeys.unleadedPlus,
      label: FuelTypeFilterLabel.unleadedPlus,
      serviceType: ServiceTypeEnum.fuelType,
      order: 4,
    ),
  ];

  static final locationTypeList = SiteLocatorConfig.locationTypeList;

  static final featuresPreferencesList = [
    SiteFilter(
      type: FilterTypeEnum.preferredFilter,
      key: AmenitiesFilterKeys.convenienceStore,
      label: AmenitiesLabel.convenienceStore,
      serviceType: ServiceTypeEnum.amenities,
      order: 1,
    ),
    SiteFilter(
      type: FilterTypeEnum.preferredFilter,
      key: LocationFeatureFilterKeys.rigAccess,
      label: SiteFeaturesLabel.rigAccess,
      serviceType: ServiceTypeEnum.amenities,
      order: 2,
    ),
    SiteFilter(
      type: FilterTypeEnum.preferredFilter,
      key: LocationFeatureFilterKeys.payAtPump,
      label: SiteFeaturesLabel.payAtPump,
      serviceType: ServiceTypeEnum.features,
      order: 3,
    ),
  ];

  static final cardholderLocationTypePreferences = [
    SiteFilter(
      type: FilterTypeEnum.preferredFilter,
      key: LocationTypeFilterKeys.truckStop,
      label: LocationTypeFilterLabel.truckStop,
      serviceType: ServiceTypeEnum.locationType,
      order: 1,
    ),
    SiteFilter(
      type: FilterTypeEnum.preferredFilter,
      key: LocationTypeFilterKeys.service,
      label: LocationTypeFilterLabel.serviceStations,
      serviceType: ServiceTypeEnum.locationType,
      order: 2,
    ),
  ];

  static final cardholderLocationBrandsPreferences = [
    SiteFilter(
      type: FilterTypeEnum.preferredFilter,
      key: LocationBrandsFilterKeys.pilot,
      label: LocationBrandsFilterLabel.pilot,
      serviceType: ServiceTypeEnum.fuelBrand,
      order: 1,
    ),
    SiteFilter(
      type: FilterTypeEnum.preferredFilter,
      key: LocationBrandsFilterKeys.loves,
      label: LocationBrandsFilterLabel.loves,
      serviceType: ServiceTypeEnum.fuelBrand,
      order: 2,
    ),
    SiteFilter(
      type: FilterTypeEnum.preferredFilter,
      key: LocationBrandsFilterKeys.ta,
      label: LocationBrandsFilterLabel.ta,
      serviceType: ServiceTypeEnum.fuelBrand,
      order: 3,
    ),
  ];

  static final cardholderFeaturesPreferences = [
    SiteFilter(
      type: FilterTypeEnum.preferredFilter,
      key: LocationFeatureFilterKeys.rigParking,
      label: SiteFeaturesLabel.rigParking,
      serviceType: ServiceTypeEnum.features,
      order: 1,
    ),
    SiteFilter(
      type: FilterTypeEnum.preferredFilter,
      key: LocationFeatureFilterKeys.permits,
      label: SiteFeaturesLabel.permits,
      serviceType: ServiceTypeEnum.features,
      order: 1,
    )
  ];
}
