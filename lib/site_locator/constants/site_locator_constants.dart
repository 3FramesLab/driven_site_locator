import 'package:driven_site_locator/site_locator/constants/site_locator_dimensions.dart';
import 'package:driven_site_locator/site_locator/data/models/enum_values.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SiteLocatorConstants {
  //site-locator
  static const mapDebounceTimeInSeconds = 2;
  static const siteLocatorAccessTokenExpiryTimeInMinutes = 30;
  static const siteLocatorAccessToken = 'site_locator_access_token';
  static const siteLocatorAccessTokenLastUpdatedTime =
      'site_locator_access_token_updated_time';
  static const isLocationPermissionStatusUpdated =
      'is_location_permission_status_updated';
  static const locationPermissionStatus =
      'is_location_permission_status_updated';
  static const viewSiteLocator = 'View Site Locator';
  static const defaultUserLocation = LatLng(36.158939, -86.781948);
  static const noLocationsErrorText =
      'No locations were found. To view more sites, please expand the search area or reposition the map center.';
  static const maxZoomLevelErrorText =
      'You exceeded the 25-mile radius limit. To view more sites,please reposition the map center.';
  static const noLocationsErrorModalTime = 3;
  static const noMatchingLocationsModalTime = 3;
  static const unLeaded = 'Unleaded';
  static const retailPrice = 'Retail price';
  static const discountPrice = 'Discount price';
  static const diesel = 'Diesel';
  static const service = 'Service';
  static const discountLabel = 'Discount';
  static const retailLabel = 'Retail';
  static const directions = 'Directions';
  static const cancel = 'Cancel';
  static const call = 'Call';
  static const addToFavorites = 'Add to favorites';
  static const removeFromFavorites = 'Remove from favorites';
  static const addFavorite = 'Add Favorite';
  static const favorite = 'Favorite';
  static const details = 'Details';
  static const discountSite = 'Discount Site';
  static const gallonUp = 'Gallon UP';
  static const removeNewFilters = 'Remove\nNew Filters';
  static const exit = 'Exit';
  static const highway = 'Highway';
  static const fuelPriceAsOfBannerText = 'Fuel price updated on';
  static const shareLocation = 'Share Location';

  static const infoDiscountFeesBannerHeight = 48.0;
  static const locationNameWidgetHeight = 36;
  static const panelWidgetHeight = 406.0;
  static const phoneMaintenanceWidgetHeight = 26;
  static const milesUnit = 'mi';

  static const unbranded = 'Unbranded';
  static const locationEnableCounter = 'location_enable_counter';
  static const locationEnableDialogTitle =
      'To view fuel locations near you, please enable Location Services in Settings.';
  static const locationEnableDialogButtonText = 'Open Settings';
  static const locationEnableDialogSecondaryText = 'Cancel';
  static const locationEnableDialogCount = 10;
  static const minLocationEnableDialogHeight = 200.0;
  static LatLngBounds defaultLatLngBounds = LatLngBounds(
    southwest: const LatLng(36.66, -119.93),
    northeast: const LatLng(36.9, -119.51),
  );
  static const siteInfoIconSize = 18.0;
  static const searchIconName = 'search';

  static const launchUrlOrPhone = 'Launch URL or phone';
  static const openDialerAppErrorMessage = 'Could not launch caller app.';
  static const siteInfoBottomListItemHeight = SiteLocatorDimensions.dp58;
  static const siteLocatorDialerAppOpen = 'tel:+1';
  static const launchDirectionsAppError =
      'Cannot Launch Directions App, please try again';

  static const feesMayApply = 'Fees May Apply';
  static const viewAllDiscounts = 'View All Discounts';
  static const launchDirections = 'Launch Directions App';
  static const amenitiesHeading = 'Amenities';
  static const locationFeaturesHeading = 'Location Features';
  static const shippingServices = 'Shipping Services';
  static const fuelsHeading = 'Fuels';
  static const locationTypeHeading = 'Location Type';
  static const fuelBrand = 'Fuel Brand';
  static const locationBrand = 'Location Brand';
  static const backToMapLabel = 'Map';

  static const filterButtonLabel = 'Filter';
  static const listViewButtonLabel = 'List';
  static const resetCode = 'RESET_CODE';
  static const unknownKey = 'UNKNOWN_KEY';
  static const favoriteSiteListStorageKey = 'favorite_site_list_storage_key';
  static const quickFilterButtonHeight = 40.0;
  static const quickFiltersContainerHeight = 45.0;
  static const quickFiltersContainerLeftPosition = 5.0;
  static const quickFiltersContainerTopPosition = 60.0;
  static const noMatchingLocationDialogTitle =
      'There are no locations that match the selected filters within this area.';
  static const noMatchingLocationDialogButtonText = 'Expand search by 5 miles';
  static const mileToMeterConvertUnit = 1609.34;
  static const incrementMiles = 5;
  static const search = 'search';
  static const clear = 'clear';
  static const extendedNetworkFees = 'Extended Network Fees';
  static const extendedNetworkText =
      'This location is part of the Fuelman Extended Network and does not offer a discount option.';
  static const extendedSubText =
      r'Fuelman may charge a fee of three dollars ($3.00) per transaction to use this location.';
  static const fuelPriceDisclaimer =
      'Price information is based on reported fuel prices over the last 72 hours. Retail fuel price at a location may vary.';
  static const fuelPriceAcknowledge =
      'I confirm that I have read and acknowledge the fuel price disclaimer';

  static const noLocationText = 'It looks like no locations were found.';
  static const searchForNewLocationText =
      'You can try searching for a new destination, revising your filters, or returning to the Map View to expand the map area.';

  static const changeFiltersDialogText =
      'It appears that there are no locations that match your selected filters in your expanded area.';
  static const changeFilters = 'Change Filters';
  static const thresholdDistanceForSitesUpdateInMeters = 1600.0;
  static const gallonUpDisclaimer = [
    'This location is part of the ',
    'Gallon UP/Preferred program',
    '. ',
    'Fuel at these preferred merchant locations to take advantage of the lowest transaction fees.',
  ];
  static const preferredHomeDialogText =
      'Would you like to make the locator map view your home screen?';

  static const fuelmanDiscountNetworkLocation =
      'Fuelman Discount Network Location';

  //site locator menu
  static const login = 'Login';
  static const logout = 'Log Out';
  static const preferencesFilters = 'Preferences & Filters';
  static const helpCenter = 'Help Center';
  static const legalPrivacy = 'Legal / Privacy';

  static const updateLocationDistanceInMeters = 100;
  static const thresholdForShowingChangeFiltersDialog = 3;
  static const preferred = 'Preferred';
  static const preferredSites = 'Preferred sites';

  // Left Header
  static const filters = 'Filters';
  static const routePlanner = 'Route Planner';

  static const webLogin = 'Login to Driven for Fuelman Portal';
  static const downloadFuelmanApp = 'Download Driven for Fuelman App';
  static const locationPreferences = 'Location Preferences';
  static const shareMyCurrentLocation = 'Share my current location';

  // Apply for fuelman
  static const applyForFuelman = 'Apply for Fuelman';
  static const applyForFuelmanUrl =
      'https://www.fuelman.com/fuel-cards/in-town-fleets/ ';
  static const openApplyForFuelmanError = 'Could not launch url.';

  static const useMyLocation = '''
You are currently viewing fuel sites in {Nashville, TN}.\n
To view fuel sites in a different location, use the search bar or enable “sitelocator.fuelman.com” to use your current location.
''';

  static const useMyLocationButton = 'Use My Current Location';
  static String continueWithoutUsingMyLocation =
      'Continue without using my location';

  static String menu = 'Menu';
  static String locationDetails = 'Location details';
}

class QuickFilterLabel {
  static const fuel = 'Fuel';
  static const service = 'Service';
  static const discounts = 'Discount';
  static const gallonUp = 'Gallon UP';
  static const preferred = 'Preferred';
  static const favorites = 'Favorites';
  static const truckStop = 'truckStop';
}

class FuelTypeLabel {
  static const unleaded = 'Unleaded';
  static const regular = 'Regular';
  static const midgrade = 'Midgrade';
  static const premium = 'Premium';
  static const diesel = 'Diesel';
  static const premiumUnleaded = 'Premium Unleaded';
  static const unleadedPlus = 'Unleaded Plus';
}

class AmenitiesLabel {
  static const atm = 'ATM';
  static const convenienceStore = 'Convenience Store';
  static const restaurant24Hr = '24 Hour Restaurant';
  static const shower = 'Shower';
  static const restaurant = 'Restaurant';
  static const lounge = 'Lounge';
  static const laundry = 'Laundry';
  static const motel = 'Motel';
}

class SiteFeaturesLabel {
  // fuelman
  static const services24Hr = '24 Hour Services';
  static const payAtPump = 'Automated Fuel Pump';
  static const hwyAccess = 'Highway Access';
  static const rigAccess = '18-Wheeler Access';
  static const rigParking = '18-Wheeler Parking';
  static const unattended = 'Unattended';
  static const highSpeedPump = 'High Speed Pump';
  static const tankReader = 'Tank Reader';

  // comdata
  static const permits = 'Permits';
  static const repairs = 'Repairs';
  static const safeHaven = 'Safe Haven';
  static const truckersStore = 'Truckers Store';
  static const tireRepair = 'Tire Repair';
  static const wreckerService = 'Wrecker Service';

  // common
  static const truckWash = 'Truck Wash';
  static const scales = 'Scales';
}

class FuelTypeFilterLabel {
  static const diesel = 'Diesel';
  static const regularUnleaded = 'Regular Unleaded';
  static const premiumUnleaded = 'Premium Unleaded';
  static const unleadedPlus = 'Unleaded Plus';
}

class LocationTypeFilterLabel {
  static const fuelStations = 'Fuel Stations';
  static const truckStop = 'Truck Stop';
  static const serviceStations = 'Service Stations';
  static const discountsApplied = 'Discounts Applied';
  static const gallonUp = 'Gallon UP';
}

class LocationBrandsFilterLabel {
  static const pilot = 'Pilot';
  static const loves = "Love's";
  static const ta = 'TA';
}

class QuickFilters {
  static const fuel = 'fuel';
  static const service = 'service';
  static const discounts = 'discounts';
  static const favorites = 'favorites';
  static const gallonUp = 'gallonUp';
}

enum DiscountTypes { deepSaver, simpleSaver, anySaver }

final discountTypeValues = EnumValues({
  Discounts.deepSaver: DiscountTypes.deepSaver,
  Discounts.simpleSaver: DiscountTypes.simpleSaver,
  Discounts.doNotKnowMyPlan: DiscountTypes.anySaver
});

class Discounts {
  static const closeIconSize = 28.0;
  static const selectedDiscountSaverSP = 'selected discount saver sp';
  static const viewDiscountAmount = 'View Discount Amount';
  static const apply = 'Apply';
  static const dieselRebate = 'Diesel Rebate';
  static const unleadedRebate = 'Unleaded Rebate';

  static const deepSaverDieselRebate = '.08';
  static const deepSaverUnleadedRebate = '.05';
  static const simpleSaverBrandedDieselUnleadedRebate = '.10';
  static const simpleSaverUnBrandedDieselUnleadedRebate = '.02';
  static const fulemanDieselFleetCardDieselRebate = r'.10/gal or $.12';
  static const fulemanMixedFleetCardDieselUnLeadedRebate = r'.05/gal or $.08';

  static const gal = 'gal';
  static const deepSaver = 'Deep Saver';
  static const simpleSaver = 'Simple Saver';
  static const doNotKnowMyPlan = "I don't know my plan";
  static const deepSaverFleetCard = 'Deep Saver Fleet Card';
  static const simpleSaverFleetCard = 'Simple Saver Fleet Card';
  static const fuelmanDieselFleetCard = 'Fuelman Diesel Fleet Card';
  static const fuelmanMixedFleetCard = 'Fuelman Mixed Fleet Card';

  static const aboutDiscountPlansText =
      'If you don’t know your discount plan, that’s OK. We will continue to show you all discounts at this location.';
  static const discountPlansText =
      'To view your fleet’s fuel discount at all participating locations tell us what type of discount plan you have.';
  static const deepSaverBrandsValidateList = [
    'chevron',
    'texaco',
  ];
  static const simpleSaverBrandsValidateList = [
    'pilot',
    'speedway',
    'kwik trip',
    'ta',
  ];
  static String discountBannerText =
      r'Discount: $%1$/gal Diesel & $%2$/gal Unleaded';
  static String discountBannerTextInTwoLines = r'''
Discount: $%1$/gal Diesel &
$%2$/gal Unleaded''';
  static const deepSaverDiscountNotAvailableText =
      'Deep Saver discounts are not available at this location.';
  static const deepSaverDiscountNotAvailableTextInTwoLines =
      'Deep Saver discounts are\nnot available at this location.';
  static const consultYourProgramManagerMessage =
      'Consult your program manager to identify which rebate applies to your card.';
}

class DynatraceErrorMessages {
  static const getBrandLogosErrorName =
      'Get site locator brand logos api error';
  static const getBrandLogosErrorValue =
      'error while making api call for brand logos';

  static const geoCodingAPIErrorName = 'Google geo coding api error';
  static const geoCodingAPIErrorValue =
      'error while making api call for getting lat lng of selected place';

  static const placesAPIErrorName = 'Google places api error';
  static const placesAPIErrorValue =
      'error while making api call for getting places data';

  static const getSitesAPIErrorName = 'Get sites api error';
  static const getSitesAPIErrorValue =
      'error while making api call for getting site locations data';

  static const getFuelPricesAPIErrorName = 'Get fuel prices api error';
  static const getFuelPricesAPIErrorValue =
      'error while updating fuel prices in site locations data';
}

class EnhancedFilterConstants {
  static const filterBy = 'Filter by:';
  static const applyFilter = 'Apply Filters';
  static const clearAll = 'Clear All';
  static const showMoreBrands = 'Show More Brands';
  static const hideBrands = 'Hide Brands';
  static const search = 'Search';
  static const searchCriteriaNotFound =
      'No results found.\n\nPlease try a different search criteria.';
}

class SiteLocatorWidgetKeys {
  static const fuelBrandFilterList = 'fuel_brand_list_key';
  static const fuelBrandFilterSearchField = 'fuel_brand_search_field_key';
}

class SitesLocationCacheConstants {
  static const thresholdHour = 10;
  static const thresholdMinute = 00;
  static const locationFilePath = '/site_locator/';
  static const locationFileName = 'location_cache.txt';
  static const writeSitesLocationCache = 'Writing Sites Location Cache';
  static const readSitesLocationCache = 'Reading Sites Location Cache';
}

class SiteLocatorConfigConstants {
  static double fuelmanDefaultMapRadius = 2.5;
  static double comdataDefaultMapRadius = 25;

  static String fuelmanDefaultBrandLogoPath = 'site-fuelman-logo.png';
  static String comdataDefaultBrandLogoPath = 'site-comdata-logo.png';

  static String fuelmanDiscountIndicator = 'fmDiscountNetwork';
  static String comdataDiscountIndicator = 'N/A';

  static String fuelmanSitesAPIQueryParam = 'fuelman=Y';
  static String comdataSitesAPIQueryParam = 'comdata=Y';

  static List<String> fuelmanFuelTypesTopShortList = <String>[
    'exxon',
    'shell',
    'bp',
    'ta',
    'circle k'
  ];
  static List<String> comdataFuelTypesTopShortList = <String>[
    'shell',
    'bp',
    'ta',
    'circle k',
    'exxon',
  ];
  static List<String> fuelmanQuickFilterList = <String>[
    'fuel',
    'service',
    'discounts',
    'favorites'
  ];
  static List<String> comdataQuickFilterList = <String>[
    'fuel',
    'service',
    'gallonUp',
    'favorites',
  ];
}

class CardholderSetupConstants {
  static const personalizeYourApp = 'Personalize your App.';
  static const addFilterDescription =
      'Add filters to show only locations that are important to you.';
  static const locationTypeTitle = 'LOCATION TYPES';
  static const locationBrandsTitle = 'LOCATION BRANDS';
  static const truckingNeeds = 'TRUCKING NEEDS';
  static const startNavigating = 'Start Navigating';
  static const youCanAddRemoveFilters = 'You can add or remove filters later';

  static const weMadeItEasy = 'We made it easy!';
  static const letTheMapDoTheWork = 'Let the map do the work.';
  static const regularSites = 'Regular sites';
  static const gallonUpSites = 'Gallon UP sites';
}
