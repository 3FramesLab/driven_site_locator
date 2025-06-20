part of sl_constants_module;

class SLInternalText {
  static const defaultUserLocation = LatLng(33.74873, -84.3877);
  static const thresholdHour = 10;
  static const thresholdMinute = 00;
  static const siteInfoDrawerHalfViewHeight = 406.0;
  static const updateLocationDistanceInMeters = 100;
  static const thresholdDistanceForSitesUpdateInMeters = 1600.0;
  static const thresholdForShowingChangeFiltersDialog = 3;
  static const noLocationsErrorModalTime = 3;
  static const noMatchingLocationsModalTime = 3;
  static const infoDiscountFeesBannerHeight = 48.0;
  static const locationNameWidgetHeight = 36;
  static const panelWidgetHeight = 406.0;
  static const siteInfoDrawerCollapseHeight = 0.0;
  static const panelWidgetHeightWithoutPhoneAndHours = 350.0;
  static const phoneMaintenanceWidgetHeight = 26;
  static const mileToMeterConvertUnit = 1609.34;
  static const listViewPanelSlidePosition = 0.89672;
  static const incrementMiles = 5;
  static const locationEnableDialogCount = 10;
  static const rateStarSize = 16.0;
  static const siteInfoBottomListItemHeight = 58.0;
  static const minLocationEnableDialogHeight = 200.0;
  static const siteInfoIconSize = 18.0;
  static const socketError = 502;

  static const ratedStarColor = Color(0xFFffb300);
  static const unratedStarColor = Color(0XFFe0e0e0);

  static const requestFailed = 'Failed to load request options';
  static const internalServerError =
      'Internal Server Error. Try again or contact a customer support representative';
  static const unableToParseJSON = 'Unable to Parse JSON response';
  static const launchUrlOrPhone = 'Launch URL or phone';
  static const openDialerAppErrorMessage = 'Could not launch caller app.';
  static const siteLocatorDialerAppOpen = 'tel:+1';
  static const launchDirectionsAppError =
      'Cannot Launch Directions App, please try again';
  static const discountLabel = 'Discount';
  static const retailLabel = 'Retail';
  static const directions = 'Directions';
  static const cancel = 'Cancel';
  static const call = 'Call';
  static const shareYourLocation = 'Share your location';
  static const unavailable = 'Unavailable';
  static const searchIconName = 'search';
  static const searchForCityStreetZip =
      'Search for city, ZIP, street, avenue...';
  static const locationEnableCounter = 'location_enable_counter';
  static const locationEnableDialogTitle =
      'To view fuel locations near you, please enable Location Services in Settings.';
  static const locationEnableDialogButtonText = 'Open Settings';
  static const locationEnableDialogSecondaryText = 'Cancel';
  static const search = 'search';
  static const clear = 'clear';
  static const extendedNetworkFees = 'Extended Network Fees';
  static const searchThisArea = 'Search this area';
  static const resetCode = 'RESET_CODE';
  static const unknownKey = 'UNKNOWN_KEY';
  static const milesUnit = 'mi';
  static const unbranded = 'Unbranded';
  static const favoriteSiteListStorageKey = 'favorite_site_list_storage_key';
  static const noLocationsErrorText =
      'No locations were found. To view more sites, please expand the search area or reposition the map center.';
  static const maxZoomLevelErrorText =
      'You exceeded the 25-mile radius limit. To view more sites,please reposition the map center.';
  static const filterButtonLabel = 'Filter';
  static const listViewButtonLabel = 'List';

  ///
  ///Dynatrace error
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
  static const getActiveStatusForUnfavoriteCardsName =
      'Get active status for unfavorite cards';
  static const getActiveStatusForUnfavoriteCardsValue =
      'error while getting active status for unfavorite cards';
  static const getFuelPricesAPIErrorName = 'Get fuel prices api error';
  static const getFuelPricesAPIErrorValue =
      'error while updating fuel prices in site locations data';
  static const fetchCardsSiteLocatorAPIErrorName =
      'cards/sitelocator api error';
  static const fetchCardsSiteLocatorAPIErrorValue =
      'error while calling the cards/sitelocator api';
  static const encryptCardTokenErrorName = 'Card token encryption error';
  static const encryptCardTokenValue = 'error while encrypting card token';

  static const decryptCardTokenErrorName = 'Card token decryption error';
  static const decryptCardTokenValue = 'error while decryption card token';

  // SL filters
  static const cdProp = 'CDProp';
  static const cardTypeKey = 'cardType';
  static const brandKey = 'brands'; // same as filter json data
  static const selectAllBrandsKey = 'selectAllBrands';
  static const fuelKey = 'fuel'; // same as filter json data
  static const dieselKey = 'Diesel';
  static const gasKey = 'Gas';
  static const cngKey = 'CNG';
  static const primaryBusinessKey = 'primaryBusiness';
  static const viewMoreKey = 'viewMore';
  static const allOthers = 'allOthers';

  // Merch Site Api GET Parameters
  static const amenitiesParam = 'amenities';
  static const acceptedCardTypeParam = 'acceptedCardType';
  static const fleetIdParam = 'fleetId';
  static const productTypeParam = 'productType';
  static const siteClusterParam = 'siteCluster';
  static const sysAccountIdParam = 'sysAccountId';
  static const latitudeStartHereParam = 'latitudeStartHere';
  static const longitudeStartHereParam = 'longitudeStartHere';
  static const radiusParam = 'radius';
  static const primaryBusinessParam = 'primaryBusiness';
  static const siteSourceParam = 'siteSource';
  static const cardToken = 'cardToken';

  static const phoneNumberWithZeros = '0000000000';
  static const gallonUpFeeKey = 'GallonupFe';

  /// Hive
  static const predictionsTypeId = 6;
  static const structuredFormattingTypeId = 7;
  static const sitePlaceIdTypeId = 8;

  static const predictionHiveBox = 'predictionBox';
  static const sitePlaceIdBox = 'sitePlaceIdBox';

  // API Dio
  static const xDeviceToken = 'xDeviceToken';
  static const xDeviceTokenHeader = 'x-device-token';

  // Shared Peference
  static const siteLocatorAccessToken = 'site_locator_access_token_new';
  static const siteLocatorAccessTokenLastUpdatedTime =
      'site_locator_access_token_updated_time_new';
}
