part of map_view_module;

mixin SiteLocatorState {
  SiteLocationsService siteLocationsService = Get.find();
  SiteLocatorAccessTokenController siteLocatorAccessTokenController =
      Get.put(SiteLocatorAccessTokenController());
  final searchPlacesController = Get.put(SearchPlacesController());
  final SitesLoadingProgressController sitesLoadingProgressController =
      Get.find();
  CardholderSetupController cardholderSetupController = Get.find();

  RxDouble infoPanelInitialHeight =
      SLInternalText.siteInfoDrawerHalfViewHeight.obs;
  List<SiteLocation>? siteLocations = [];
  List<SiteLocation>? previousSiteLocations = [];
  RxList<SiteLocation> recentViewSiteLocations = <SiteLocation>[].obs;
  RxInt mapKeyValue = 1.obs;
  int welcomeMapKeyValue = 11;
  RxList<Site> siteList = <Site>[].obs;
  RxList<Marker> markers = <Marker>[].obs;
  double sitesRadiusInMeters = UmaSLProperties.defaultMapRadiusInMeters;
  double allowedSitesRadiusInMeters = MathUtil.milesToMeters(25);
  GoogleMapController? googleMapController;
  GoogleMapController? welcomeGoogleMapController;
  Rx<LatLngBounds> currentLatLngBounds = LatLngBounds(
    southwest: const LatLng(36.66, -119.93),
    northeast: const LatLng(36.9, -119.51),
  ).obs;
  LatLngBounds reCenterLatLngBounds = LatLngBounds(
    southwest: const LatLng(36.66, -119.93),
    northeast: const LatLng(36.9, -119.51),
  );
  LatLngBounds? apiLatLngBounds;

  Rx<LatLngBounds> searchedPlaceLatLngBounds = LatLngBounds(
    southwest: const LatLng(36.66, -119.93),
    northeast: const LatLng(36.9, -119.51),
  ).obs;

  double mapPadding = 20;
  double allowedMapZoomLevel = 9;
  double? currentZoomLevel;
  double? previousZoomLevel;

  double defaultCircleZoom = 12.5;
  RxDouble cameraPositionZoom = 12.5.obs;
  RxBool isUserActionZoomIn = false.obs;
  RxBool backFromWelcomeToMapView = false.obs;
  bool resetMarkerForWelcomeMapView = false;
  RxDouble lastZoomByUser = 12.5.obs;
  RxBool isSiteInfoDialogOpened = false.obs;

  List<SiteLocation>? reCenterSiteLocations;

  RxBool isLocatorBottomNavTabPressed = false.obs;
  bool canClearSearchTextField = true;
  RxBool isShowLoading = false.obs;
  RxBool canShow2CTA = false.obs;
  bool isFirstLaunch = true;
  Rx<LatLng> currentLocation = SLInternalText.defaultUserLocation.obs;
  final Rx<LatLng?> centerLatLng = Rx<LatLng?>(null);
  final Rx<LatLng?> fixedCenterLatLng = Rx<LatLng?>(null);
  bool isFetchSitesData = false;
  bool isClusterClick = false;
  bool isShowingErrorModal = false;
  bool isMapPinTapped = false;
  double staticBottomSpacing = 30;
  List<Marker> initialMarkersList = [];

  Map<String, dynamic> initialValuesMap = <String, dynamic>{};
  late final PanelController locationPanelController = PanelController();
  late final PanelController mapViewSiteInfoPanelController;
  late final PanelController listViewSiteInfoPanelController;
  final PanelController setUpWizardPanelController = PanelController();
  RxDouble infoPanelMinHeight = 0.0.obs;
  Rx<SiteLocation> selectedSiteLocation = SiteLocation.blank().obs;
  RxDouble floatingButtonsBottomPosition = 0.0.obs;

  RxBool gpsIconButtonVisible = true.obs;
  RxBool canShowFloatingMapButtons = true.obs;
  RxBool searchIconButtonVisible = true.obs;
  RxMap<String, double> milesDataCache = RxMap({});
  RxString milesDisplay = ''.obs;
  bool isShowBackButton = false;
  RxBool isShownRemainingFullSiteInfo = false.obs;
  RxBool isSiteInfoFullViewed = false.obs;
  RxBool showOpacity = false.obs;
  RxBool showFullViewExtraData = false.obs;
  double defaultPositionBottom = 30;
  bool isBottomModalSheetVisible = false;
  RxBool isSiteFavorite = false.obs;
  RxList<String> favoriteList = <String>[].obs;
  RxBool isBottomModalSheetOpened = false.obs;
  List<SiteLocation> filteredSiteLocationsList = [];
  List<SiteFilter> selectedSiteFilters = [];
  double? lowestFuelPrice;
  List<String?> sitesIdentifierWithLowestFuelPrice = [];
  final _allEnhancedFilters =
      enhancedFilterData.map(EnhancedFilterModel.clone).toList();
  RxDouble expandRadiusCount = 1.0.obs;
  double safeAreaPadding = 0;

  // List view
  final RxBool sortingListLoader = false.obs;
  RxList<SiteLocation> listViewItems = RxList([]);
  // RxList<SiteLocation> sortedListViewData = RxList([]);
  RxList<SiteLocation> sortListByPrice = RxList([]);
  RxList<SiteLocation> sortListByDistance = RxList([]);
  RxList<SiteLocation> sortListByRatings = RxList([]);
  RxInt presentPageIndex = 0.obs;
  RxInt perPageCount = 0.obs;
  int maxCountPerPage = 10;
  RxBool isInitialListLoading = false.obs;
  RxBool isViewMoreLoading = false.obs;
  RxBool loadMoreSitesOnScroll = true.obs;

  RxBool showUIControls = true.obs;

  final _filterSessionManager = SiteFilterSessionManager();

  String selectedMapPinKey = SLInternalText.resetCode;
  List<Marker> rawMarkersList = [];
  MarkerDetails? prevSelectedMarkerDetails;
  MarkerDetails? previousMarkerDetails;
  RxList<Marker> welcomeScreenMarkers = <Marker>[].obs;

  final menuPanelController = PanelController();

  //use cases
  late ValidateLastSavedCenterLocationUseCase
      validateLastSavedCenterLocationUseCase;
  late SiteLocatorRepositoryImpl siteLocatorRepository;
  late RetrieveFiltersFromSPUseCase retrieveFiltersFromSPUseCase;
  late ApplySiteFilterUseCase applySiteFilterUseCase;
  late FilterSitesUseCase filterSitesUseCase;
  late UpdateMarkerIconUseCase updateMarkerIconUseCase;
  late GenerateMarkersUseCase generateMarkersUseCase;
  late StoreStringListIntoSPUseCase storeStringListIntoSPUseCase;
  late GetStringListFromSPUseCase getStringListFromSPUseCase;
  late GetSiteListFromSiteLocationsUseCase getSiteListFromSiteLocationsUseCase;
  late FilterMarkersUseCase filterMarkersUseCase;
  late GetUserLocationUseCase getUserLocationUseCase;
  late GetAccessTokenForSitesUseCase getAccessTokenForSitesUseCase;
  late GetSelectedPlaceLatLngUseCase getLatLngForSelectedPlaceUseCase;
  late ComputeCircleRadiusUseCase computeCircleRadiusUseCase;
  late GetSiteLocationsInVisibleMapRegionUseCase
      getSiteLocationsInVisibleMapRegionUseCase;
  late GetTapOnMapLocationMessageUseCase getTapOnMapLocationMessageUseCase;
  late GetWelcomeScreenInfoUseCase getWelcomeScreenInfoUseCase;
  late GetLowestFuelPriceUseCase getLowestFuelPriceUseCase;
  late GetSitesWithLowestFuelPriceUseCase getSitesWithLowestFuelPriceUseCase;
  late FetchPlaceIDUseCase fetchPlaceIDUseCase;
  late GetRatingsFromPlaceIdUseCase getRatingsFromPlaceIdUseCase;
  late SaveSitePlaceIdUseCase saveSitePlaceIdUseCase;
  late GetPlaceIdForSiteUseCase getPlaceIdForSiteUseCase;
  late MerchSiteFilterUseCase merchSiteFilterUseCase;
  late GetCardAcceptedUseCase getCardAcceptedUseCase;
  late GetSiteSourceFromCardTypeUseCase getSiteSourceFromCardTypeUseCase;
  late AdjustDuplicateLatLngUseCase adjustDuplicateLatLngUseCase;

  bool isGenerateMapPinsOnFiltering = false;
  bool positionStreamStarted = false;
  bool isMapViewCameraMoving = true;

  bool canRecenterMapViewOnLocationChange = true;
  LatLng prevUserCenterLocation = SLInternalText.defaultUserLocation;
  bool forceResetCanRecenterMapView = false;

  int expandRadiusButtonTapCount = 1;

  final locationCacheUtils = LocationCacheUtils();
  bool isFullMapViewFirstLaunch = true;

  late GetSitesUncachedFuelPriceUseCase getSitesUncachedFuelPriceUseCase;

  late ManageDieselSaleTypeUseCase manageDieselSaleTypeUseCase;
  late DieselPricesPackUseCase dieselPricesPackUseCase;
  late DisplayDieselPriceUseCase displayDieselPriceUseCase;

  bool isExecuteCameraMoveForCardHolderOnFirstLaunch = true;

  late GenerateSiteHashmapUseCase generateSiteHashmapUseCase;
  Map<LatLng, Site> siteHashmap = {};
  List<SiteLocation> siteLocationDisplayData = [];
  // TODO(Smeet): Cluster work.
  // late ApplyClusterUseCase applyClusterUseCase;
  final List<SiteMapMarker> clusterMarkers = [];
  // MarkerCluster<SiteMapMarker>? markerCluster;
  // final GridManager gridManager = GridManager(
  //   rowCount: 3,
  //   columnCount: 5,
  //   gridCellSize: 50,
  // );
  // ClusterManager? clusterManager;
  ClusterManager<SiteMapMarker>? clusterManager;
  final double densityThreshold = 10;
  late CalculateSitesLoadingProgressUseCase
      calculateSitesLoadingProgressUseCase;
  // late Timer? sitesLoadingPeriodicTimer;
  RxBool isSitesLoadingTimerInitiated = false.obs;

  List<FuelPreferences> fuelPreferencesList = [];
  late GetSelectedCardFuelPrefTypeUseCase getSelectedCardFuelPrefTypeUseCase;
  FuelPreferenceType selectedCardFuelPreferenceType = FuelPreferenceType.both;

  bool isComingFromRecenter = false;
  Predictions? selectedPlace;

  RxBool isShowSearchThisArea = false.obs;
  RxBool isLatLngBoundsChanged = false.obs;

  bool canShowFuelPricesApiErrorDialog = false;
  bool backFromSiteLocationsListView = false;
  List<SiteLocation>? rawSiteLocationsForFuelPricesApi = [];
  List<SiteLocation> rawSiteLocationsWithFuelPrice =
      []; // site locations with fuel prices

  RxBool isSiteInfoDrawerOpened = false.obs;
  double siteInfoDrawerSnapPoint = 0.43;
  RxBool tappedFromPinDrop = false.obs;
  bool isLocationEnabled = false;

  bool canMakeForceSitesApiCall = true;

  TargetPlatform? platform;

  RxBool lastTimeFetchedMCSites = false.obs;
  DefaultBrandLogos defaultBrandLogoAssetInstance = DefaultBrandLogos();
  RxBool hasToSwitchMCSites = false.obs;

  bool isLoginFromMapView = false;

  // Unauthenticated SL Channel
  RxBool isUnauthSLChannel = false.obs;
  bool isRecenterTap = false;

  // Getting ratings and miles
  RxBool ratingsApiInProgress = false.obs;
  RxBool getMilesInProgress = false.obs;
  RxMap<String, double> siteRatingCacheStore = <String, double>{}.obs;

  RxBool isListViewOpenedFull = false.obs;
  PanelController listViewPanelController = PanelController();
  int selectedListTabIndex = 0;
}
