// ignore_for_file: avoid_bool_literals_in_conditional_expressions

part of map_view_module;

class SiteLocatorController extends GetxController with SiteLocatorState {
  StreamSubscription<Position>? locationStreamSubscription;

  @override
  void onInit() {
    super.onInit();
    _initUseCases();
    _initData();
    initiateTimers();
  }

  @override
  void onClose() {
    _cancelLoadingPeriodicTimer();
    super.onClose();
  }

  void initiateTimers() {
    isSitesLoadingTimerInitiated(true);
    sitesLoadingPeriodicTimer =
        Timer.periodic(const Duration(milliseconds: 1000), (t) {
      sitesLoadingPeriodicTimer = t;
      _cancelLoadingTimerOnSafeThreshold(getSitesLoadingProgress());
    });
  }

  void _cancelLoadingPeriodicTimer() {
    sitesLoadingPeriodicTimer?.cancel();
  }

  void fetchSitesScheduler() {
    const cronFormat =
        '${SitesLocationCacheConstants.thresholdMinute} ${SitesLocationCacheConstants.thresholdHour} * * *';
    Cron().schedule(Schedule.parse(cronFormat), () async {
      await getSiteLocationsData(forceApiCall: true);
    });
  }

  Future<void> _initData() async {
    if (SiteLocatorConfig.isDisplayMapEnabled) {
      fetchSitesScheduler();
      await subscribeToLocationStream();
      floatingButtonsBottomPosition(
        infoPanelMinHeight() + defaultPositionBottom,
      );
      debounce(
        currentLatLngBounds,
        (_) => onLatLngBoundsChange(),
        time: const Duration(
          seconds: SiteLocatorConstants.mapDebounceTimeInSeconds,
        ),
      );
    }
  }

  void _initUseCases() {
    siteLocatorRepository = Get.put(SiteLocatorRepositoryImpl(
      siteLocationsService: siteLocationsService,
    ));

    validateLastSavedCenterLocationUseCase =
        Get.put(ValidateLastSavedCenterLocationUseCase());
    calculateSitesLoadingProgressUseCase =
        Get.put(CalculateSitesLoadingProgressUseCase());
    filterSitesUseCase = Get.put(FilterSitesUseCase());
    updateMarkerIconUseCase = Get.put(UpdateMarkerIconUseCase());
    generateMarkersUseCase = Get.put(GenerateMarkersUseCase());
    retrieveFiltersFromSPUseCase = Get.put(RetrieveFiltersFromSPUseCase());
    applySiteFilterUseCase = Get.put(ApplySiteFilterUseCase());
    storeStringListIntoSPUseCase = Get.put(StoreStringListIntoSPUseCase());
    getStringListFromSPUseCase = Get.put(GetStringListFromSPUseCase());
    getSiteListFromSiteLocationsUseCase =
        Get.put(GetSiteListFromSiteLocationsUseCase());
    filterMarkersUseCase = Get.put(FilterMarkersUseCase());
    getUserLocationUseCase = Get.put(GetUserLocationUseCase());
    getAccessTokenForSitesUseCase = Get.put(GetAccessTokenForSitesUseCase());
    getLatLngForSelectedPlaceUseCase = Get.put(
      GetSelectedPlaceLatLngUseCase(siteLocationsService: siteLocationsService),
    );
    getLatLngForSelectedPlaceUseCase = Get.put(
      GetSelectedPlaceLatLngUseCase(siteLocationsService: siteLocationsService),
    );
    computeCircleRadiusUseCase = Get.put(ComputeCircleRadiusUseCase());
    getTapOnMapLocationMessageUseCase =
        Get.put(GetTapOnMapLocationMessageUseCase());
    getWelcomeScreenInfoUseCase = Get.put(GetWelcomeScreenInfoUseCase());
    getSitesUncachedFuelPriceUseCase =
        Get.put(GetSitesUncachedFuelPriceUseCase());
    updateSiteLocationsFuelPricesUseCase = Get.put(
      UpdateSiteLocationsFuelPricesUseCase(
          siteLocationsService: siteLocationsService,
          siteLocatorController: this),
    );
    manageDieselSaleTypeUseCase = Get.put(ManageDieselSaleTypeUseCase());
    dieselPricesPackUseCase = Get.put(DieselPricesPackUseCase());
    displayDieselPriceUseCase = Get.put(DisplayDieselPriceUseCase());
    applyClusterUseCase = Get.put(ApplyClusterUseCase());
    generateSiteHashmapUseCase = Get.put(GenerateSiteHashmapUseCase());
    generateSiteLocationHashmapUseCase =
        Get.put(GenerateSiteLocationHashmapUseCase());
    getFuelPreferencesUseCase = Get.put(
      GetFuelPreferencesUseCase(siteLocationsService: siteLocationsService),
    );
    getSelectedCardFuelPrefTypeUseCase = Get.put(
      GetSelectedCardFuelPrefTypeUseCase(),
    );
  }

  Future<void> subscribeToLocationStream() async {
    final permissionStatus = await Geolocator.checkPermission();
    if (permissionStatus == LocationPermission.always ||
        permissionStatus == LocationPermission.whileInUse) {
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: SiteLocatorConstants.updateLocationDistanceInMeters,
      );
      locationStreamSubscription =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((position) async {
        currentLocation(LatLng(position.latitude, position.longitude));
        await validateAndRecenterMapView();
      });
    }
  }

  Future<void> validateAndRecenterMapView() async {
    if (canRecenterMapViewOnLocationChange) {
      if (_distanceBetweenTwoLatLongs() >
          SiteLocatorConstants.thresholdDistanceForSitesUpdateInMeters) {
        await onReCenterButtonClicked();
        prevUserCenterLocation = currentLocation();
      }
    }
  }

  double getCircleRadius(double zoomValue) =>
      computeCircleRadiusUseCase.execute(zoomValue);

  Future<void> getCurrentUserLocation() async {
    currentLocation.value = await getUserLocationUseCase.execute();
    prevUserCenterLocation = currentLocation();
  }

  double _distanceBetweenTwoLatLongs() =>
      MapUtilities.distanceBetweenTwoLocation(
        prevUserCenterLocation,
        currentLocation(),
      );

  Future<void> checkAndRequestLocationPermission() async {
    final permissionStatus = PreferenceUtils.getBool(
      SiteLocatorConstants.isLocationPermissionStatusUpdated,
    );
    if (permissionStatus == null) {
      await Geolocator.requestPermission();
      await PreferenceUtils.setBool(
        SiteLocatorConstants.isLocationPermissionStatusUpdated,
        value: true,
      );
    } else if (GetPlatform.isWeb) {
      final LocationPermission locationPermission =
          await Geolocator.checkPermission();
      print('locationPermission: $locationPermission');
      if (locationPermission != LocationPermission.always &&
          locationPermission != LocationPermission.whileInUse) {
        // TODO(siva): revert back
        // unawaited(Get.dialog(
        //   EnableLocationServiceDialog(
        //       onUseMyLocation: () => onUseMyLocation(locationPermission)),
        //   barrierDismissible: false,
        // ));
      }
    }
    await subscribeToLocationStream();
  }

  Future<void> onUseMyLocation(LocationPermission locationPermission) async {
    Get.back();
    // if (locationPermission == LocationPermission.deniedForever) {
    //   // should enable service from web browser settings.
    // } else {
    await Geolocator.requestPermission();
    await subscribeToLocationStream();
    // }
  }

  Future<String> getAccessTokenForSites() async =>
      getAccessTokenForSitesUseCase.execute();

  Future<void> getSiteLocationsData({
    bool forceApiCall = false,
    bool updateLocationCache = false,
  }) async {
    try {
      final newCenterLocation = MapUtilities.latLngBoundCenter(
        southwest: currentLatLngBounds().southwest,
        northeast: currentLatLngBounds().northeast,
      );
      final fetchSitesFromRemote =
          await locationCacheUtils.shouldFetchSitesFromRemote(
        newCenterLocation,
        SiteLocatorConfig.defaultMapRadius,
      );

      /// check if we forcefully need to call API [forceApiCall]
      /// [fetchSitesFromRemote] is responsible for checking time and
      /// if [newCenterLocation] is within 1 mile of the stored cache location.
      if (forceApiCall || fetchSitesFromRemote) {
        setSitesLoadingProgress(SitesLoadingProgressProps.initialValue);
        await fetchSitesFromServer();
        if (updateLocationCache || isFirstLaunch) {
          await storeSiteDataInCache();
        }
      } else {
        if (allowGateKeeperToGetSiteLocationsData()) {
          setSitesLoadingProgress(SitesLoadingProgressProps.initialValue);
          feedRelayToSitesLoadingProgress();
          await getSitesDataFromCache();
        }
      }

      await handleSiteLocationResponse();
      if (isFirstLaunch) {
        await moveCameraPosition(currentLatLngBounds());
      }
      if (kIsWeb) {
        resetPrevSelectedMarkerStatus();
        unawaited(setListViewInitializers());
      }
      isFirstLaunch = false;
    } on Exception catch (e) {
      DynatraceUtils.logError(
        name: DynatraceErrorMessages.getSitesAPIErrorName,
        value: DynatraceErrorMessages.getSitesAPIErrorValue,
        reason: e.toString(),
      );
    }
  }

  bool allowGateKeeperToGetSiteLocationsData() =>
      getSitesLoadingProgress() == 0;

  Future<void> fetchSitesFromServer() async {
    try {
      final accessToken = await getAccessTokenForSites();
      final jsonData = getJsonBodyData();
      await getSitesData(jsonData, accessToken);
    } on Exception catch (e) {
      DynatraceUtils.logError(
        name: 'error in site locator controller fetching site data from api',
        value: e.toString(),
        reason: e.toString(),
      );
    }
  }

  Future<void> getSitesData(
      Map<String, dynamic> jsonData, String accessToken) async {
    filteredSiteLocationsList.clear();
    sitesLoadingProgressController.setFindingSiteLocationsMessage();
    initiateSitesLoadingProgressValue();
    siteLocations = await siteLocationsService.getSiteLocationsData(
      jsonData,
      headerQueryParams: accessToken,
    );
    relaySitesLoadingProgressValue(siteLocations);
  }

  void feedRelayToSitesLoadingProgress() {
    initiateSitesLoadingProgressValue();
    relaySitesLoadingProgressValue(siteLocations);
  }

  void setSitesLoadingProgress(double value) {
    sitesLoadingProgressController.progressValue(value);
  }

  double getSitesLoadingProgress() {
    return sitesLoadingProgressController.progressValue();
  }

  void toggleSitesLoadingIndicatorVisibility({required bool visible}) {
    sitesLoadingProgressController.canShowIndicator(visible);
  }

  bool getHastoShowSitesLoadingIndicator() {
    return sitesLoadingProgressController.canShowIndicator();
  }

  void hideSitesLoadingIndicator() {
    toggleSitesLoadingIndicatorVisibility(visible: false);
    setSitesLoadingProgress(0);
    sitesLoadingProgressController.resetMessage();
    _cancelLoadingPeriodicTimer();
  }

  void initiateSitesLoadingProgressValue() {
    isSitesLoadingTimerInitiated(true);
    Timer.periodic(
        Duration(milliseconds: SitesLoadingProgressProps.stepUpPeriodicTimer),
        (t) {
      sitesLoadingPeriodicTimer = t;
      stepUpSitesLoadingCyclicValue();
    });
  }

  void relaySitesLoadingProgressValue(List<SiteLocation>? siteLocations) {
    setSitesLoadingProgress(sitesLoadingProgressController.progressValue());
    final periodicInterval = SiteInfoUtils.getSitesLoadingPeriodicInterval(
        (siteLocations ?? []).length);
    Timer.periodic(Duration(milliseconds: periodicInterval), (t) {
      sitesLoadingPeriodicTimer = t;
      stepUpSitesLoadingCyclicValue();
    });
  }

  void stepUpSitesLoadingCyclicValue() {
    final param = CalculateSitesLoadingProgressParam(
      canShowLoading: isShowLoading(),
      previousValue: sitesLoadingProgressController.progressValue(),
    );
    final currentValue = calculateSitesLoadingProgressUseCase.execute(param);
    setSitesLoadingProgress(currentValue);
    if (!isShowLoading()) {
      _cancelLoadingPeriodicTimer();
    } else {
      _cancelLoadingTimerOnSafeThreshold(currentValue);
    }
  }

  void _cancelLoadingTimerOnSafeThreshold(double currentValue) {
    if (currentValue > SitesLoadingProgressProps.safeMaxValue) {
      _cancelLoadingPeriodicTimer();
    }
  }

  void resetSitesLoadingIndicatorProgressValue() {
    if (getSitesLoadingProgress() > 0) {
      setSitesLoadingProgress(100);
      Future.delayed(
          Duration(milliseconds: SitesLoadingProgressProps.toHideAfter),
          hideSitesLoadingIndicator);
    } else {
      hideSitesLoadingIndicator();
    }
    if (isSitesLoadingTimerInitiated()) {
      _cancelLoadingPeriodicTimer();
    }
    isShowLoading(false);
  }

  Future<void> updateSiteLocationsFuelPricesForComdata() async {
    await updateSiteLocationsFuelPricesUseCase.execute(
      UpdateSiteLocationsFuelPricesParams(
        siteLocations: siteLocations,
        isUserAuthenticated: isUserAuthenticated,
      ),
    );
  }

  Future<bool> storeSiteDataInCache() async {
    return locationCacheUtils.writeLocationCache(
      sites: siteLocations ?? [],
      centerLocation: currentLocation(),
      mapRadius: SiteLocatorConfig.defaultMapRadius,
    );
  }

  Future<void> getSitesDataFromCache() async {
    siteLocations = await locationCacheUtils.readLocationCache();
  }

  Future<void> handleSiteLocationResponse() async {
    if (siteLocations?.isNotEmpty ?? false) {
      siteLocations?.sort(sortByMilesApart);
      selectedSiteFilters = retrieveStoredFilters();

      await processSiteLocations(siteLocations ?? []);
      await validateSiteLocationWithFilters();
      //For comdata, getting fuel prices and merging into site locations.
      if (AppUtils.isComdata && !isWelcomeScreen) {
        await _getAndUpdateFuelPreferenceType();

        await updateSiteLocationsFuelPricesForComdata();
      }
      if (AppUtils.isComdata && isWelcomeScreen) {
        ManageCacheFuelPrices.setSelectedCardCustomerIdEmpty();
      }
    } else if (siteLocations != null &&
        siteLocations!.isEmpty &&
        inFullMapViewScreen) {
      _clearSiteListItemIfNecessary();
      showNoLocationsErrorDialog(SiteLocatorConstants.noLocationsErrorText);
    }
  }

  Future<void> _getAndUpdateFuelPreferenceType() async {
    fuelPreferencesList =
        await getFuelPreferencesUseCase.execute(GetFuelPreferencesParams(
      fuelPreferencesList,
      isUserAuthenticated: isUserAuthenticated,
    ));
    if (fuelPreferencesList.isNotEmpty) {
      selectedCardFuelPreferenceType =
          await getSelectedCardFuelPrefTypeUseCase.execute(
        GetSelectedCardFuelPrefTypeParams(
            fuelPreferencesList: fuelPreferencesList),
      );
    }
  }

  List<SiteFilter> retrieveStoredFilters() {
    return retrieveFiltersFromSPUseCase.execute(
      RetrieveFiltersFromSPParams(
        allEnhancedFilters: _allEnhancedFilters,
        requireFavorites: _filterSessionManager.isFavoriteFilterSelected,
      ),
    );
  }

  Future<void> validateSiteLocationWithFilters() async {
    filteredSiteLocationsList = applySiteFilterUseCase.execute(
      ApplyEnhancedFilterParams(
        siteLocations: siteLocations,
        selectedFilters: selectedSiteFilters,
        favoriteSites: favoriteList,
      ),
    );

    await _filterMapPins(filteredSiteLocationsList);
    await _updateListPageIfNecessary();
    _handleFilteredSitesData();
  }

  void _handleFilteredSitesData() {
    if (filteredSiteLocationsList.isEmpty && !(Get.isDialogOpen ?? false)) {
      if (expandRadiusButtonTapCount >
          SiteLocatorConstants.thresholdForShowingChangeFiltersDialog) {
        resetExpandRadiusButtonTapCount();
        showChangeFiltersDialog();
      } else {
        showNoMatchingLocationDialog();
      }
    }
    if (filteredSiteLocationsList.isNotEmpty) {
      resetExpandRadiusButtonTapCount();
    }
  }

  Future<void> processSiteLocations(
      List<SiteLocation> siteLocationsList) async {
    PinVariantStore.statusList = [];
    siteList(toSiteLocatorMap(siteLocationsList));

    if (isZoomLevelBelowThreshold) {
      final List<LatLng> sitesLatLngs = [];
      for (final siteLocation in siteLocationsList) {
        if (siteLocation.siteLatitude != null &&
            siteLocation.siteLongitude != null) {
          sitesLatLngs.add(
              LatLng(siteLocation.siteLatitude!, siteLocation.siteLongitude!));
        }
      }
      tempLatLngBounds = MapUtilities.getBoundsFromLatLngs(sitesLatLngs);
    }

    generateHashmapForCluster();
    await generateMapPinList();
  }

  Future<void> calcLatLngBoundsAndZoomLevels() async {
    currentLatLngBounds(
        MapUtilities.toBounds(currentLocation(), sitesRadiusInMeters));
    currentZoomLevel = await googleMapController?.getZoomLevel() ??
        SiteLocatorConfig.mapZoomLevel;
    cameraPositionZoom(currentZoomLevel);
    lastZoomByUser(currentZoomLevel);
    defaultCircleZoom = currentZoomLevel ?? 12.5;
    reCenterLatLngBounds = currentLatLngBounds();
  }

  void showNoLocationsErrorDialog(String locationsErrorMessage) {
    if (!canShowNoSiteLocationsErrorDialog) {
      canShowNoSiteLocationsErrorDialog = true;
      return;
    }
    final noLocationsErrorModalTimer = Timer(
        const Duration(seconds: SiteLocatorConstants.noLocationsErrorModalTime),
        () {
      isShowingErrorModal = false;
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    });

    if (!isShowingErrorModal) {
      isShowingErrorModal = true;
      trackState(AnalyticsScreenName.noLocationModalScreen);
      Get.dialog(
        NoLocationsDialog(errorMessage: locationsErrorMessage),
        barrierDismissible: true,
      ).then(
        (_) {
          noLocationsErrorModalTimer.cancel();
          isShowingErrorModal = false;
        },
      );
    }
  }

  Map<String, dynamic> getJsonBodyData() {
    final Map<String, dynamic> jsonData = {
      'bounds':
          '${currentLatLngBounds().southwest.latitude},${currentLatLngBounds().southwest.longitude},${currentLatLngBounds().northeast.latitude},${currentLatLngBounds().northeast.longitude}',
    };
    return SiteLocatorConfig.addQueryParams(jsonData);
  }

  // SiteLocator Full Map View and data conversion
  List<Site> toSiteLocatorMap(List<SiteLocation> siteLocations) {
    List<Site> siteMapList = [];
    if (siteLocations.isNotEmpty) {
      siteMapList = getSiteListFromSiteLocationsUseCase.execute(
        GetSiteListFromSiteLocationsParams(siteLocationsList: siteLocations),
      );
    }
    return siteMapList;
  }

  Future<bool> canMakeAPICallOnZoomGesture() async {
    final zoomLevel = await googleMapController?.getZoomLevel() ??
        SiteLocatorConfig.mapZoomLevel;
    previousZoomLevel ??= zoomLevel;
    final hasToMakeAPICall = zoomLevel < previousZoomLevel!;
    previousZoomLevel = zoomLevel;
    _getZoomInZoomOutTrackAction(hasToMakeAPICall);
    return hasToMakeAPICall;
  }

  LatLngBounds? tempLatLngBounds;
  bool get isZoomLevelBelowThreshold =>
      previousZoomLevel != null && previousZoomLevel! < 10.5;

  Future<void> onLatLngBoundsChange() async {
    try {
      /// tap on recenter,making camera move and executing this method.
      /// To avoid duplicate api calls, if its coming after recenter skipping.
      if (isComingFromRecenter) {
        isComingFromRecenter = false;
        return;
      }
      if (isFullMapViewFirstLaunch) {
        isFullMapViewFirstLaunch = false;
        return;
      }
      trackAction(
        AnalyticsTrackActionName.repositionEvent,
        // // adobeCustomTag: AdobeTagProperties.mapView,
      );
      if (!isClusterClick &&
          isFetchSitesData &&
          !isMapPinTapped &&
          searchPlacesController.searchText.isEmpty) {
        isShowLoading(true);
        resetMarkers(PinVariantStore.statusList);

        /// hasToCallOnZoomGesture is true then zoomed out
        /// hasToCallOnZoomGesture is false then zoomed in
        final hasToCallOnZoomGesture = await canMakeAPICallOnZoomGesture();

        final newCenterLocation = MapUtilities.latLngBoundCenter(
          southwest: currentLatLngBounds().southwest,
          northeast: currentLatLngBounds().northeast,
        );
        final isAwayFromLastSavedLocation =
            await validateLastSavedCenterLocationUseCase
                .execute(newCenterLocation);

        await applyClustering();

        if (allowGateKeeperToGetSiteLocationsData() &&
            !isZoomedWithinCurrentLatLngBounds()) {
          await getSiteLocationsData(
              updateLocationCache: !isAwayFromLastSavedLocation,
              forceApiCall: hasToCallOnZoomGesture);
        }
        isShowLoading(false);
      }
      isClusterClick = false;
      isFetchSitesData = true;
      isMapPinTapped = false;
    } catch (e) {
      isShowLoading(false);

      DynatraceUtils.logError(
        name: 'error in site locator controller bounds change',
        value: e.toString(),
        reason: e.toString(),
      );
    }
  }

  bool isZoomedWithinCurrentLatLngBounds() {
    bool zoomedWithinBounds = false;

    if (tempLatLngBounds == null) {
      tempLatLngBounds = currentLatLngBounds();
    } else {
      zoomedWithinBounds =
          currentLatLngBounds().isInside(outerBounds: tempLatLngBounds);
      if (!zoomedWithinBounds) {
        tempLatLngBounds = currentLatLngBounds();
      }
    }

    if (isZoomLevelBelowThreshold) {
      zoomedWithinBounds = false;
    }

    return zoomedWithinBounds;
  }

  Future<void> updateFullMapViewSitesData() async {
    await onReCenterButtonClicked();
  }

  Future<void> onReCenterButtonClicked() async {
    try {
      isComingFromRecenter = true;
      resetCircleAfterZoomOut();
      isFetchSitesData = false;
      isShowLoading(true);
      resetMapViewScreen();
      resetRadius();
      await updateCurrentLatLngBoundsOnReCenter();
      resetCircleAfterZoomIn();
      await getSiteLocationsData(updateLocationCache: true);
      isShowLoading(false);
      canClearSearchTextField = true;
      canRecenterMapViewOnLocationChange = true;
    } on Exception catch (e) {
      isShowLoading(false);

      DynatraceUtils.logError(
        name: 'error: on recenter button tap',
        value: e.toString(),
        reason: e.toString(),
      );
    }
  }

  Future<void> updateCurrentMapZoomLevel() async {
    if (googleMapController != null && currentZoomLevel == null) {
      currentZoomLevel = await googleMapController?.getZoomLevel() ??
          SiteLocatorConfig.mapZoomLevel;
    }
    previousZoomLevel = currentZoomLevel;
  }

  Future<void> updateCurrentLatLngBoundsOnReCenter() async {
    currentLocation.value = await getUserLocationUseCase.execute();
    await googleMapController?.moveCamera(
      CameraUpdate.newLatLngZoom(
        currentLocation(),
        currentZoomLevel ?? SiteLocatorConfig.mapZoomLevel,
      ),
    );
    currentLatLngBounds(await googleMapController?.getVisibleRegion());
  }

  void modifyCircleSize() {
    resetCircleAfterZoomIn();
    resetCircleAfterZoomOut();
  }

  void resetCircleAfterZoomOut() {
    if (cameraPositionZoom() < defaultCircleZoom) {
      cameraPositionZoom(defaultCircleZoom);
    }
  }

  void resetCircleAfterZoomIn() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (cameraPositionZoom() > defaultCircleZoom) {
        cameraPositionZoom(defaultCircleZoom);
      }
    });
  }

  void resetBackFromWelcomeToMapView() {
    Future.delayed(const Duration(milliseconds: 200), () {
      backFromWelcomeToMapView(false);
    });
  }

  void resetRadius() {
    expandRadiusCount(0);
    currentLatLngBounds(
      MapUtilities.toBounds(currentLocation(), sitesRadiusInMeters),
    );
  }

  void resetMapViewScreen() {
    SiteLocatorUtils.hideKeyboard();
    closeLocationInfoPanel();
    resetPrevSelectedMarkerStatus();
  }

  Future<void> moveCameraPosition(LatLngBounds newPosition) async {
    Future.delayed(
      const Duration(milliseconds: 200),
      () => googleMapController?.moveCamera(
        CameraUpdate.newLatLngBounds(newPosition, mapPadding),
      ),
    );
  }

  void clearSearchPlaceInput() {
    final searchPlacesController = Get.find<SearchPlacesController>();
    if (searchPlacesController.searchTextEditingController.text.isNotEmpty &&
        canClearSearchTextField) {
      searchPlacesController.clearTextInput();
    }
  }

  Future<void> onCameraIdle() async {
    isMoveCameraCallingFromMapView = true;
    await setCenterCoordinate();
  }

  Future<void> onCameraMove(CameraPosition cameraPosition) async {
    SiteLocatorUtils.hideKeyboard();

    if (!isExecuteCameraMoveForCardHolderOnFirstLaunch) {
      isExecuteCameraMoveForCardHolderOnFirstLaunch = true;
      return;
    }

    if (forceResetCanRecenterMapView) {
      canRecenterMapViewOnLocationChange = true;
    } else {
      canRecenterMapViewOnLocationChange = false;
    }
    forceResetCanRecenterMapView = false;
    if (!kIsWeb && Platform.isIOS) {
      if (backFromWelcomeToMapView()) {
        backFromWelcomeToMapView(false);
      } else {
        lastZoomByUser(cameraPosition.zoom);
        cameraPositionZoom(cameraPosition.zoom);
      }
    } else {
      lastZoomByUser(cameraPosition.zoom);
      cameraPositionZoom(cameraPosition.zoom);
    }

    if (isMoveCameraCallingFromMapView) {
      canClearSearchTextField = true;
    }
    clearSearchPlaceInput();
    isFetchSitesData = true;
    isMapPinTapped = false;
    currentLatLngBounds(await googleMapController?.getVisibleRegion());
  }

  Future<void> setCenterCoordinate() async {
    final visibleRegion = await googleMapController?.getVisibleRegion();

    if (visibleRegion != null) {
      _centerLatLng = LatLng(
        (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) /
            2,
        (visibleRegion.northeast.longitude +
                visibleRegion.southwest.longitude) /
            2,
      );
    }
  }

  Future<bool> generateMapPinList() async {
    final brandPinVariantList = await getPinVariantStatusList();
    PinVariantStore.statusList = brandPinVariantList;
    rawMarkersList =
        generateMarkerList(brandPinVariantList, SiteLocatorConstants.resetCode);

    if (welcomeScreenMarkers.isEmpty) {
      welcomeScreenMarkers.addAll(markers.toList());
    }
    return true;
  }

  List<Marker> generateMarkerList(
          List<MarkerDetails> detailsList, String selectedKey) =>
      generateMarkersUseCase.execute(
        GenerateMarkersParams(
          markerDetailsList: detailsList,
          selectedMapPinKey: selectedMapPinKey,
          onMarkerTap: onMarkerTap,
        ),
      );

  void resetMarkers(List<MarkerDetails> detailsList) {
    isBottomModalSheetOpened(false);
    selectedSiteLocation(SiteLocation.blank());
    closeLocationInfoPanel();
    resetPrevSelectedMarkerStatus();
    closeSiteLocatorMenuPanel();
  }

  Future<void> onMarkerTap(MarkerDetails item) async {
    try {
      trackAction(
        AnalyticsTrackActionName.locationPinClickedEvent,
        // // adobeCustomTag: AdobeTagProperties.mapView,
      );
      SiteLocatorUtils.hideKeyboard();
      closeSiteLocatorMenuPanel();
      await Future.delayed(const Duration(milliseconds: 1));
      isFetchSitesData = false;
      isMapPinTapped = true;

      selectedMapPinKey = item.site.id == selectedMapPinKey
          ? SiteLocatorConstants.resetCode
          : item.site.id;

      _deselectPrevMarker();
      _highlightSelectedMarker(item);
      prevSelectedMarkerDetails = item;
      markers.refresh();

      if (selectedMapPinKey == SiteLocatorConstants.resetCode) {
        closeLocationInfoPanel();
        clearSearchPlaceInput();
      } else {
        showOpacity(false);
        unawaited(setSelectedLocation(item.site.id)
            .then((_) => openLocationInfoPanel()));
      }
    } catch (e) {
      DynatraceUtils.logError(
        name: 'error occurred on marker tap',
        value: e.toString(),
        reason: e.toString(),
      );
    }
  }

  void _highlightSelectedMarker(MarkerDetails item) {
    if (selectedMapPinKey != SiteLocatorConstants.resetCode) {
      updateMapPinMarker(markers, item, isShowBigIcon: true);
    }
  }

  void _deselectPrevMarker() {
    if (prevSelectedMarkerDetails != null) {
      updateMapPinMarker(markers, prevSelectedMarkerDetails!);
    }
  }

  void updateMapPinMarker(
    RxList<Marker> markersList,
    MarkerDetails markerDetails, {
    bool isShowBigIcon = false,
  }) {
    updateMarkerIconUseCase.execute(
      UpdateMarkerIconParams(
        markersList: markersList,
        markerDetails: markerDetails,
        isShowBigIcon: isShowBigIcon,
      ),
    );
  }

  void resetPrevSelectedMarkerStatus() {
    selectedMapPinKey = SiteLocatorConstants.resetCode;
    _deselectPrevMarker();
    prevSelectedMarkerDetails = null;
  }

  Future<void> setSelectedLocation(String siteId) async {
    isBottomModalSheetOpened(false);
    final List<SiteLocation>? selectedLocation = siteLocations
        ?.where((item) => item.masterIdentifier == siteId)
        .toList();
    if (selectedLocation?.isNotEmpty ?? false) {
      setInfoPanelInitialHeight(selectedLocation?[0]);
      selectedSiteLocation(selectedLocation?[0]);
    } else {
      selectedSiteLocation(SiteLocation.blank());
    }
  }

  Future<List<MarkerDetails>> getPinVariantStatusList() async {
    return PinVariantStore.generateStore(siteList: siteList);
  }

/*  Site pin marker selection and show Site Location Info Panel */
  Future<void> openLocationInfoPanel(
      {SiteLocationInfoViewModes mode = SiteLocationInfoViewModes.half}) async {
    resetMilesDisplay();
    checkIsFavorite(selectedSiteLocation().siteIdentifier.toString());
    await getMiles(selectedSiteLocation()).then((_) {
      milesDisplay(displayMiles(selectedSiteLocation()));
    });
    infoPanelMinHeight(infoPanelInitialHeight());
    floatingButtonsBottomPosition(infoPanelMinHeight() + 10);
    showOpacity(true);
    showFullViewExtraData(false);
    setFloatingButtonsVisibility(buttonsVisibility: false);
  }

  Future<void> openSiteInfoFullView(SiteLocation siteLocation) async {
    isShownRemainingFullSiteInfo(true);
    isSiteInfoFullViewed(true);
    showFullViewExtraData(true);
    selectedSiteLocation(siteLocation);

    await getMiles(selectedSiteLocation()).then((_) {
      milesDisplay(displayMiles(selectedSiteLocation()));
    });
    setFloatingButtonsVisibility(buttonsVisibility: false);
    unawaited(locationPanelController.open());
  }

  void mapFullViewInitStatus() {
    clearMilesCachedData();
    isBottomModalSheetOpened(false);
    showOpacity(false);
    slideDownClosingLocationInfoPanel();
  }

  void closeLocationInfoPanel(
      {SiteLocationInfoViewModes mode = SiteLocationInfoViewModes.half}) {
    if (!isBottomModalSheetOpened()) {
      showOpacity(false);
      infoPanelMinHeight(0);
      floatingButtonsBottomPosition(infoPanelMinHeight() + staticBottomSpacing);
      isSiteInfoFullViewed(false);
      setFloatingButtonsVisibility(buttonsVisibility: true);
    }
  }

  void slideDownClosingLocationInfoPanel(
      {SiteLocationInfoViewModes mode = SiteLocationInfoViewModes.half}) {
    if (!isBottomModalSheetOpened()) {
      infoPanelMinHeight(0);
      floatingButtonsBottomPosition(infoPanelMinHeight() + staticBottomSpacing);
      showOpacity(false);
      isSiteInfoFullViewed(false);
      resetPrevSelectedMarkerStatus();
      setFloatingButtonsVisibility(buttonsVisibility: true);
    }
  }

/* Distance matrix methods and logic starts */

  void resetMilesDisplay() => milesDisplay('');

  String displayMiles(SiteLocation siteLocation) {
    const milesUnit = SiteLocatorConstants.milesUnit;
    if (siteLocation.siteLatitude != null &&
        siteLocation.siteLongitude != null) {
      final latLngKey = formatLatLngKey(
          siteLocation.siteLatitude!, siteLocation.siteLongitude!);
      final double? miles = milesDataCache[latLngKey];
      return miles != null && miles != -1 ? '$miles $milesUnit' : '';
    }
    return '';
  }

  Future<double> getMiles(SiteLocation siteLocation) async {
    double milesToReturn = -1;
    if (siteLocation.siteLatitude != null &&
        siteLocation.siteLongitude != null) {
      final latLngKey = formatLatLngKey(
          siteLocation.siteLatitude!, siteLocation.siteLongitude!);
      final miles = milesDataCache[latLngKey];
      if (miles != null && miles != -1) {
        milesToReturn = miles;
      } else {
        await cachingDrivingDistance([siteLocation]);
        final double? miles = milesDataCache[latLngKey];
        milesToReturn = miles ?? -1;
      }
    }
    return milesToReturn;
  }

  List<String> getLangList(List<SiteLocation> siteLocations) {
    final latLngList = <String>[];
    for (int i = 0; i < siteLocations.length; i++) {
      final location = siteLocations[i];
      if (location.siteLatitude != null && location.siteLongitude != null) {
        latLngList.add(
            formatLatLngKey(location.siteLatitude!, location.siteLongitude!));
      }
    }
    return latLngList;
  }

  Future<void> cachingDrivingDistance(List<SiteLocation> siteLocations) async {
    final latLngList = getLangList(siteLocations);
    final slicedLatLng =
        sliceLatLngCount(latLngList, count: latLngList.length > 10 ? 10 : null);
    final destinationsParamValues = formatLatLngParams(latLngList);
    final originsParamValue = formatLatLngKey(
      currentLocation().latitude,
      currentLocation().longitude,
    );
    final qs =
        'destinations=$destinationsParamValues&origins=$originsParamValue';
    final distanceMatrixUrl = '${ApiConstants.distanceMatrixGoogleUrl}&$qs';
    final distanceMatrix = await fetchDistanceData(distanceMatrixUrl);
    if (distanceMatrix != null) {
      await processMilesCache(slicedLatLng, distanceMatrix);
    }
    isInitialListLoading(false);
    isViewMoreLoading(false);
  }

  Future<void> processMilesCache(
      List<String> slicedLatLng, DistanceMatrix? distanceMatrix) async {
    final Map<String, double> milesDataMap = milesDataCache();
    for (int keyIndex = 0; keyIndex < slicedLatLng.length; keyIndex++) {
      final latLngListKey = slicedLatLng[keyIndex];
      if (keyIndex < (distanceMatrix?.distanceList?.length ?? 0)) {
        final status = distanceMatrix?.distanceList?[keyIndex].status;
        if (status == APIReturnStatus.ok) {
          final key = latLngListKey;
          final double mile =
              distanceMatrix?.distanceList?[keyIndex].miles ?? -1.0;
          milesDataMap.putIfAbsent(key, () => mile);
        }
      }
    }
    milesDataCache(milesDataMap);
  }

  Future<DistanceMatrix?> fetchDistanceData(String distanceMatrixUrl) async =>
      siteLocationsService.fetchDistanceData(distanceMatrixUrl);

  String formatLatLngParams(List<String> latlngList) =>
      sliceLatLngCount(latlngList).join('|');

  List<String> sliceLatLngCount(List<String> latlngList, {int? count}) {
    final int countToSlice = count ?? 10;
    return (latlngList.length <= 10)
        ? count != null
            ? latlngList.sublist(0, count)
            : latlngList
        : latlngList.sublist(0, countToSlice);
  }

  String formatLatLngKey(double lat, double lng) => '$lat,$lng';

  String formatMilesStoreKey(SiteLocation? site) =>
      '${site?.siteLatitude},${site?.siteLongitude}';

  void clearMilesCachedData() => milesDataCache({});

/* Distance matrix methods and logic ends */

  @override
  void dispose() {
    super.dispose();
    googleMapController?.dispose();
    locationStreamSubscription?.cancel();
  }

  void setInfoPanelInitialHeight(SiteLocation? selectedLocation) {
    infoPanelInitialHeight.value = 0;
    if (!isLocationPresent(selectedLocation) &&
        !isPhoneMaintenancePresent(selectedLocation)) {
      infoPanelInitialHeight(SiteLocatorConstants.panelWidgetHeight -
          SiteLocatorConstants.phoneMaintenanceWidgetHeight -
          SiteLocatorConstants.phoneMaintenanceWidgetHeight);
    } else if (!isLocationPresent(selectedLocation)) {
      infoPanelInitialHeight(SiteLocatorConstants.panelWidgetHeight -
          SiteLocatorConstants.locationNameWidgetHeight);
    } else if (!isPhoneMaintenancePresent(selectedLocation)) {
      infoPanelInitialHeight(SiteLocatorConstants.panelWidgetHeight -
          SiteLocatorConstants.phoneMaintenanceWidgetHeight);
    } else {
      infoPanelInitialHeight(SiteLocatorConstants.panelWidgetHeight);
    }
  }

  bool isLocationPresent(SiteLocation? selectedLocation) {
    return selectedLocation?.fuelBrand != null &&
        selectedLocation?.fuelBrand != SiteLocatorConstants.unbranded;
  }

  bool isPhoneMaintenancePresent(SiteLocation? selectedLocation) {
    return !(selectedLocation?.locationPhone == null &&
        selectedLocation?.locationType?.maintenanceService == Status.N);
  }

  void checkIsFavorite(String id) => isSiteFavorite(favoriteList.contains(id));

  Future<void> manageFavorite(String id) async {
    if (favoriteList.contains(id)) {
      if (Get.currentRoute == SiteLocatorRoutes.siteLocationsListView) {
        trackAction(
          AnalyticsTrackActionName.listViewRemoveFromFavoritesLinkClickEvent,
          // // adobeCustomTag: AdobeTagProperties.listView,
        );
      } else {
        trackAction(
          AnalyticsTrackActionName
              .siteInfoDrawerRemoveFromFavoritesLinkClickEvent,
          // // adobeCustomTag: AdobeTagProperties.siteInfo,
        );
      }

      favoriteList.remove(id);
      isSiteFavorite(false);
    } else {
      if (Get.currentRoute == SiteLocatorRoutes.siteLocationsListView) {
        trackAction(
          AnalyticsTrackActionName.listViewAddToFavoritesLinkClickEvent,
          // // adobeCustomTag: AdobeTagProperties.listView,
        );
      } else {
        trackAction(
          AnalyticsTrackActionName.siteInfoDrawerAddToFavoritesLinkClickEvent,
          // // adobeCustomTag: AdobeTagProperties.siteInfo,
        );
      }

      favoriteList.add(id);
      isSiteFavorite(true);
    }

    await updateFavoriteList(favoriteList);
  }

  List<String> getFavoriteList() => favoriteList(PreferenceUtils.getStringList(
      SiteLocatorConstants.favoriteSiteListStorageKey,
      defaultValue: []));

  Future<void> updateFavoriteList(List<String> favoriteList) async =>
      PreferenceUtils.setStringList(
        SiteLocatorConstants.favoriteSiteListStorageKey,
        value: favoriteList,
      );

  Future<void> filterSiteLocations() async {
    try {
      isShowLoading(true);
      isInitialListLoading(true);
      if (siteLocations?.isNotEmpty ?? false) {
        await validateSiteLocationWithFilters();
      }
      isShowLoading(false);
      isInitialListLoading(false);
    } on Exception catch (e) {
      isShowLoading(false);

      DynatraceUtils.logError(
        name: 'error while filter site locations',
        value: e.toString(),
        reason: e.toString(),
      );
    }
  }

  Future<void> _filterMapPins(
    List<SiteLocation> filteredSiteLocationsList,
  ) async {
    if (isGenerateMapPinsOnFiltering) {
      await processSiteLocations(siteLocations ?? []);
      isGenerateMapPinsOnFiltering = false;
    }

    final markersWithoutCluster = await filterMarkers(
      rawMarkersList,
      filteredSiteLocationsList,
    );
    await _generateClusterData(markersWithoutCluster);
  }

  Future<List<Marker>> filterMarkers(List<Marker> rawMarkersList,
          List<SiteLocation> filteredSiteLocationsList) async =>
      filterMarkersUseCase.execute(
        FilterMarkersParams(
          rawMarkersList: rawMarkersList,
          filteredSiteLocationsList: filteredSiteLocationsList,
        ),
      );

  /// ** LIST VIEW METHODS */

  int sortByMilesApart(SiteLocation a, SiteLocation b) {
    final aMilesApart = a.milesApart ?? 0;
    final bMilesApart = b.milesApart ?? 0;

    return aMilesApart.compareTo(bMilesApart);
  }

  Future<void> fetchNextSetDrivingDistance(
      List<SiteLocation> siteLocations) async {
    isViewMoreLoading(true);
    await cachingDrivingDistance(siteLocations);
  }

  Future<void> setListViewInitializers() async {
    isInitialListLoading(true);
    listViewItems().clear();
    final List<SiteLocation> originalItems = getSiteLocationsForListView();
    originalItems.sort(sortByMilesApart);
    presentPageIndex(0);
    perPageCount(originalItems.length > maxCountPerPage
        ? maxCountPerPage
        : originalItems.length);
    final nextSet = originalItems.getRange(
        presentPageIndex(), presentPageIndex() + perPageCount());
    if (!kIsWeb) {
      // TODO: Smeet - remove if condition later.
      await fetchNextSetDrivingDistance(nextSet.toList());
    }
    listViewItems.addAll(nextSet);
    presentPageIndex(presentPageIndex() + perPageCount());
    isInitialListLoading(false);
  }

  bool canFireListViewScrollHandler(ScrollController listScrollcontroller) =>
      (listScrollcontroller.hasClients)
          ? listScrollcontroller.offset >=
                  listScrollcontroller.position.maxScrollExtent &&
              loadMoreSitesOnScroll()
          : false;

  bool canFireListViewShowMorelHandler() {
    final List<SiteLocation> originalItems = getSiteLocationsForListView();
    final originalItemsCount = originalItems.length;
    final oddSitesCount = originalItemsCount - presentPageIndex();
    return !oddSitesCount.isNegative && loadMoreSitesOnScroll();
  }

  void listViewScrollHandler(ScrollController listScrollcontroller) {
    if (canFireListViewScrollHandler(listScrollcontroller) &&
        canFireListViewShowMorelHandler()) {
      listViewShowMoreHandler();
    }
  }

  int getNextListEndRange() {
    final List<SiteLocation> originalItems = getSiteLocationsForListView();
    final originalItemsCount = originalItems.length;
    int endRange = presentPageIndex();
    final tempCount = originalItemsCount - presentPageIndex();
    if (tempCount > perPageCount()) {
      endRange = presentPageIndex() + perPageCount();
    } else {
      endRange = originalItemsCount;
    }
    return endRange;
  }

  Future<void> listViewShowMoreHandler() async {
    if (loadMoreSitesOnScroll()) {
      trackAction(
        AnalyticsTrackActionName.listViewViewMoreSitesLinkClickEvent,
        // // adobeCustomTag: AdobeTagProperties.listView,
      );

      final List<SiteLocation> originalItems = getSiteLocationsForListView();
      final nextEndRange = getNextListEndRange();
      final nextSet = originalItems.getRange(presentPageIndex(), nextEndRange);
      loadMoreSitesOnScroll(false);
      await fetchNextSetDrivingDistance(nextSet.toList());
      listViewItems.addAll(nextSet);
      presentPageIndex(presentPageIndex() + perPageCount());
      isViewMoreLoading(false);
      loadMoreSitesOnScroll(true);
    }
  }

  List<SiteLocation> getSiteLocationsForListView() => List.from(
        selectedSiteFilters.isNotEmpty
            ? filteredSiteLocationsList
            : siteLocations ?? <SiteLocation>[],
      );

  void showNoMatchingLocationDialog() {
    isFetchSitesData = false;
    if (isWelcomeScreen) {
      return;
    }
    closeSiteLocatorMenuPanel();
    if (canShowEnhancedNoLocationDialog()) {
      trackState(AnalyticsScreenName.noLocationModalScreen);
      Get.dialog(
        EnhancedNoLocationDialog(),
        barrierDismissible: false,
      );
    }
  }

  bool canShowEnhancedNoLocationDialog() {
    final canShowFlag = Get.currentRoute ==
            SiteLocatorRoutes.siteLocatorMapView ||
        Get.currentRoute == SiteLocatorRoutes.siteLocationsListView ||
        // Get.currentRoute == SiteLocatorRoutes.cardholderSiteLocatorMapPage ||
        // (Get.currentRoute == SiteLocatorRoutes.dashboard &&
        isUserAuthenticated ||
        (isUserAuthenticated && isLocatorBottomNavTabPressed());
    return canShowFlag;
  }

  void setBottomNavTab({required bool isLocatorTabPressed}) {
    isLocatorBottomNavTabPressed(isLocatorTabPressed);
  }

  void showChangeFiltersDialog() {
    isFetchSitesData = false;
    if (isWelcomeScreen) {
      return;
    }
    closeSiteLocatorMenuPanel();

    Get.dialog(
      ChangeFiltersDialog(),
      barrierDismissible: false,
    );
  }

  Future<void> expandSearchRadius() async {
    try {
      trackAction(
        AnalyticsTrackActionName.noLocationModalExpandSearchEvent,
        // // adobeCustomTag: AdobeTagProperties.modals,
      );
      isFetchSitesData = false;
      incrementExpandRadiusButtonTapCount();
      Get.back();
      feedRelayToSitesLoadingProgress();
      isShowLoading(true);
      isInitialListLoading(true);
      final calculatedLatLngBounds = MapUtilities.toBounds(
        centerLatLng,
        increaseMilesInMeter(),
      );
      await googleMapController?.moveCamera(
        CameraUpdate.newLatLngBounds(calculatedLatLngBounds, mapPadding),
      );

      final latLngBounds = await googleMapController?.getVisibleRegion();

      if (latLngBounds != null) {
        currentLatLngBounds(latLngBounds);
      }

      await getSiteLocationsData(forceApiCall: true);
      await _updateListPageIfNecessary();
      modifyCircleSize();
      isShowLoading(false);
      isInitialListLoading(false);
    } on Exception catch (e) {
      isShowLoading(false);

      DynatraceUtils.logError(
        name: 'error while expand search radius',
        value: e.toString(),
        reason: e.toString(),
      );
    }
  }

  void incrementExpandRadiusButtonTapCount() => expandRadiusButtonTapCount += 1;

  void resetExpandRadiusButtonTapCount() => expandRadiusButtonTapCount = 1;

  LatLng get centerLatLng =>
      _centerLatLng != null ? _centerLatLng! : currentLocation();

  double increaseMilesInMeter() {
    expandRadiusCount(expandRadiusCount() + 1);
    final additionalRadius = SiteLocatorConstants.incrementMiles *
        expandRadiusCount() *
        SiteLocatorConstants.mileToMeterConvertUnit;
    return additionalRadius + sitesRadiusInMeters;
  }

  void onCancelTap() => Get.back();

  Future<void> searchedLocationWithBounds(
      {required LatLng searchPlaceLatLng}) async {
    isFetchSitesData = false;
    previousZoomLevel = currentZoomLevel;
    currentLatLngBounds(MapUtilities.toBounds(
      searchPlaceLatLng,
      sitesRadiusInMeters,
    ));
    isMoveCameraCallingFromMapView = false;
    await moveCameraPosition(currentLatLngBounds());
    await getSiteLocationsData();
  }

  /// This default handler will take care of only closing the view.
  void onPanelSlideEventHandler(double pos) {
    if (_isPanelOpenedToFullView(pos)) {
      _setFullViewStatus();
    }
    if (_isPanelDraggedDownToClose(pos)) {
      _setClosedStatus();
    } else {
      showOpacity(true);
    }
  }

  bool _isPanelOpenedToFullView(double pos) =>
      locationPanelController.isPanelOpen ||
      (!locationPanelController.isPanelOpen && pos > 0.6);

  void _setFullViewStatus() {
    trackAction(
      AnalyticsTrackActionName.siteInfoDrawerSlideToFullScreenEvent,
      // // adobeCustomTag: AdobeTagProperties.siteInfo,
    );
    isShownRemainingFullSiteInfo(true);
    isSiteInfoFullViewed(true);
    showFullViewExtraData(true);
  }

  bool _isPanelDraggedDownToClose(double pos) =>
      isSiteInfoFullViewed() && pos < 0.45;

  void _setClosedStatus() {
    showOpacity(false);
    showFullViewExtraData(false);
    slideDownClosingLocationInfoPanel();
  }

  void setFloatingButtonsVisibility({bool? buttonsVisibility}) {
    if (buttonsVisibility != null) {
      gpsIconButtonVisible(buttonsVisibility);
      canShowFloatingMapButtons(buttonsVisibility);
    }
  }

  Future<dynamic> getLatLngForSelectedPlace(
      Predictions selectedPlaceDetails) async {
    canRecenterMapViewOnLocationChange = false;
    canClearSearchTextField = false;
    Get.back(result: selectedPlaceDetails);
    isShowLoading(true);
    isInitialListLoading(true);
    try {
      final placeLatLng = await getLatLngForSelectedPlaceUseCase
          .execute(GetLatLngForSelectedPlaceUseCaseParams(
        SiteLocatorApiConstants.googleGeoCodingUrl,
        selectedPlaceDetails.placeId ?? '',
      ));
      final LatLng searchPlaceLatLng = LatLng(
        placeLatLng!.results!.first.geometry!.location!.lat!,
        placeLatLng.results!.first.geometry!.location!.lng!,
      );
      await searchedLocationWithBounds(
        searchPlaceLatLng: searchPlaceLatLng,
      );
      await _updateListPageIfNecessary();
    } catch (_) {
      isShowLoading(false);

      DynatraceUtils.logError(
        name: DynatraceErrorMessages.geoCodingAPIErrorName,
        value: DynatraceErrorMessages.geoCodingAPIErrorValue,
      );
    }
    isShowLoading(false);
    isInitialListLoading(false);
  }

  double getMapHeight(BuildContext context) => isUserAuthenticated
      ? MediaQuery.of(context).size.height -
          DrivenSiteLocator.instance.getBottomNavBarHeight() -
          safeAreaPadding
      : MediaQuery.of(context).size.height;

  double panelMaxHeight(BuildContext context) {
    final deviceMedia = MediaQuery.of(context);
    final deviceEdgePadding = _isAuthenticatedMapView
        ? DrivenSiteLocator.instance.getBottomNavBarHeight() +
            deviceMedia.padding.top
        : deviceMedia.padding.top;
    final deviceHeight = deviceMedia.size.height;
    return deviceHeight - deviceEdgePadding;
  }

  bool get _isAuthenticatedMapView => isUserAuthenticated;

  double get lastZoomComputed => lastZoomByUser();

  Future<void> navToNextPageOnMapViewTap() async {
    trackMapClick();
    trackState(AnalyticsScreenName.mapviewScreen);
    isUserAuthenticated = false;
    if (canShowCardholderSetup()) {
      SiteLocatorNavigation.instance.cardholderSetupPageOne();
    } else {
      await navigateToSiteLocatorMapViewPage();
    }
  }

  Future<void> navigateToSiteLocatorMapViewPage() async {
    isMoveCameraCallingFromMapView = false;
    mapFullViewInitStatus();
    isShowBackButton = true;
    safeAreaPadding = 0;

    cameraPositionZoom(lastZoomByUser());

    await Get.toNamed(
      SiteLocatorRoutes.siteLocatorMapView,
      arguments: {'currentUserLocation': currentLocation},
    )?.then(
      (_) async {
        await onReCenterButtonClicked();
      },
    );
  }

  void navigateToCardholderSetupOrMapPage() {
    if (canShowCardholderSetup()) {
      SiteLocatorNavigation.instance.cardholderSetupPageOne();
    } else {
      DrivenSiteLocator.instance.navigateToCardholderSiteLocatorMap?.call();
    }
  }

  bool canShowCardholderSetup() => cardholderSetupController.checkToShowSetup();

  void navigateToCardholderSiteLocatorMap() {
    trackWalletSiteLocatorClick();
    navigateToCardholderSetupOrMapPage();
  }

  Future<void> onMapViewTap() async {
    if (isWelcomeScreen) {
      await navToNextPageOnMapViewTap();
    } else {
      navigateToCardholderSiteLocatorMap();
    }
  }

  void navigateToEnhancedFilter() {
    resetMapViewScreen();
    clearSearchPlaceInput();

    (Get.toNamed(SiteLocatorRoutes.enhancedFilterPage))?.then((data) {
      try {
        if (data[SiteLocatorRouteArguments.enhancedFilterClearStatus]) {
          filterSiteLocations();
        }
      } catch (_) {}
    });
  }

  Future<void> _updateListPageIfNecessary() async {
    if (Get.currentRoute == SiteLocatorRoutes.siteLocationsListView) {
      await setListViewInitializers();
    }
  }

  void _clearSiteListItemIfNecessary() {
    if (Get.currentRoute == SiteLocatorRoutes.siteLocationsListView) {
      listViewItems.clear();
    }
  }

  bool get isWelcomeScreen => DrivenSiteLocator.instance.getIsWelcomeScreen();

  // TODO(Smeet): check implementation.
  bool get inFullMapViewScreen =>
      Get.currentRoute == SiteLocatorRoutes.siteLocatorMapView ||
      DrivenSiteLocator.instance.getIsCardholderFullMapScreen();

  void closeSiteLocatorMenuPanel() {
    if (menuPanelController.isAttached) {
      menuPanelController.close();
    }
  }

  Future<void> recenterMapOnLocationChange() async {
    if (canRecenterMapViewOnLocationChange) {
      forceResetCanRecenterMapView = true;
      await onReCenterButtonClicked();
    }
  }

  Future<void> onMapViewResume() async {
    _resetSiteInfoSlideUpPanelOnAppResume();
    await recenterMapOnLocationChange();
  }

  void _resetSiteInfoSlideUpPanelOnAppResume() {
    if (infoPanelMinHeight() > 0 && !isSiteInfoFullViewed()) {
      final offset = Offset(Get.width / 2, Get.height - 100);
      isShowLoading(true);
      GestureBinding.instance.handlePointerEvent(
        PointerDownEvent(position: offset),
      );
      GestureBinding.instance.handlePointerEvent(
        PointerUpEvent(position: offset),
      );
      isShowLoading(false);
    }
  }

  void show2CTAButton({bool? show2CTA}) {
    if (retrieveStoredFilters().isNotEmpty &&
        filteredSiteLocationsList.isEmpty &&
        !isShowLoading()) {
      if (show2CTA != null) {
        canShow2CTA(show2CTA);
        showNoMatchingLocationDialog();
      }
    }
  }

  Future<void> getInitialPageLoadData() async {
    try {
      isUserAuthenticated = false;
      isShowLoading(true);
      getFavoriteList();
      await checkAndRequestLocationPermission();
      await _getUserLocation();
      await calcLatLngBoundsAndZoomLevels();
      await getSiteLocationsData();
      isShowLoading(false);
    } on Exception catch (e) {
      isShowLoading(false);

      DynatraceUtils.logError(
        name: 'Error in site locator controller at initial load data',
        value: e.toString(),
        reason: e.toString(),
      );
    }
  }

  Future<void> _getUserLocation() async {
    try {
      await getCurrentUserLocation();
    } catch (_) {
      isShowLoading(false);
    }
  }

  Future<void> onListViewButtonTap() async {
    if (isShowLoading()) {
      return;
    }
    getListViewTapTrackAction();
    SiteLocatorUtils.hideKeyboard();
    closeLocationInfoPanel();
    clearSearchPlaceInput();
    resetPrevSelectedMarkerStatus();
    unawaited(setListViewInitializers());
    await Get.toNamed(SiteLocatorRoutes.siteLocationsListView);
  }

  void filterButtonTap() {
    if (isShowLoading()) {
      return;
    }
    getFilterTapTrackAction();
    navigateToEnhancedFilter();
  }

  Future<void> updateSitesWithFuelPricesOnWalletCardChange() async {
    isShowLoading(true);
    selectedCardFuelPreferenceType =
        await getSelectedCardFuelPrefTypeUseCase.execute(
      GetSelectedCardFuelPrefTypeParams(
          fuelPreferencesList: fuelPreferencesList),
    );
    await handleSiteLocationResponse();
    isShowLoading(false);
  }

  void _getZoomInZoomOutTrackAction(bool hasToMakeAPICall) {
    if (hasToMakeAPICall) {
      trackAction(
        AnalyticsTrackActionName.mapZoomOutEvent,
        // // adobeCustomTag: AdobeTagProperties.mapView,
      );
    } else {
      trackAction(
        AnalyticsTrackActionName.mapZoomInEvent,
        // // adobeCustomTag: AdobeTagProperties.mapView,
      );
    }
  }

  void getFilterTapTrackAction() {
    trackAction(
      AnalyticsTrackActionName.filtersButtonClickedEvent,
      // // adobeCustomTag: AdobeTagProperties.mapView,
    );
  }

  void getListViewTapTrackAction() {
    trackAction(
      AnalyticsTrackActionName.listviewButtonsClickedEvent,
      // // adobeCustomTag: AdobeTagProperties.mapView,
    );
  }

  void getNoLocationModalCancelClickTrackAction() {
    trackAction(
      AnalyticsTrackActionName.noLocationModalCancelLinkClickEvent,
      // adobeCustomTag: AdobeTagProperties.modals,
    );
  }

  void getNoLocationModalClearNewFilterClickTrackAction() {
    trackAction(
      AnalyticsTrackActionName.noLocationModalClearNewFilterLinkClickEvent,
      // adobeCustomTag: AdobeTagProperties.modals,
    );
  }

  void getListViewDetailsLinkClickTrackAction() {
    trackAction(
      AnalyticsTrackActionName.listViewDetailsLinkClickEvent,
      // adobeCustomTag: AdobeTagProperties.listView,
    );
  }

  void getListViewDirectionsLinkClickTrackAction() {
    trackAction(
      AnalyticsTrackActionName.listViewDirectionsLinkClickEvent,
      // adobeCustomTag: AdobeTagProperties.listView,
    );
  }

  void getListViewFilterClickTrackAction() {
    trackAction(
      AnalyticsTrackActionName.listViewFiltersButtonClickEvent,
      // adobeCustomTag: AdobeTagProperties.listView,
    );
  }

  void getSearchTrackAction() {
    if (Get.currentRoute == SiteLocatorRoutes.siteLocationsListView) {
      trackAction(
        AnalyticsTrackActionName.listViewScreenExecuteSearchEvent,
        // adobeCustomTag: AdobeTagProperties.listView,
      );
    } else {
      trackAction(
        AnalyticsTrackActionName.executeSearchEvent,
        // adobeCustomTag: AdobeTagProperties.mapView,
      );
    }
  }

  void getSiteInfoDrawerCallButtonClickTrackAction() {
    trackAction(
      AnalyticsTrackActionName.siteInfoDrawerCallButtonLinkClickEvent,
      // adobeCustomTag: AdobeTagProperties.siteInfo,
    );
  }

  void getSiteInfoDrawerDirectionsButtonClickTrackAction() {
    trackAction(
      AnalyticsTrackActionName.siteInfoDrawerDirectionsButtonLinkClickEvent,
      // adobeCustomTag: AdobeTagProperties.siteInfo,
    );
  }

  void trackMapClick() => trackAction(
        AnalyticsTrackActionName.mapClick,
        // adobeCustomTag: AdobeTagProperties.welcome,
      );

  void trackWalletSiteLocatorClick() =>
      trackAction(AnalyticsTrackActionName.walletSiteLocatorClick);

  List<SiteLocation>? loadLocalSiteLocationsList(List<dynamic> data) {
    final value = <SiteLocation>[];
    for (final element in data) {
      value.add(SiteLocation.fromJson(element));
    }
    return value;
  }

  Future<void> initAuthenticatedMapView(
      {bool isPreviousScreenLogin = false}) async {
    isExecuteCameraMoveForCardHolderOnFirstLaunch = false;
    isUserAuthenticated = true;
    isShowBackButton = false;

    final loginUserType = DrivenSiteLocator.instance.getAppLoginUserType();
    if (loginUserType.isNotEmpty && loginUserType == InternalText.cardholder) {
      if (isPreviousScreenLogin) {
        await _getUserLocation();
        await calcLatLngBoundsAndZoomLevels();
        await recenterMapOnLocationChange();
      }
      getFavoriteList();
    }
  }

  Future<void> resetMapUiOnLogout() async {
    isFirstLaunch = true;
    searchPlacesController.resetUI();
    await _getUserLocation();
    await calcLatLngBoundsAndZoomLevels();
    await recenterMapOnLocationChange();
  }

  DieselPricesPack getDieselPricesPack(SiteLocation siteLocation) {
    return dieselPricesPackUseCase
        .execute(DieselPricesPackParam(siteLocation: siteLocation));
  }

  bool canDisplayRightColumnDieselPrice(SiteLocation siteLocation) {
    final saleType = manageDieselSaleTypeUseCase
        .execute(DieselPricesPackParam(siteLocation: siteLocation));
    return saleType != DieselPriceDisplay.nothing;
  }

  FuelPriceAsOfDisplayEntity checkFuelPriceAsOfDisplayEntity(
      SiteLocation selectedSiteLocation) {
    final hasPriceToDisplayFlag = hasDieselPriceToDisplay(selectedSiteLocation);
    final displayDate = shortDate(selectedSiteLocation.asOfDate ?? '');
    return FuelPriceAsOfDisplayEntity(
      canShow: hasPriceToDisplayFlag && displayDate.isNotEmpty,
      displayDate: displayDate,
    );
  }

  bool hasDieselPriceToDisplay(SiteLocation siteLocation) {
    final DieselPriceEntity displayPriceEntity = displayDieselPriceUseCase
        .execute(DieselPricesPackParam(siteLocation: siteLocation));
    return displayPriceEntity.price.isNotEmpty;
  }

  // Cluster region
  void generateHashmapForCluster() {
    generateSiteHashmapUseCase.execute(
      GenerateSiteHashmapParams(
        siteHashmap: siteHashmap,
        sites: siteList(),
      ),
    );

    generateSiteLocationHashmapUseCase.execute(
      GenerateSiteLocationHashmapParams(
        siteLocationHashmap: siteLocationHashmap,
        siteLocations: List.from(siteLocations ?? []),
      ),
    );
  }

  Future<void> _generateClusterData(List<Marker> markers) async {
    final _mapMarkers = markers.map((marker) {
      final int row =
          ((marker.position.latitude + 90) ~/ gridManager.gridCellSize)
              .clamp(0, gridManager.rowCount - 1);
      final int column =
          ((marker.position.longitude + 180) ~/ gridManager.gridCellSize)
              .clamp(0, gridManager.columnCount - 1);
      return MapMarker(
        id: marker.markerId.value,
        position: marker.position,
        row: row,
        column: column,
        icon: marker.icon,
      );
    }).toList();

    markerCluster = MarkerCluster<MapMarker>(
      minZoom: 0,
      maxZoom: 21,

      /// Logic to maintain same data on the map view and list view is with cluster only.
      /// So, when cluster is enable fetch density from remote config, and when
      /// cluster is disable then density is 999999, so no cluster will be
      /// display on the map.
      clusterDensity:
          isClusterEnabled ? SiteLocatorConfig.defaultClusterDensity : 999999,
      points: _mapMarkers,
      // ignore: avoid_types_on_closure_parameters
      createCluster: (BaseCluster? cluster, double? lng, double? lat) {
        lat ??= 0.0;
        lng ??= 0.0;
        final int row = ((lat + 90) ~/ gridManager.gridCellSize)
            .clamp(0, gridManager.rowCount - 1);
        final int column = ((lng + 180) ~/ gridManager.gridCellSize)
            .clamp(0, gridManager.columnCount - 1);

        return MapMarker(
          isCluster: cluster?.isCluster,
          pointsSize: cluster?.pointsSize,
          id: cluster?.id.toString() ?? '',
          position: LatLng(lat, lng),
          row: row,
          column: column,
        );
      },
    );

    await applyClustering();
  }

  void updateMarkerDensity(List<MapMarker> markers) {
    for (final row in gridManager.grid) {
      for (final cell in row) {
        cell.density = 0;
      }
    }

    for (final marker in markers) {
      gridManager.updateDensity(marker.position);
    }
  }

  Future<void> applyClustering([double? zoom]) async {
    if (markerCluster == null) {
      return;
    }
    double? appliedZoom = zoom;
    final defaultZoomLevel = SiteLocatorConfig.mapZoomLevel;
    if (isWelcomeScreen) {
      appliedZoom = currentZoomLevel ?? defaultZoomLevel;
    } else {
      try {
        appliedZoom ??=
            await googleMapController?.getZoomLevel() ?? defaultZoomLevel;
      } catch (_) {
        appliedZoom = currentZoomLevel ?? defaultZoomLevel;
      }
    }

    final applyClusterParam = ApplyClusterParams(
      markerCluster: markerCluster!,
      currentLatLngBounds: currentLatLngBounds(),
      currentZoom: appliedZoom.toInt(),
      siteLocationDisplayData: siteLocationDisplayData,
      getSiteCluster: _getSiteCluster,
      getSiteMarker: getSiteMarker,
      siteLocationHashmap: siteLocationHashmap,
    );

    final markersList = await applyClusterUseCase.execute(applyClusterParam);
    await Future.delayed(const Duration(milliseconds: 500));
    markers.clear();
    if (markersList.isNotEmpty) {
      markers.addAll(markersList);
    }
  }

  Future<Marker> _getSiteCluster(MapMarker cluster) async {
    final icon = await CustomPin.getMarkerBitmap(
      200,
      text: cluster.pointsSize.toString(),
    );
    return Marker(
      markerId: MarkerId(cluster.id.toString()),
      position: cluster.position,
      consumeTapEvents: true,
      icon: icon,
      onTap: () => _onClusterTap(cluster),
    );
  }

  Future<void> _onClusterTap(MapMarker cluster) async {
    if (markerCluster == null) {
      return;
    }
    isClusterClick = true;
    final markers = markerCluster!.points(int.parse(cluster.id));
    final markersLatLng = markers.map((e) => e.position).toList();
    final position = MapUtilities.getBoundsFromLatLngs(markersLatLng);

    final zoomLevel = await googleMapController?.getZoomLevel();

    final newCenterPosition = MapUtilities.latLngBoundCenter(
      northeast: position.northeast,
      southwest: position.southwest,
    );

    if (zoomLevel != null) {
      final newZoomLevel = zoomLevel + 3;

      await googleMapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          newCenterPosition,
          newZoomLevel > 20 ? 20 : newZoomLevel,
        ),
      );
      await Future.delayed(const Duration(milliseconds: 500));
      await applyClustering(newZoomLevel);
    }
  }

  Marker getSiteMarker(MapMarker marker) {
    final site = siteHashmap[LatLng(marker.latitude!, marker.longitude!)];

    return Marker(
      markerId: MarkerId(marker.id),
      position: marker.position,
      icon: marker.icon ??
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      consumeTapEvents: true,
      onTap: () async {
        final markerDetails = await PinVariantStore.getMarkerDetails(site);
        if (markerDetails != null) {
          await onMarkerTap(markerDetails);
        }
      },
    );
  }

  SiteLocation? getSiteLocationFromClusterMarker(String id) {
    return siteLocationHashmap[id];
  }

  bool get isClusterEnabled => SiteLocatorConfig.isClusterFeatureEnabled;

  bool isFavoriteSiteLocation(String? siteIdentifier) {
    return favoriteList.contains(siteIdentifier);
  }

  // Cluster end region

  //web app
  // ignore: avoid_positional_boolean_parameters
  void onToggleShareMyCurrentLocation(bool value) {
    shareMyCurrentLocationStatus(value);
  }
}
