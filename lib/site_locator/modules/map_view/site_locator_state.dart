part of map_view_module;

mixin SiteLocatorState {
  SiteLocationsService siteLocationsService = Get.find();
  SiteLocatorAccessTokenController siteLocatorAccessTokenController =
      Get.put(SiteLocatorAccessTokenController());
  final searchPlacesController = Get.put(SearchPlacesController());
  final FuelGaugeProgressController fuelGaugeProgressController = Get.find();
  CardholderSetupController cardholderSetupController = Get.find();

  RxDouble infoPanelInitialHeight = SiteLocatorConstants.panelWidgetHeight.obs;
  List<SiteLocation>? siteLocations = [];
  RxInt mapKeyValue = 1.obs;
  RxList<Site> siteList = <Site>[].obs;
  RxList<Marker> markers = <Marker>[].obs;
  double sitesRadiusInMeters = SiteLocatorConfig.defaultMapRadiusInMeters;
  double allowedSitesRadiusInMeters = MathUtil.milesToMeters(25);
  GoogleMapController? googleMapController;
  Rx<LatLngBounds> currentLatLngBounds = LatLngBounds(
    southwest: const LatLng(36.66, -119.93),
    northeast: const LatLng(36.9, -119.51),
  ).obs;
  LatLngBounds reCenterLatLngBounds = LatLngBounds(
    southwest: const LatLng(36.66, -119.93),
    northeast: const LatLng(36.9, -119.51),
  );

  double mapPadding = 20;
  double allowedMapZoomLevel = 9;
  double? currentZoomLevel;
  double? previousZoomLevel;

  double defaultCircleZoom = 12.5;
  RxDouble cameraPositionZoom = 12.5.obs;
  RxBool isUserActionZoomIn = false.obs;
  RxBool backFromWelcomeToMapView = false.obs;
  RxDouble lastZoomByUser = 12.5.obs;

  List<SiteLocation>? reCenterSiteLocations;

  RxBool isLocatorBottomNavTabPressed = false.obs;
  bool isUserAuthenticated = false;
  bool canClearSearchTextField = true;
  RxBool isShowLoading = false.obs;
  RxBool canShow2CTA = false.obs;
  bool isFirstLaunch = true;
  Rx<LatLng> currentLocation = SiteLocatorConstants.defaultUserLocation.obs;
  LatLng? _centerLatLng;
  bool isFetchSitesData = false;
  bool isClusterClick = false;
  bool isShowingErrorModal = false;
  bool isMapPinTapped = false;
  double staticBottomSpacing = 30;
  List<Marker> initialMarkersList = [];

  Map<String, dynamic> initialValuesMap = <String, dynamic>{};
  final PanelController locationPanelController = PanelController();
  final PanelController setUpWizardPanelController = PanelController();
  RxDouble infoPanelMinHeight = 0.0.obs;
  Rx<SiteLocation> selectedSiteLocation = SiteLocation.blank().obs;
  RxDouble floatingButtonsBottomPosition = 0.0.obs;

  RxBool gpsIconButtonVisible = true.obs;
  RxBool canShowFloatingMapButtons = true.obs;
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
  final _allEnhancedFilters =
      enhancedFilterData.map(EnhancedFilterModel.clone).toList();
  RxDouble expandRadiusCount = 1.0.obs;
  double safeAreaPadding = 0;

  // List view
  RxList<SiteLocation> listViewItems = RxList([]);
  RxInt presentPageIndex = 0.obs;
  RxInt perPageCount = 0.obs;
  int maxCountPerPage = 10;
  RxBool isInitialListLoading = false.obs;
  RxBool isViewMoreLoading = false.obs;

  final _filterSessionManager = SiteFilterSessionManager();

  String selectedMapPinKey = SiteLocatorConstants.resetCode;
  List<Marker> rawMarkersList = [];
  MarkerDetails? prevSelectedMarkerDetails;
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

  late GetTapOnMapLocationMessageUseCase getTapOnMapLocationMessageUseCase;
  late GetWelcomeScreenInfoUseCase getWelcomeScreenInfoUseCase;

  bool isGenerateMapPinsOnFiltering = false;
  bool positionStreamStarted = false;
  bool isMoveCameraCallingFromMapView = true;

  bool canRecenterMapViewOnLocationChange = true;
  LatLng prevUserCenterLocation = SiteLocatorConstants.defaultUserLocation;
  bool forceResetCanRecenterMapView = false;

  int expandRadiusButtonTapCount = 1;

  final locationCacheUtils = LocationCacheUtils();
  bool isFullMapViewFirstLaunch = true;

  late GetSitesUncachedFuelPriceUseCase getSitesUncachedFuelPriceUseCase;
  late UpdateSiteLocationsFuelPricesUseCase
      updateSiteLocationsFuelPricesUseCase;

  late ManageDieselSaleTypeUseCase manageDieselSaleTypeUseCase;
  late DieselPricesPackUseCase dieselPricesPackUseCase;
  late DisplayDieselPriceUseCase displayDieselPriceUseCase;

  bool canShowNoSiteLocationsErrorDialog = true;
  bool isExecuteCameraMoveForCardHolderOnFirstLaunch = true;

  late GenerateSiteHashmapUseCase generateSiteHashmapUseCase;
  late GenerateSiteLocationHashmapUseCase generateSiteLocationHashmapUseCase;
  late ApplyClusterUseCase applyClusterUseCase;
  Map<LatLng, Site> siteHashmap = {};
  Map<String, SiteLocation> siteLocationHashmap = {};
  final List<SiteLocation> siteLocationDisplayData = [];
  final List<MapMarker> clusterMarkers = [];
  MarkerCluster<MapMarker>? markerCluster;
  final GridManager gridManager = GridManager(
    rowCount: 3,
    columnCount: 5,
    gridCellSize: 50,
  );
  final double densityThreshold = 10;
  late CalculateFuelGaugeProgressUseCase calculateFuelGaugeProgressUseCase;
  late Timer? fuelGuageProgressTimer;
  RxBool isFuelGuageProgressTimerInitiated = false.obs;

  List<FuelPreferences> fuelPreferencesList = [];
  late GetFuelPreferencesUseCase getFuelPreferencesUseCase;
  late GetSelectedCardFuelPrefTypeUseCase getSelectedCardFuelPrefTypeUseCase;
  FuelPreferenceType selectedCardFuelPreferenceType = FuelPreferenceType.both;

  bool isComingFromRecenter = false;
}
