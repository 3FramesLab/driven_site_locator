// ignore_for_file: avoid_bool_literals_in_conditional_expressions

part of map_view_module;

class SiteLocatorController extends GetxController with SiteLocatorState {
  StreamSubscription<Position>? locationStreamSubscription;

  @override
  void onInit() {
    super.onInit();
    if (SLSessionManager().isUserAuthenticated && AppUtils.isComdata) {
      unawaited(reassemblePinDropLogoAssetSetup());
    }

    mapViewSiteInfoPanelController = PanelController();
    listViewSiteInfoPanelController = PanelController();
    _initUseCases();
    _initData();
    // initiateTimers();
  }

  @override
  void onClose() {
    // _cancelLoadingPeriodicTimer();
    super.onClose();
  }

  Future<void> clearAllCachedSites() async {
    await locationCacheUtils.writeLocationCache(
      sites: [],
      centerLocation: currentLocation(),
      mapRadius: UmaSLProperties.defaultMapRadius,
    );
  }

  // void initiateTimers() {
  // isSitesLoadingTimerInitiated(true);
  // sitesLoadingPeriodicTimer =
  //     Timer.periodic(const Duration(milliseconds: 1000), (t) {
  //   sitesLoadingPeriodicTimer = t;
  //   _cancelLoadingTimerOnSafeThreshold(getSitesLoadingProgress());
  // });
  // }

  // void _cancelLoadingPeriodicTimer() {
  // sitesLoadingPeriodicTimer?.cancel();
  // }

  void fetchSitesScheduler() {
    const cronFormat =
        '${SLInternalText.thresholdMinute} ${SLInternalText.thresholdHour} * * *';
    Cron().schedule(Schedule.parse(cronFormat), () async {
      fireDynatraceFuelPriceAPILogs('fetchSitesScheduler');
      await getSiteLocationsData(forceApiCall: true);
    });
  }

  double getSiteInfoDrawerHalfViewHeight() {
    double result = SLInternalText.siteInfoDrawerHalfViewHeight;
    if (AppUtils.isFuelman && SLSessionManager().isUserAuthenticated) {
      result = result + 20;
    }
    return result;
  }

  void setSiteInfoDrawerSnapPoint(BuildContext context) {
    final result =
        getSiteInfoDrawerHalfViewHeight() / MediaQuery.of(context).size.height;
    siteInfoDrawerSnapPoint = result;
  }

  void siteInfoDrawerOnPanelClosedEventHandler() {
    tappedFromPinDrop(false);
  }

  void siteInfoDrawerOnPanelSlideEventHandler(double panelPosition) {
    final ps = panelPosition;
    if (ps > 0) {
      isSiteInfoDrawerOpened(true);
    } else {
      isSiteInfoDrawerOpened(false);
    }
    if (_isPanelOpenedToFullView(ps)) {
      _setFullViewStatus();
    }
    if (!isSiteInfoDrawerOpened() && !tappedFromPinDrop()) {
      _setClosedStatus();
    } else if (isSiteInfoDrawerOpened()) {
      setFloatingButtonsVisibility(buttonsVisibility: false);
    } else if (!isSiteInfoDrawerOpened()) {
      setFloatingButtonsVisibility(buttonsVisibility: true);
    }
    if (ps <= siteInfoDrawerSnapPoint) {
      isShownRemainingFullSiteInfo(false);
      showFullViewExtraData(false);
    }
  }

  Future<void> _initData() async {
    if (UmaSLProperties.isDisplayMapEnabled) {
      // TODO(siva): need to verify after dfc-2.2.4
      if (!AppUtils.isComdata) {
        fetchSitesScheduler();
        await subscribeToLocationStream();
      }
      floatingButtonsBottomPosition(
        infoPanelMinHeight() + defaultPositionBottom,
      );
      debounce(
        currentLatLngBounds,
        (_) => onLatLngBoundsChange(),
        time: Duration(
          milliseconds: UmaSLProperties.autoSearchSiteIntervalInMs,
        ),
      );
    }
  }

  void _initUseCases() {
    validateLastSavedCenterLocationUseCase =
        Get.put(ValidateLastSavedCenterLocationUseCase());
    calculateSitesLoadingProgressUseCase =
        Get.put(CalculateSitesLoadingProgressUseCase());
    updateMarkerIconUseCase = Get.put(UpdateMarkerIconUseCase());
    generateMarkersUseCase = Get.put(GenerateMarkersUseCase());
    getSiteListFromSiteLocationsUseCase =
        Get.put(GetSiteListFromSiteLocationsUseCase());
    filterMarkersUseCase = Get.put(FilterMarkersUseCase());
    getUserLocationUseCase = Get.put(GetUserLocationUseCase());
    getAccessTokenForSitesUseCase = Get.put(GetAccessTokenForSitesUseCase());
    getLatLngForSelectedPlaceUseCase = Get.put(
      GetSelectedPlaceLatLngUseCase(siteLocationsService: siteLocationsService),
    );
    computeCircleRadiusUseCase = Get.put(ComputeCircleRadiusUseCase());
    // applyClusterUseCase = Get.put(ApplyClusterUseCase());
    generateSiteHashmapUseCase = Get.put(GenerateSiteHashmapUseCase());
    getSiteLocationsInVisibleMapRegionUseCase =
        GetSiteLocationsInVisibleMapRegionUseCase();
    getLowestFuelPriceUseCase = GetLowestFuelPriceUseCase();
    getSitesWithLowestFuelPriceUseCase = GetSitesWithLowestFuelPriceUseCase();
    fetchPlaceIDUseCase = FetchPlaceIDUseCase(
      siteLocationsService: siteLocationsService,
    );
    getRatingsFromPlaceIdUseCase = GetRatingsFromPlaceIdUseCase(
      siteLocationsService: siteLocationsService,
    );
    saveSitePlaceIdUseCase = SaveSitePlaceIdUseCase(hive: Globals().hive);
    getPlaceIdForSiteUseCase = GetPlaceIdForSiteUseCase(hive: Globals().hive);
    merchSiteFilterUseCase = MerchSiteFilterUseCase();
    getCardAcceptedUseCase = GetCardAcceptedUseCase();
    getSiteSourceFromCardTypeUseCase = GetSiteSourceFromCardTypeUseCase();
    adjustDuplicateLatLngUseCase = AdjustDuplicateLatLngUseCase();
  }

  Future<void> subscribeToLocationStream() async {
    if (locationStreamSubscription != null) {
      return;
    }
    final permissionStatus = await Geolocator.checkPermission();
    if (permissionStatus == LocationPermission.always ||
        permissionStatus == LocationPermission.whileInUse) {
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: SLInternalText.updateLocationDistanceInMeters,
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
          SLInternalText.thresholdDistanceForSitesUpdateInMeters) {
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
    await Geolocator.requestPermission();
    await subscribeToLocationStream();
  }

  Future<String> getAccessTokenForSites() async =>
      getAccessTokenForSitesUseCase.execute();

  Future<void> getSiteLocationsData({
    bool forceApiCall = false,
    bool updateLocationCache = false,
  }) async {
    try {
      // ignore: parameter_assignments
      forceApiCall = true;
      await PinVariantStore.iniDefaultLogos();

      await callSiteLocationSummaryFromServer(
        updateLocationCache: updateLocationCache,
      );

      await handleSiteLocationResponse();

      previousSiteLocations = siteLocations?.map(SiteLocation.clone).toList();

      isFirstLaunch = false;
      showUIControls(true);
    } on Exception catch (e) {
      Globals().dynatrace.logError(
            name: SLInternalText.getSitesAPIErrorName,
            value: SLInternalText.getSitesAPIErrorValue,
            reason: e.toString(),
          );
      showUIControls(true);
    }
    // setSitesLoadingProgress(1);
    // await Future.delayed(const Duration(milliseconds: 500));
    // hideSitesLoadingIndicator();
  }

  Future<void> callSiteLocationSummaryFromServer(
      {bool updateLocationCache = false}) async {
    // setSitesLoadingProgress(SitesLoadingProgressProps.initialValue);
    await fetchSitesFromServer();
    if (updateLocationCache || isFirstLaunch) {
      await storeSiteDataInCache();
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
      lowestFuelPrice = null;
      // sortedListViewData.clear();
      sortListByPrice.clear();
      sortListByDistance.clear();
      sortListByRatings.clear();
      siteLocations = null;
      filteredSiteLocationsList.clear();
      sitesIdentifierWithLowestFuelPrice.clear();
      Globals().dynatrace.logError(
            name:
                'error in site locator controller fetching site data from api',
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
    // TODO(Smeet): below lines may be required for future use-case.
    // await checkAndSetMCSitesGovernor();
    // if (hasToSwitchMCSites.value) {
    // if (MCSitesGovernor.isMCSitesViewEnabled) {
    //   await fetchMCSiteLocationSummaryData(jsonData, accessToken);
    // } else {
    //   await fetchRegularSiteLocationSummaryData(jsonData, accessToken);
    // }

    await fetchRegularSiteLocationSummaryData(jsonData, accessToken);

    relaySitesLoadingProgressValue(siteLocations);
  }

  bool get isWalletLoading {
    return false;
    // TODO(Smeet): need work.
    // return AppUtils.isComdata &&
    //     AppUtils.isCardHolderLogin &&
    //     SLSessionManager().isUserAuthenticated &&
    //     Get.find<WalletController>().walletService.isLoadingCards.value;
  }

  Future<void> fetchRegularSiteLocationSummaryData(
      Map<String, dynamic> jsonData, String accessToken) async {
    await reassemblePinDropLogoAssetSetup();
    lastTimeFetchedMCSites(false);
    // siteLocations = await siteLocationsService.getSiteLocationsData(
    //   jsonData,
    //   headerQueryParams: accessToken,
    // );
    final merchSiteResponse = await siteLocationsService.getMerchSiteLocation(
      jsonData,
      headerQueryParams: accessToken,
    );
    if (merchSiteResponse != null) {
      siteLocations = merchSiteResponse.siteLocations;
    } else {
      siteLocations = [];
    }
    if (apiLatLngBounds != null) {
      siteLocations?.removeWhere((s) {
        if (s.siteLatitude != null && s.siteLongitude != null) {
          return !apiLatLngBounds!
              .contains(LatLng(s.siteLatitude!, s.siteLongitude!));
        }
        return false;
      });
    }

    if (DcSiteLocatorUtils.isGuest) {
      DcSiteLocatorUtils.setNewDiscountedDieselPrice(siteLocations ?? []);
    }
  }

  Future<void> reassemblePinDropLogoAssetSetup() async {
    await defaultBrandLogoAssetInstance.setup();
  }

  void feedRelayToSitesLoadingProgress() {
    initiateSitesLoadingProgressValue();
    relaySitesLoadingProgressValue(siteLocations);
  }

  // void setSitesLoadingProgress(double value) {
  //   sitesLoadingProgressController.progressValue(value);
  // }

  double getSitesLoadingProgress() {
    return sitesLoadingProgressController.progressValue();
  }

  void toggleSitesLoadingIndicatorVisibility({required bool visible}) {
    sitesLoadingProgressController.canShowIndicator(visible);
  }

  bool canShowLoadingIndicator() {
    return sitesLoadingProgressController.canShowIndicator();
  }

  void hideSitesLoadingIndicator() {
    toggleSitesLoadingIndicatorVisibility(visible: false);
    // setSitesLoadingProgress(0);
    sitesLoadingProgressController.resetMessage();
    // _cancelLoadingPeriodicTimer();
  }

  void initiateSitesLoadingProgressValue() {
    // isSitesLoadingTimerInitiated(true);
    // Timer.periodic(
    //     Duration(milliseconds: SitesLoadingProgressProps.stepUpPeriodicTimer),
    //     (t) {
    //   sitesLoadingPeriodicTimer = t;
    //   stepUpSitesLoadingCyclicValue();
    // });
  }

  void relaySitesLoadingProgressValue(List<SiteLocation>? siteLocations) {
    // setSitesLoadingProgress(sitesLoadingProgressController.progressValue());
    // final periodicInterval = SiteInfoUtils.getSitesLoadingPeriodicInterval(
    //     (siteLocations ?? []).length);
    // Timer.periodic(Duration(milliseconds: periodicInterval), (t) {
    //   sitesLoadingPeriodicTimer = t;
    //   stepUpSitesLoadingCyclicValue();
    // });
  }

  // void stepUpSitesLoadingCyclicValue() {
  //   final param = CalculateSitesLoadingProgressParam(
  //     canShowLoading: firstTimeLoading() || isShowLoading(),
  //     previousValue: sitesLoadingProgressController.progressValue(),
  //   );
  //   final currentValue = calculateSitesLoadingProgressUseCase.execute(param);
  //   setSitesLoadingProgress(currentValue);
  //   if (!(firstTimeLoading() || isShowLoading())) {
  //     _cancelLoadingPeriodicTimer();
  //   } else {
  //     _cancelLoadingTimerOnSafeThreshold(currentValue);
  //   }
  // }

  // void _cancelLoadingTimerOnSafeThreshold(double currentValue) {
  //   if (currentValue > 0.9) {
  //     _cancelLoadingPeriodicTimer();
  //   }
  // }

  // void resetSitesLoadingIndicatorProgressValue() {
  //   if (getSitesLoadingProgress() > 0) {
  //     setSitesLoadingProgress(1);
  //     Future.delayed(
  //         Duration(milliseconds: SitesLoadingProgressProps.toHideAfter),
  //         hideSitesLoadingIndicator);
  //   } else {
  //     hideSitesLoadingIndicator();
  //   }
  //   if (isSitesLoadingTimerInitiated()) {
  //     _cancelLoadingPeriodicTimer();
  //   }
  //   isShowLoading(false);
  // }

  Future<bool> storeSiteDataInCache() async {
    return locationCacheUtils.writeLocationCache(
      sites: siteLocations ?? [],
      centerLocation: currentLocation(),
      mapRadius: UmaSLProperties.defaultMapRadius,
    );
  }

  Future<void> getSitesDataFromCache() async {
    final locations = await locationCacheUtils.readLocationCache();
    if (locations?.isEmpty ?? true) {
      await callSiteLocationSummaryFromServer(updateLocationCache: true);
    } else {
      // setSitesLoadingProgress(SitesLoadingProgressProps.initialValue);

      feedRelayToSitesLoadingProgress();
      final param = GetSiteLocationsInVisibleMapRegionParam(
        siteLocations: locations ?? [],
        visibleMapRegion: currentLatLngBounds(),
      );
      siteLocations = await getSiteLocationsInVisibleMapRegionUseCase.execute(
        param,
      );
    }
  }

  Future<void> handleSiteLocationResponse() async {
    if (siteLocations?.isNotEmpty ?? false) {
      unawaited(getSiteRatings());
      unawaited(getMilesForSites());

      //processing sites after fuel prices api call
      //to avoid multiple times processing
      await processSiteLocations(siteLocations ?? []);

      await validateSiteLocationWithFilters();
    }
    // else if ((siteLocations != null &&
    //         siteLocations!.isEmpty &&
    //         inFullMapViewScreen) ||
    //     (siteLocations != null &&
    //         siteLocations!.isEmpty &&
    //         isUnauthSLChannel())) {
    else if (siteLocations?.isEmpty ?? true) {
      lowestFuelPrice = null;
      // sortedListViewData.clear();
      sortListByPrice.clear();
      sortListByDistance.clear();
      sortListByRatings.clear();
      sitesIdentifierWithLowestFuelPrice.clear();
      _clearMapMarkersAndList();
    }
  }

  Future<void> getSiteRatings() async {
    if (DcSiteLocatorUtils.shouldInvokeGoogleRatingApi()) {
      try {
        ratingsApiInProgress(true);
        await _getPlaceIds();
        await _getRatings();
        _sortListByRatings();
      } catch (_) {}
      siteRatingCacheStore.refresh();
      ratingsApiInProgress(false);
    } else {
      for (final SiteLocation location in siteLocations ?? []) {
        if (location.masterIdentifier != null && location.ratings != null) {
          siteRatingCacheStore()
              .putIfAbsent(location.masterIdentifier!, () => location.ratings!);
        }
      }
    }
  }

  Future<void> getMilesForSites() async {
    try {
      getMilesInProgress(true);
      clearMilesCachedData();
      await cachingDrivingDistance(siteLocations ?? []);
      _sortListByDistance();
    } catch (_) {}
    getMilesInProgress(false);
  }

  Future<void> _getPlaceIds() async {
    if (siteLocations == null) {
      return;
    }
    try {
      for (final location in siteLocations!) {
        if (siteRatingCacheStore[location.masterIdentifier] != null) {
          continue;
        }

        String? placeId;
        if (location.masterIdentifier.isNotNullEmptyOrWhitespace) {
          placeId = await getPlaceIdForSiteUseCase.execute(
            GetPlaceIdForSiteParam(
                masterIdentifier: location.masterIdentifier!),
          );
        }

        if (placeId.isNullEmptyOrWhitespace) {
          placeId = await fetchPlaceIDUseCase.execute(
            FetchPlaceIDUseCaseParams(siteLocation: location),
          );

          if (location.masterIdentifier.isNotNullEmptyOrWhitespace) {
            await saveSitePlaceIdUseCase.execute(
              SaveSitePlaceIdParam(
                masterIdentifier: location.masterIdentifier ?? '',
                placeId: placeId,
              ),
            );
          }
        }
        if (placeId.isNotNullEmptyOrWhitespace) {
          location.placeId = placeId;
        }
      }
    } catch (_) {}
  }

  Future<void> _getRatings() async {
    if (siteLocations == null) {
      return;
    }
    try {
      for (final location in siteLocations!) {
        if (siteRatingCacheStore[location.masterIdentifier] != null) {
          location.ratings = siteRatingCacheStore[location.masterIdentifier];
          continue;
        }

        final id = location.masterIdentifier;
        if (id.isNotNullEmptyOrWhitespace &&
            location.placeId.isNotNullEmptyOrWhitespace) {
          final ratings = await getRatingsFromPlaceIdUseCase.execute(
            GetRatingsFromPlaceIdParams(placeId: location.placeId!),
          );
          location.ratings = ratings;
          cacheSiteRating(id!, ratings);
        }
      }
    } catch (_) {}
  }

  void cacheSiteRating(String masterIdentifier, double rating) {
    if (rating != PlaceRatingEntity.error) {
      siteRatingCacheStore().putIfAbsent(masterIdentifier, () => rating);
    }
  }

  Future<double> getRatingsForSite(SiteLocation siteLocation) async {
    String? placeId;

    // check if placeID from site ID exists or not.
    if (siteLocation.masterIdentifier.isNotNullEmptyOrWhitespace) {
      placeId = await getPlaceIdForSiteUseCase.execute(
        GetPlaceIdForSiteParam(
            masterIdentifier: siteLocation.masterIdentifier!),
      );
    }

    /// if not exist then call google place API to get placeID
    /// and save in storage against the site id.
    if (placeId.isNullEmptyOrWhitespace) {
      placeId = await fetchPlaceIDUseCase.execute(
        FetchPlaceIDUseCaseParams(siteLocation: siteLocation),
      );
      if (siteLocation.masterIdentifier.isNotNullEmptyOrWhitespace) {
        await saveSitePlaceIdUseCase.execute(
          SaveSitePlaceIdParam(
            masterIdentifier: siteLocation.masterIdentifier ?? '',
            placeId: placeId,
          ),
        );
      }
    }

    // get ratings from placeID
    if (placeId.isNotNullEmptyOrWhitespace) {
      // search session cache.
      return getRatingsFromPlaceIdUseCase.execute(
        GetRatingsFromPlaceIdParams(placeId: placeId!),
      );
    }
    return -1;
  }

  bool hasToClearMarkersAndList() {
    return (siteLocations != null && siteLocations!.isEmpty) &&
        (inFullMapViewScreen || isUnauthSLChannel());
  }

  // TODO(Smeet): need work
  // bool get inFullMapViewScreen => Get.currentRoute == Routes.unauthSiteLocator;
  bool get inFullMapViewScreen => true;

  void _clearMapMarkersAndList() {
    markers.clear();
    filteredSiteLocationsList.clear();
    clusterManager = null;
    _clearSiteListItemIfNecessary();
  }

  Future<void> validateSiteLocationWithFilters({
    bool shouldSortList = false,
  }) async {
    filteredSiteLocationsList = merchSiteFilterUseCase.execute(
      MerchSiteFilterParam(
        siteLocations: siteLocations ?? [],
        filters: DcSiteLocatorUtils.getSelectedFilters(),
        isGallonUpFilterSelected: DcSiteLocatorUtils.isGallonUpFilterSelected(),
        visibleBrandFilterKeys: DcSiteLocatorUtils.getVisibleBrandFilterKeys(),
      ),
    );

    await _filterMapPins(filteredSiteLocationsList);

    _sortListByPrice();
    _sortListByDistance();
    _sortListByRatings();
  }

  void handleFilteredSitesData() {
    if (filteredSiteLocationsList.isEmpty && !(Get.isDialogOpen ?? false)) {
      if (expandRadiusButtonTapCount >
          SLInternalText.thresholdForShowingChangeFiltersDialog) {
        resetExpandRadiusButtonTapCount();
        // showChangeFiltersDialog();
      }
    }
    if (filteredSiteLocationsList.isNotEmpty) {
      resetExpandRadiusButtonTapCount();
    }
  }

  Future<void> processSiteLocations(
      List<SiteLocation> siteLocationsList) async {
    PinVariantStore.statusList = [];
    lowestFuelPrice = null;
    sitesIdentifierWithLowestFuelPrice.clear();
    siteList(toSiteLocatorMap(siteLocationsList));

    lowestFuelPrice = getLowestFuelPriceUseCase.execute(siteList);

    if (lowestFuelPrice != null && lowestFuelPrice != 0) {
      final param = GetSitesWithLowestFuelPriceParam(
        sites: siteList,
        lowestFuelPrice: lowestFuelPrice!,
      );
      final sitesWithLowestFuelPrice =
          getSitesWithLowestFuelPriceUseCase.execute(
        param,
      );

      sitesIdentifierWithLowestFuelPrice =
          sitesWithLowestFuelPrice.map((e) => e.id).toList();
      sitesIdentifierWithLowestFuelPrice
          .removeWhere((e) => e.isNullEmptyOrWhitespace);
    }

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
    showUIControls(true);
  }

  Future<void> calcLatLngBoundsAndZoomLevels(
      {GoogleMapController? mapController}) async {
    try {
      final controller = mapController ?? googleMapController;
      currentZoomLevel = UmaSLProperties.mapZoomLevel;
      currentLatLngBounds(
        MapUtilities.toBounds(currentLocation(), sitesRadiusInMeters),
      );
      if (isFirstLaunch) {
        currentZoomLevel =
            await controller?.getZoomLevel() ?? UmaSLProperties.mapZoomLevel;
      }
      cameraPositionZoom(currentZoomLevel);
      lastZoomByUser(currentZoomLevel);
      defaultCircleZoom = currentZoomLevel ?? 12.5;
      reCenterLatLngBounds = currentLatLngBounds();
    } on Exception catch (_) {
      isShowLoading(false);
      currentZoomLevel = UmaSLProperties.mapZoomLevel;
    }
  }

  // Map<String, dynamic> getJsonBodyData() {
  //   final boundsToPayload =
  //       '${currentLatLngBounds().southwest.latitude},${currentLatLngBounds().southwest.longitude},${currentLatLngBounds().northeast.latitude},${currentLatLngBounds().northeast.longitude}';

  //   final Map<String, dynamic> jsonData = {
  //     'bounds': boundsToPayload,
  //   };
  //   return SiteLocatorConfig.addQueryParams(jsonData);
  // }

  Map<String, dynamic> getJsonBodyData() {
    apiLatLngBounds = currentLatLngBounds();

    final centerLatLng = MapUtilities.latLngBoundCenter(
      southwest: currentLatLngBounds().southwest,
      northeast: currentLatLngBounds().northeast,
    );

    fixedCenterLatLng(centerLatLng);

    double radius = MapUtilities.distanceFromCenter(
      centerFrom: centerLatLng,
      latLngBounds: currentLatLngBounds(),
      to: DeviceEdge.topRight,
    );
    if (radius > UmaSLProperties.mapRadiusCircle) {
      radius = UmaSLProperties.mapRadiusCircle;
    }
    lastSearchedRadius = radius;

    String fleetId = '';
    if (SLSessionManager().selectedFleetId().isNotNullEmptyOrWhitespace) {
      fleetId = SLSessionManager().selectedFleetId();
    }

    final cardToken = SLSessionManager().selectedCardToken;

    String? sysAccountId;
    // TODO(Smeet): need work
    // if (SLSessionManager()
    //     .selectedCardSysAccountId
    //     .isNotNullEmptyOrWhitespace) {
    //   // CH
    //   sysAccountId = SLSessionManager().selectedCardSysAccountId;
    // } else if (SLSessionManager()
    //         .selectedAccountDetails
    //         ?.sysAccountId
    //         .isNotNullEmptyOrWhitespace ??
    //     false) {
    //   // admin
    //   sysAccountId = SLSessionManager().selectedAccountDetails?.sysAccountId;
    // }

    final siteSource = getSiteSourceFromCardTypeUseCase.execute(
      SLSessionManager().selectedCardTypeValue,
    );

    final Map<String, dynamic> jsonData = DcSiteLocatorUtils.getJsonData(
      centerLatLng: centerLatLng,
      fleetId: fleetId,
      sysAccountId: sysAccountId,
      cardToken: cardToken,
      siteSource: siteSource,
      radius: radius,
    );
    return jsonData;
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
        UmaSLProperties.mapZoomLevel;
    previousZoomLevel ??= zoomLevel;
    final hasToMakeAPICall = zoomLevel.truncateToDecimalPlaces(3) <
        previousZoomLevel!.truncateToDecimalPlaces(3);
    previousZoomLevel = zoomLevel;
    _getZoomInZoomOutTrackAction(hasToMakeAPICall);
    return hasToMakeAPICall;
  }

  LatLngBounds? tempLatLngBounds;

  bool get isZoomLevelBelowThreshold =>
      previousZoomLevel != null && previousZoomLevel! < 10.5;

  bool _canContinueOnLatLngBoundsChange() {
    if ((!inFullMapViewScreen) ||
        (Get.isDialogOpen ?? false) ||
        isFullMapViewFirstLaunch ||
        isSiteInfoDrawerOpened()) {
      return false;
    }

    /// tap on recenter,making camera move and executing this method.
    /// To avoid duplicate api calls, if its coming after recenter skipping.
    if (isComingFromRecenter) {
      isComingFromRecenter = false;
      return false;
    }
    return true;
  }

  Future<void> onLatLngBoundsChange() async {
    try {
      if (!_canContinueOnLatLngBoundsChange()) {
        return;
      }

      if (isFetchSitesData &&
          !isMapPinTapped &&
          !isClusterClick &&
          searchPlacesController.searchText.isEmpty) {
        resetMarkers(PinVariantStore.statusList);

        // await applyClustering();

        // if (allowGateKeeperToGetSiteLocationsData() &&
        if (infoPanelMinHeight.value == 0.0 && !isRecenterTap) {
          // isShowSearchThisArea(true);
          // isLatLngBoundsChanged(true);

          isShowLoading(true);
          await getSiteLocationsData();
          isShowLoading(false);
        }
      }
      isClusterClick = false;
      isFetchSitesData = true;
      isMapPinTapped = false;
      isRecenterTap = false;
    } catch (e) {
      isShowLoading(false);
      Globals().dynatrace.logError(
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

  Future<void> updateFullMapViewSitesData({bool forceApiCall = false}) async {
    try {
      bool canMakeApiCall = forceApiCall;
      // if (SLSessionManager().isUserAuthenticated &&
      //     AppUtils.isCardHolderLogin &&
      //     Get.find<WalletController>().walletService.isSelectedCardChanged) {
      //   canMakeApiCall = true;
      //   MCSitesGovernor.isMCSitesViewEnabled = false;
      //   lastTimeFetchedMCSites(false);
      //   await Get.find<EnhancedFilterController>().clearAllFilter();
      //   Get.find<WalletController>().walletService.isSelectedCardChanged =
      //       false;
      // }
      if (selectedPlace != null) {
        await getLatLngForSelectedPlace(selectedPlace!);
      } else {
        await onReCenterButtonClicked(forceApiCall: canMakeApiCall);
      }
    } catch (e) {
      isShowLoading(false);
      Globals().dynatrace.logError(
            name: 'error: on updateFullMapViewSitesData',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  Future<void> onReCenterButtonClicked(
      {bool forceApiCall = false, GoogleMapController? mapController}) async {
    try {
      //avoiding duplicate processes.
      if (isShowLoading()) {
        return;
      }
      isShowLoading(true);
      isComingFromRecenter = true;
      resetCircleAfterZoomOut();
      isFetchSitesData = false;
      resetMapViewScreen();
      resetRadius();
      searchPlacesController.clearTextInput();
      await updateCurrentLatLngBoundsOnReCenter(mapController: mapController);
      resetCircleAfterZoomIn();
      fireDynatraceFuelPriceAPILogs('onReCenterButtonClicked');
      await getSiteLocationsData(
        updateLocationCache: true,
        forceApiCall: forceApiCall,
      );
      isShowLoading(false);
      canRecenterMapViewOnLocationChange = true;
      canClearSearchTextField = true;
      selectedPlace = null;
    } catch (e) {
      isShowLoading(false);
      Globals().dynatrace.logError(
            name: 'error: on recenter button tap',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  Future<void> updateCurrentMapZoomLevel(
      {required GoogleMapController? mapController}) async {
    if (mapController != null && currentZoomLevel == null) {
      currentZoomLevel = await mapController.getZoomLevel();
    }
    previousZoomLevel = UmaSLProperties.mapZoomLevel;
  }

  Future<void> updateCurrentLatLngBoundsOnReCenter(
      {GoogleMapController? mapController}) async {
    try {
      final controller = mapController ?? googleMapController;
      currentLocation.value = await getUserLocationUseCase.execute();
      await controller?.moveCamera(
        CameraUpdate.newLatLngZoom(
          currentLocation(),
          currentZoomLevel ?? UmaSLProperties.mapZoomLevel,
        ),
      );
      currentLatLngBounds(await controller?.getVisibleRegion());
    } catch (e) {
      Globals().dynatrace.logError(
            name: 'error occurred on camera move',
            value: e.toString(),
            reason: e.toString(),
          );
    }
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

  Future<void> initMapData() async {
    try {
      firstTimeLoading(true);
      isShowSearchThisArea(false);
      sitesLoadingProgressController.isLoading.value = true;
      sitesLoadingProgressController.isMapPositionChanged(false);
      await Future.delayed(const Duration(milliseconds: 200), () async {
        await updateFullMapViewSitesData(
            forceApiCall: canMakeForceSitesApiCall);
        // TODO(Smeet): may be use this in future.
        canMakeForceSitesApiCall = false;
      });
      sitesLoadingProgressController.isLoading.value = false;
      await _completeInitialLoader();
    } catch (_) {}

    firstTimeLoading(false);
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
    DcSiteLocatorUtils.hideKeyboard();
    closeLocationInfoPanel();
    resetPrevSelectedMarkerStatus();
  }

  Future<void> moveCameraPosition(LatLngBounds newPosition,
      {GoogleMapController? mapController}) async {
    final controller = mapController ?? googleMapController;
    Future.delayed(
      const Duration(milliseconds: 200),
      () => controller?.moveCamera(
        CameraUpdate.newLatLngBounds(newPosition, mapPadding),
      ),
    );
  }

  void clearSearchPlaceInput() {
    final searchPlacesController = Get.find<SearchPlacesController>();
    if (searchPlacesController.searchTextEditingController.text.isNotEmpty &&
        canClearSearchTextField &&
        selectedPlace == null) {
      searchPlacesController.clearTextInput();
    }
  }

  Future<void> onCameraIdle() async {
    clusterManager?.updateMap();
    isMapViewCameraMoving = false;
    await setCenterCoordinate();

    if (isClusterClick) {
      isShowLoading(true);
      await getSiteLocationsData();
      isShowLoading(false);
    }
  }

  Future<void> onCameraMove(CameraPosition cameraPosition) async {
    try {
      clusterManager?.onCameraMove(cameraPosition);
      if (!isClusterClick &&
          !isMapPinTapped &&
          !isFirstLaunch &&
          !firstTimeLoading()) {
        sitesLoadingProgressController.isMapPositionChanged(true);
      }
      DcSiteLocatorUtils.hideKeyboard();
      if (backFromSiteLocationsListView || tappedFromPinDrop()) {
        Future.delayed(const Duration(milliseconds: 100), () {
          backFromSiteLocationsListView = false;
        });
        return;
      }

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
      if (platform != null && platform == TargetPlatform.iOS) {
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

      if (!isMapViewCameraMoving &&
          !firstTimeLoading() &&
          !sitesLoadingProgressController.canShowIndicator()) {
        canClearSearchTextField = true;
        selectedPlace = null;
      }
      if (!isFullMapViewFirstLaunch) {
        isComingFromRecenter = false;
      }
      clearSearchPlaceInput();
      isFetchSitesData = true;
      isMapPinTapped = false;
      currentLatLngBounds(await googleMapController?.getVisibleRegion());
    } on Exception catch (e) {
      Globals().dynatrace.logError(
            name: 'error occurred on camera move',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  Future<void> setCenterCoordinate() async {
    try {
      final visibleRegion = await googleMapController?.getVisibleRegion();

      if (visibleRegion != null) {
        centerLatLng.value = LatLng(
          (visibleRegion.northeast.latitude +
                  visibleRegion.southwest.latitude) /
              2,
          (visibleRegion.northeast.longitude +
                  visibleRegion.southwest.longitude) /
              2,
        );
      }
    } on Exception catch (_) {
      fireDynatraceFuelPriceAPILogs('visibleRegion');
    }
  }

  Future<bool> generateMapPinList() async {
    final brandPinVariantList = await getPinVariantStatusList();
    PinVariantStore.statusList = brandPinVariantList;
    rawMarkersList =
        generateMarkerList(brandPinVariantList, SLInternalText.resetCode);

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
          clusterManager: clusterManager, // google_map_flutter
        ),
      );

  void resetMarkers(List<MarkerDetails> detailsList) {
    isBottomModalSheetOpened(false);
    selectedSiteLocation(SiteLocation.blank());
    closeLocationInfoPanel();
    resetPrevSelectedMarkerStatus();
    closeSiteLocatorMenuPanel();
  }

  void closeSiteLocatorMenuPanel() {
    if (menuPanelController.isAttached) {
      menuPanelController.close();
    }
  }

  Future<void> onMarkerTap(MarkerDetails item) async {
    try {
      trackAction(
        AnalyticsTrackActionName.locationPinClickedEvent,
        // adobeCustomTag: AdobeTagProperties.mapView,
      );
      tappedFromPinDrop(true);
      DcSiteLocatorUtils.hideKeyboard();
      closeSiteLocatorMenuPanel();
      isFetchSitesData = false;
      isMapPinTapped = true;

      selectedMapPinKey = item.site.id == selectedMapPinKey
          ? SLInternalText.resetCode
          : item.site.id;

      _deselectPrevMarker();
      _highlightSelectedMarker(item);
      prevSelectedMarkerDetails = item;
      previousMarkerDetails = item;

      if (selectedMapPinKey == SLInternalText.resetCode) {
        unawaited(closeLocationInfoPanel());
        clearSearchPlaceInput();
      } else {
        showOpacity(false);
        unawaited(setSelectedLocation(item.site.id)
            .then((_) => openLocationInfoPanel()));
      }
      await _animateCameraToSelectedSite(item);

      // // clusterManager?.updateMap();
      updateRecentViewLocations(selectedSiteLocation());
      siteDetailPopup(
        selectedSiteLocation(),
        barrierColor: Colors.transparent,
      );
    } catch (e) {
      Globals().dynatrace.logError(
            name: 'error occurred on marker tap',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  Future<void> _animateCameraToSelectedSite(MarkerDetails item) async {
    await googleMapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(item.site.latitude, item.site.longitude),
      ),
    );
  }

  void _highlightSelectedMarker(MarkerDetails item) {
    if (selectedMapPinKey != SLInternalText.resetCode) {
      updateMapPinMarker(markers, item, isShowBigIcon: true);
    }
  }

  void _deselectPrevMarker() {
    if (prevSelectedMarkerDetails != null) {
      updateMapPinMarker(markers, prevSelectedMarkerDetails!);
      clusterManager?.updateMap();
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
    selectedMapPinKey = SLInternalText.resetCode;
    _deselectPrevMarker();
    prevSelectedMarkerDetails = null;
  }

  Future<void> setSelectedLocation(String siteId) async {
    isBottomModalSheetOpened(false);
    final selectedLocation = previousSiteLocations
        ?.firstWhereOrNull((item) => item.masterIdentifier == siteId);

    if (selectedLocation != null) {
      setInfoPanelInitialHeight(selectedLocation);
      selectedSiteLocation(selectedLocation);
    } else {
      selectedSiteLocation(SiteLocation.blank());
    }
  }

  Future<List<MarkerDetails>> getPinVariantStatusList() async {
    return PinVariantStore.generateStore(
      siteList: siteList,
      lowestFuelPrice: lowestFuelPrice,
    );
  }

/*  Site pin marker selection and show Site Location Info Panel */
  Future<void> openLocationInfoPanel(
      {SiteLocationInfoViewModes mode = SiteLocationInfoViewModes.half}) async {
    resetMilesDisplay();
    checkIsFavorite(selectedSiteLocation().siteIdentifier.toString());
    await getMiles(selectedSiteLocation()).then((_) {
      milesDisplay(displayMiles(selectedSiteLocation()));
    });
    if (mapViewSiteInfoPanelController.isAttached) {
      await mapViewSiteInfoPanelController
          .animatePanelToPosition(siteInfoDrawerSnapPoint);
    }
    infoPanelMinHeight(infoPanelInitialHeight());
    floatingButtonsBottomPosition(infoPanelMinHeight() + 10);
    showOpacity(true);
    showFullViewExtraData(false);
    setFloatingButtonsVisibility(buttonsVisibility: false);
  }

  Future<void> openSiteInfoFullView(SiteLocation siteLocation) async {
    // from List view
    isShownRemainingFullSiteInfo(true);
    isSiteInfoFullViewed(true);
    showFullViewExtraData(true);
    selectedSiteLocation(siteLocation);

    await getMiles(selectedSiteLocation()).then((_) {
      milesDisplay(displayMiles(selectedSiteLocation()));
    });
    setFloatingButtonsVisibility(buttonsVisibility: false);
    if (listViewSiteInfoPanelController.isAttached) {
      unawaited(listViewSiteInfoPanelController.open());
    }
  }

  void mapFullViewInitStatus() {
    clearMilesCachedData();
    isBottomModalSheetOpened(false);
    showOpacity(false);
    slideDownClosingLocationInfoPanel();
  }

  Future<void> closeLocationInfoPanel(
      {SiteLocationInfoViewModes mode = SiteLocationInfoViewModes.half}) async {
    if (!isBottomModalSheetOpened()) {
      showOpacity(false);
      infoPanelMinHeight(0);
      if (mapViewSiteInfoPanelController.isAttached) {
        unawaited(mapViewSiteInfoPanelController.animatePanelToPosition(0));
      }
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
    const milesUnit = SLInternalText.milesUnit;
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
    try {
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
    } catch (e) {
      isShowLoading(false);
      Globals().dynatrace.logError(
            name: 'error: on getMiles',
            value: e.toString(),
            reason: e.toString(),
          );
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

  // ARCHIVE CODE.
  // Future<void> cachingDrivingDistance(List<SiteLocation> siteLocations) async {
  //   if (isLocationEnabled) {
  //     final latLngList = getLangList(siteLocations);
  //     final slicedLatLng = sliceLatLngCount(latLngList,
  //         count: latLngList.length > 10 ? 10 : null);
  //     final destinationsParamValues = formatLatLngParams(latLngList);
  //     final originsParamValue = formatLatLngKey(
  //       // TODO(Smeet): For testing
  //       33.74101370488267,
  //       -84.37764803427127,
  //       // currentLocation().latitude,
  //       // currentLocation().longitude,
  //     );
  //     final qs =
  //         'destinations=$destinationsParamValues&origins=$originsParamValue';
  //     final distanceMatrixUrl = '${ApiConstants.distanceMatrixGoogleUrl}&$qs';
  //     final distanceMatrix = await fetchDistanceData(distanceMatrixUrl);
  //     await processMilesCache(slicedLatLng, distanceMatrix);
  //   }
  //   isInitialListLoading(false);
  //   isViewMoreLoading(false);
  // }

  Future<void> cachingDrivingDistance(List<SiteLocation> siteLocations) async {
    if (isLocationEnabled) {
      final batchSize = UmaSLProperties.maxDestinationInDistanceMatrix;
      final latLngList = getLangList(siteLocations);

      for (int i = 0; i < latLngList.length; i += batchSize) {
        final batch = latLngList.sublist(
          i,
          i + batchSize > latLngList.length ? latLngList.length : i + batchSize,
        );

        final destinationsParamValues = batch.join('|');
        final originsParamValue = formatLatLngKey(
          // TODO(Smeet): For testing
          // 33.74101370488267,
          // -84.37764803427127,
          currentLocation().latitude,
          currentLocation().longitude,
        );
        final qs =
            'destinations=$destinationsParamValues&origins=$originsParamValue';
        final distanceMatrixUrl = '${ApiConstants.distanceMatrixGoogleUrl}&$qs';
        final distanceMatrix = await fetchDistanceData(distanceMatrixUrl);
        await processMilesCache(batch, distanceMatrix);
      }
    }
    isInitialListLoading(false);
    isViewMoreLoading(false);
  }

  Future<void> processMilesCache(
      List<String> slicedLatLng, DistanceMatrix? distanceMatrix) async {
    final Map<String, double> milesDataMap = milesDataCache();
    const defaultDrivingDistance = -1.0;
    for (int keyIndex = 0; keyIndex < slicedLatLng.length; keyIndex++) {
      final latLngListKey = slicedLatLng[keyIndex];

      if (distanceMatrix != null) {
        if (keyIndex < (distanceMatrix.distanceList?.length ?? 0)) {
          final status = distanceMatrix.distanceList?[keyIndex].status;
          if (status == APIReturnStatus.ok) {
            final key = latLngListKey;
            final double mile = distanceMatrix.distanceList?[keyIndex].miles ??
                defaultDrivingDistance;
            milesDataMap.putIfAbsent(key, () => mile);
          } else {
            milesDataMap.putIfAbsent(
                latLngListKey, () => defaultDrivingDistance);
          }
        }
      } else {
        milesDataMap.putIfAbsent(latLngListKey, () => defaultDrivingDistance);
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
    const halfViewHeight = SLInternalText.siteInfoDrawerHalfViewHeight;
    if (!isLocationPresent(selectedLocation) &&
        !isPhoneMaintenancePresent(selectedLocation)) {
      infoPanelInitialHeight(halfViewHeight -
          SLInternalText.phoneMaintenanceWidgetHeight -
          SLInternalText.phoneMaintenanceWidgetHeight);
    } else if (!isLocationPresent(selectedLocation)) {
      infoPanelInitialHeight(
          halfViewHeight - SLInternalText.locationNameWidgetHeight);
    } else if (!isPhoneMaintenancePresent(selectedLocation)) {
      infoPanelInitialHeight(
          halfViewHeight - SLInternalText.phoneMaintenanceWidgetHeight);
    } else {
      infoPanelInitialHeight(halfViewHeight);
    }
    calculateHeightWithoutPhoneAndHours(selectedLocation);
  }

  void calculateHeightWithoutPhoneAndHours(SiteLocation? selectedLocation) {
    if (AppUtils.isComdata) {
      final locPhone = selectedLocation?.locationPhone ?? '';
      final hoursOp = selectedLocation?.hoursOfOperation ?? '';
      if (locPhone.isEmpty && hoursOp.isEmpty) {
        infoPanelInitialHeight(
            SLInternalText.panelWidgetHeightWithoutPhoneAndHours);
      }
    }
  }

  bool isLocationPresent(SiteLocation? selectedLocation) {
    return selectedLocation?.fuelBrand != null &&
        selectedLocation?.fuelBrand != SLInternalText.unbranded;
  }

  bool isPhoneMaintenancePresent(SiteLocation? selectedLocation) {
    return !(selectedLocation?.locationPhone == null &&
        selectedLocation?.locationType?.maintenanceService == Status.N);
  }

  void checkIsFavorite(String id) => isSiteFavorite(favoriteList.contains(id));

  Future<void> filterSiteLocations({
    bool showNoFilterLocationDialog = false,
    bool shouldSortList = false,
  }) async {
    try {
      isShowLoading(true);
      isInitialListLoading(true);
      if (siteLocations?.isNotEmpty ?? false) {
        await validateSiteLocationWithFilters(shouldSortList: shouldSortList);
      }
      isShowLoading(false);
      isInitialListLoading(false);
    } on Exception catch (e) {
      isShowLoading(false);
      Globals().dynatrace.logError(
            name: 'error while filter site locations',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  Future<void> _filterMapPins(
      List<SiteLocation> filteredSiteLocationsList) async {
    if (isGenerateMapPinsOnFiltering) {
      firstTimeLoading(true);
      // setSitesLoadingProgress(SitesLoadingProgressProps.initialValue);
      initiateSitesLoadingProgressValue();
      try {
        await processSiteLocations(siteLocations ?? []);
      } catch (_) {}
      await _completeInitialLoader();
      firstTimeLoading(false);
      isGenerateMapPinsOnFiltering = false;
    }

    final markersWithoutCluster = await filterMarkers(
      rawMarkersList,
      filteredSiteLocationsList,
    );

    await generateClusterData(markersWithoutCluster);
    // addMarkersToCluster(markersWithoutCluster);
  }

  // void addClusterManager() {
  //   clusterManager ??= ClusterManager(
  //     clusterManagerId: const ClusterManagerId('cluster_id_1'),
  //     onClusterTap: onClusterTap,
  //   );
  // }

  // Future<void> onClusterTap(Cluster cluster) async {
  //   isClusterClick = true;
  //   final bounds = cluster.bounds;
  //   await googleMapController?.animateCamera(
  //     CameraUpdate.newLatLngBounds(bounds, 50),
  //   );
  // }

  // void addMarkersToCluster(List<Marker> newMarkers) {
  //   if (clusterManager == null) {
  //     return;
  //   }
  //   // markers.clear();
  //   markers.value = newMarkers;
  //   markers.refresh();
  // }

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
    await fetchNextSetDrivingDistance(nextSet.toList());
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
        // adobeCustomTag: AdobeTagProperties.listView,
      );

      final List<SiteLocation> originalItems = getSiteLocationsForListView();
      originalItems.sort(sortByMilesApart);
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

  // List<SiteLocation> getSiteLocationsForListView() => List.from(
  //       selectedSiteFilters.isNotEmpty
  //           ? filteredSiteLocationsList
  //           : siteLocations ?? <SiteLocation>[],
  //     );

  List<SiteLocation> getSiteLocationsForListView() => List.from(
        DcSiteLocatorUtils.isMerchFilterApplied()
            ? filteredSiteLocationsList
            : siteLocations ?? <SiteLocation>[],
      );

  void setBottomNavTab({required bool isLocatorTabPressed}) {
    isLocatorBottomNavTabPressed(isLocatorTabPressed);
  }

  void incrementExpandRadiusButtonTapCount() => expandRadiusButtonTapCount += 1;

  void resetExpandRadiusButtonTapCount() => expandRadiusButtonTapCount = 1;

  LatLng get getCenterLatLng =>
      centerLatLng() != null ? centerLatLng()! : currentLocation();

  double increaseMilesInMeter() {
    expandRadiusCount(expandRadiusCount() + 1);
    final additionalRadius = SLInternalText.incrementMiles *
        expandRadiusCount() *
        SLInternalText.mileToMeterConvertUnit;
    return additionalRadius + sitesRadiusInMeters;
  }

  void onCancelTap() => Get.back();

  /// This method is used to search for a location with bounds.
  /// Archive method.
  // Future<void> searchedLocationWithBounds(
  //     {required LatLng searchPlaceLatLng}) async {
  //   isFetchSitesData = false;
  //   previousZoomLevel = currentZoomLevel;
  //   final adjustedRadius = sitesRadiusInMeters - MathUtil.miToMtsFactor;
  //   currentLatLngBounds(MapUtilities.toBounds(
  //     searchPlaceLatLng,
  //     adjustedRadius,
  //   ));
  //   searchedPlaceLatLngBounds.value = currentLatLngBounds.value;
  //   await moveCameraPosition(currentLatLngBounds());
  //   fireDynatraceFuelPriceAPILogs('searchedLocationWithBounds');
  //   await getSiteLocationsData();
  // }

  Future<void> searchedLocationWithBounds(
      {required LatLng searchPlaceLatLng}) async {
    isFetchSitesData = false;
    previousZoomLevel = currentZoomLevel;

    resetCircleAfterZoomOut();
    resetMapViewScreen();
    currentLatLngBounds(MapUtilities.toBounds(
      searchPlaceLatLng,
      sitesRadiusInMeters,
    ));

    await googleMapController?.moveCamera(
      CameraUpdate.newLatLngZoom(
        searchPlaceLatLng,
        currentZoomLevel ?? UmaSLProperties.mapZoomLevel,
      ),
    );
    currentLatLngBounds(await googleMapController?.getVisibleRegion());
    resetCircleAfterZoomIn();
    searchedPlaceLatLngBounds.value = currentLatLngBounds.value;
    fireDynatraceFuelPriceAPILogs('searchedLocationWithBounds');
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
      if (_isPanelClosed(pos)) {
        setFloatingButtonsVisibility(buttonsVisibility: true);
      } else {
        if (gpsIconButtonVisible() && searchIconButtonVisible()) {
          setFloatingButtonsVisibility(buttonsVisibility: false);
        }
      }
    }
  }

  bool _isPanelOpenedToFullView(double pos) =>
      mapViewSiteInfoPanelController.isAttached &&
      (mapViewSiteInfoPanelController.isPanelOpen ||
          (!mapViewSiteInfoPanelController.isPanelOpen && pos > 0.9));

  void _setFullViewStatus() {
    trackAction(
      AnalyticsTrackActionName.siteInfoDrawerSlideToFullScreenEvent,
      // adobeCustomTag: AdobeTagProperties.siteInfo,
    );
    isShownRemainingFullSiteInfo(true);
    isSiteInfoFullViewed(true);
    showFullViewExtraData(true);
  }

  bool _isPanelDraggedDownToClose(double pos) =>
      isSiteInfoFullViewed() && pos < 0.45;

  bool _isPanelClosed(double pos) => !showOpacity.value && pos == 0.0;

  void _setClosedStatus() {
    showOpacity(false);
    showFullViewExtraData(false);
    slideDownClosingLocationInfoPanel();
  }

  void setFloatingButtonsVisibility({bool? buttonsVisibility}) {
    if (buttonsVisibility != null) {
      gpsIconButtonVisible(buttonsVisibility);
      searchIconButtonVisible(buttonsVisibility);
      canShowFloatingMapButtons(buttonsVisibility);
      isShowSearchThisArea(buttonsVisibility);
    }
  }

  Future<dynamic> getLatLngForSelectedPlace(
    Predictions selectedPlaceDetails, {
    bool shouldNavigateBack = false,
  }) async {
    canRecenterMapViewOnLocationChange = false;
    canClearSearchTextField = false;
    if (shouldNavigateBack) {
      Get.back(result: selectedPlaceDetails);
    }
    isShowLoading(true);
    firstTimeLoading(true);
    isListLoading(true);
    sitesLoadingProgressController.isLoading.value = true;
    try {
      final placeLatLng = await getSelectedPlaceLatLng(selectedPlaceDetails);
      final LatLng searchPlaceLatLng = LatLng(
        placeLatLng!.results!.first.geometry!.location!.lat!,
        placeLatLng.results!.first.geometry!.location!.lng!,
      );
      await searchedLocationWithBounds(
        searchPlaceLatLng: searchPlaceLatLng,
      );
    } catch (_) {
      isShowLoading(false);
      firstTimeLoading(false);
      Globals().dynatrace.logError(
            name: SLInternalText.geoCodingAPIErrorName,
            value: SLInternalText.geoCodingAPIErrorValue,
          );
    }
    sitesLoadingProgressController.isLoading.value = false;
    await _completeInitialLoader();
    isShowLoading(false);
    firstTimeLoading(false);
    isInitialListLoading(false);
    isListLoading(false);
  }

  Future<void> _completeInitialLoader() async {
    // sitesLoadingProgressController.completeMapLoader.value = true;
    // await Future.delayed(const Duration(milliseconds: 500));
    // sitesLoadingProgressController.completeMapLoader.value = false;
  }

  Future<GoogleGeoCodingModel?> getSelectedPlaceLatLng(
      Predictions selectedPlaceDetails) async {
    final response = await getLatLngForSelectedPlaceUseCase.execute(
      GetLatLngForSelectedPlaceUseCaseParams(
        ApiConstants.googleGeoCodingUrl,
        selectedPlaceDetails.placeId ?? '',
      ),
    );
    return response;
  }

  double getMapHeight(BuildContext context) =>
      // SLSessionManager().isUserAuthenticated
      //     ? MediaQuery.of(context).size.height -
      //         AppStrings.bottomNavBarHeight -
      //         safeAreaPadding
      //     :
      MediaQuery.of(context).size.height;

  double get lastZoomComputed => lastZoomByUser();

  Future<void> navToNextPageOnMapViewTap() async {
    trackMapClick();
    trackState(AnalyticsScreenName.mapviewScreen);
    SLSessionManager().isUserAuthenticated = false;

    // if (canShowCardholderSetup()) {
    //   AdminRouteHelper.cardholderSetupPageOne();
    // } else {
    //   await navigateToSiteLocatorMapViewPage();
    // }
  }

  Future<void> navigateToSiteLocatorMapViewPage() async {
    mapFullViewInitStatus();
    isShowBackButton = true;
    safeAreaPadding = 0;

    cameraPositionZoom(lastZoomByUser());

    // await Get.toNamed(
    //   AdminRoutes.siteLocatorMapView,
    //   arguments: {'currentUserLocation': currentLocation},
    // )?.then((val) async {
    //   await onReCenterButtonClicked(
    //     mapController: welcomeGoogleMapController,
    //   );
    // });
  }

  Future<void> navigateToCardholderSiteLocatorMap() async {
    trackWalletSiteLocatorClick();
  }

  Future<void> onMapViewTap() async {
    // if (isWelcomeScreen) {
    //   await navToNextPageOnMapViewTap();
    // } else {
    //   await navigateToCardholderSiteLocatorMap();
    // }
  }

  void _clearSiteListItemIfNecessary() {
    siteLocationDisplayData.clear();
    listViewItems.clear();
  }

  Future<void> recenterMapOnLocationChange() async {
    if (canRecenterMapViewOnLocationChange) {
      forceResetCanRecenterMapView = true;
      await onReCenterButtonClicked();
    }
  }

  Future<void> onShareYourLocationClick() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
      }

      await checkLocationPermission();

      if (!isLocationEnabled) {
        final permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          await onMapViewResume();
        } else {
          await openAppSettings();
        }
      } else {
        await onMapViewResume();
      }
    } catch (_) {}
    await Geolocator.requestPermission();
  }

  Future<void> onMapViewResume() async {
    await checkLocationPermission();
    unawaited(getMilesForSites());
    await recenterMapOnLocationChange();
  }

  Future<void> getInitialPageLoadData(
      {GoogleMapController? mapController}) async {
    try {
      // isShowLoading(true);

      await checkAndRequestLocationPermission();
      await _getUserLocation();
      await calcLatLngBoundsAndZoomLevels(mapController: mapController);
      await checkLocationPermission();
      if (isFirstLaunch) {
        Future.delayed(
          const Duration(milliseconds: 50),
          () => welcomeGoogleMapController?.moveCamera(
            CameraUpdate.newLatLngBounds(currentLatLngBounds(), mapPadding),
          ),
        );
      }

      // isShowLoading(false);
      isShowSearchThisArea(false);
      sitesLoadingProgressController.isMapPositionChanged(false);
    } on Exception catch (e) {
      isShowLoading(false);

      Globals().dynatrace.logError(
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

  Future<void> onSearchThisAreaButtonTap() async {
    try {
      isShowLoading(true);
      fireDynatraceFuelPriceAPILogs('onSearchThisAreaButtonTap');

      /// hasToCallOnZoomGesture is true then zoomed out
      /// hasToCallOnZoomGesture is false then zoomed in
      final hasToCallOnZoomGesture = await canMakeAPICallOnZoomGesture();
      // no need to cache the sites when perform clicking of 'Search this area' button.
      await getSiteLocationsData(forceApiCall: hasToCallOnZoomGesture);

      isShowLoading(false);
    } catch (e) {
      isShowLoading(false);
      Globals().dynatrace.logError(
            name: 'error on search this area button tap',
            value: e.toString(),
            reason: e.toString(),
          );
    }
  }

  void _getZoomInZoomOutTrackAction(bool hasToMakeAPICall) {
    if (hasToMakeAPICall) {
      trackAction(
        AnalyticsTrackActionName.mapZoomOutEvent,
        // adobeCustomTag: AdobeTagProperties.mapView,
      );
    } else {
      trackAction(
        AnalyticsTrackActionName.mapZoomInEvent,
        // adobeCustomTag: AdobeTagProperties.mapView,
      );
    }
  }

  void getFilterTapTrackAction() {
    trackAction(
      AnalyticsTrackActionName.filtersButtonClickedEvent,
      // adobeCustomTag: AdobeTagProperties.mapView,
    );
  }

  void getListViewTapTrackAction() {
    trackAction(
      AnalyticsTrackActionName.listviewButtonsClickedEvent,
      // adobeCustomTag: AdobeTagProperties.mapView,
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
    // if (Get.currentRoute == AdminRoutes.siteLocationsListView) {
    //   trackAction(
    //     AnalyticsTrackActionName.listViewScreenExecuteSearchEvent,
    //     adobeCustomTag: AdobeTagProperties.listView,
    //   );
    // } else {
    //   trackAction(
    //     AnalyticsTrackActionName.executeSearchEvent,
    //     adobeCustomTag: AdobeTagProperties.mapView,
    //   );
    // }
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

  // Future<void> initAuthenticatedMapView(
  //     {GoogleMapController? mapController}) async {
  //   isExecuteCameraMoveForCardHolderOnFirstLaunch = false;
  //   SLSessionManager().isUserAuthenticated = true;
  //   isShowBackButton = false;
  //   canRecenterMapViewOnLocationChange = true;

  //   //if location permission is not given earlier, asking again after login.
  //   await checkAndRequestLocationPermission();

  //   final loginUserType = LocalStorageAdapter.getLoginUserType();
  //   if (loginUserType.isNotEmpty &&
  //       loginUserType == SLInternalText.cardholder) {
  //     if (Get.previousRoute == Routes.login) {
  //       await _getUserLocation();
  //     }
  //     await calcLatLngBoundsAndZoomLevels(mapController: mapController);
  //   }
  // }

  Future<void> resetMapUiOnLogout({bool canCallUserLocation = true}) async {
    SLSessionManager().isUserAuthenticated = false;
    isFirstLaunch = true;
    searchPlacesController.resetUI();
    selectedPlace = null;
    if (canCallUserLocation) {
      await _getUserLocation();
      await calcLatLngBoundsAndZoomLevels();
      await recenterMapOnLocationChange();
    }
  }

  // Cluster region
  void generateHashmapForCluster() {
    generateSiteHashmapUseCase.execute(
      GenerateSiteHashmapParams(
        siteHashmap: siteHashmap,
        sites: siteList(),
      ),
    );
  }

  ///
  ///// Optional : This number represents the percentage (0.2 for 20%) of latitude and longitude (in each direction) to be
  /// considered on top of the visible map bounds to render clusters. This way, clusters don't "pop out" when you cross the map.

  // TODO(Smeet): Cluster work.
  Future<void> generateClusterData(List<Marker> markers) async {
    final _items = markers.map((e) {
      return SiteMapMarker(
        site: siteHashmap[e.position],
        marker: e,
        latLng: e.position,
      );
    }).toList();
    clusterManager = ClusterManager<SiteMapMarker>(
      _items,
      _updateMarkers,
      markerBuilder: _markerBuilder,
      // levels: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17],
      // stopClusteringZoom: 17.0,
      clusterAlgorithm: UmaSLProperties.clusterAlgorithm,
    );
    await clusterManager?.setMapId(googleMapController!.mapId);
  }

  void _updateMarkers(Set<Marker> markers) {
    this.markers.value = markers.toList();
    this.markers.refresh();
  }

  Future<Marker> Function(Cluster<SiteMapMarker>) get _markerBuilder =>
      (cluster) async {
        if (cluster.isMultiple) {
          return Marker(
            markerId: MarkerId(cluster.getId()),
            position: cluster.location,
            icon: await _getClusterBitmap(cluster),
            onTap: () => _onClusterTap(cluster.items.toList()),
          );
        } else {
          return Marker(
            markerId: cluster.items.first.marker.markerId,
            position: cluster.location,
            consumeTapEvents: true,
            // icon: cluster.items.first.marker.icon,
            icon: _getMarkerBitmap(cluster.items.first),
            onTap: () => _onMarkerTap(cluster.items.first),
          );
        }
      };

  Future<void> _onMarkerTap(SiteMapMarker mapMarker) async {
    final markerDetails = PinVariantStore.statusList.firstWhereOrNull(
      (e) => e.site.id == mapMarker.site?.id,
    );
    if (markerDetails != null) {
      await onMarkerTap(markerDetails);
    }
  }

  Future<void> _onClusterTap(List<SiteMapMarker> markers) async {
    resetMarkers(PinVariantStore.statusList);
    isClusterClick = true;
    final markersLatLng = markers.map((e) => e.latLng).toList();
    final position = MapUtilities.getBoundsFromLatLngs(markersLatLng);
    var zoomLevel = await googleMapController?.getZoomLevel();

    if (!inFullMapViewScreen) {
      zoomLevel = await welcomeGoogleMapController?.getZoomLevel();
    }

    final newCenterPosition = MapUtilities.latLngBoundCenter(
      northeast: position.northeast,
      southwest: position.southwest,
    );

    if (zoomLevel != null) {
      final newZoomLevel = zoomLevel + 1.5;
      if (inFullMapViewScreen) {
        await googleMapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            newCenterPosition,
            newZoomLevel >= 21 ? 21 : newZoomLevel,
          ),
        );
      } else {
        await welcomeGoogleMapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            newCenterPosition,
            newZoomLevel >= 21 ? 21 : newZoomLevel,
          ),
        );
      }
    }
  }

  Future<BitmapDescriptor> _getClusterBitmap(
      Cluster<SiteMapMarker> cluster) async {
    bool hasLowestFuelPriceMarker = false;
    double? bestPriceInCluster;
    try {
      if (lowestFuelPrice != null && lowestFuelPrice! > 0) {
        hasLowestFuelPriceMarker = _validateClusterHasLowestFuelPrice(
          lowestFuelPrice!,
          cluster.items.toList(),
        );
      }
      if (!hasLowestFuelPriceMarker) {
        bestPriceInCluster =
            calculateBestPriceInCluster(cluster.items.toList());
      }
    } catch (_) {}
    return getSiteCluster(
      cluster,
      hasLowestFuelPriceMarker: hasLowestFuelPriceMarker,
      bestPriceInCluster: bestPriceInCluster,
    );
  }

  BitmapDescriptor _getMarkerBitmap(SiteMapMarker mapMarker) {
    final markerDetails = PinVariantStore.statusList.firstWhereOrNull(
      (e) => e.site.id == mapMarker.site?.id,
    );
    if (markerDetails != null) {
      if (selectedMapPinKey == markerDetails.keyIdentifier) {
        return markerDetails.bigIcon;
      } else {
        return markerDetails.smallIcon;
      }
    } else {
      return mapMarker.marker.icon;
    }
  }

  double? calculateBestPriceInCluster(List<SiteMapMarker> mapMarkers) {
    double? bestPrice;
    for (final marker in mapMarkers) {
      final price = marker.site?.price;
      if (price != null && price >= 0) {
        if (bestPrice == null || price < bestPrice) {
          bestPrice = price;
        }
      }
    }
    return bestPrice;
  }

  Future<BitmapDescriptor> getSiteCluster(
    Cluster<SiteMapMarker> cluster, {
    bool hasLowestFuelPriceMarker = false,
    double? bestPriceInCluster,
  }) async {
    return CustomPin.getClusterBitmap(
      text: cluster.count.toString(),
      lowestFuelPrice: hasLowestFuelPriceMarker ? lowestFuelPrice : null,
      bestPriceInCluster: !hasLowestFuelPriceMarker ? bestPriceInCluster : null,
    );
  }

  bool _validateClusterHasLowestFuelPrice(
    double lowestFuelPrice,
    List<SiteMapMarker> mapMarkers,
  ) {
    for (final marker in mapMarkers) {
      if (marker.site?.price != null && marker.site!.price! >= 0) {
        final price = marker.site!.price!;
        if (price == lowestFuelPrice) {
          return true;
        }
      }
    }
    return false;
  }

  // Future<void> generateClusterData(List<Marker> markers) async {
  //   final _mapMarkers = markers.map((marker) {
  //     final int row =
  //         ((marker.position.latitude + 90) ~/ gridManager.gridCellSize)
  //             .clamp(0, gridManager.rowCount - 1);
  //     final int column =
  //         ((marker.position.longitude + 180) ~/ gridManager.gridCellSize)
  //             .clamp(0, gridManager.columnCount - 1);
  //     return SiteMapMarker(
  //       id: marker.markerId.value,
  //       position: marker.position,
  //       row: row,
  //       column: column,
  //       icon: marker.icon,
  //       site: siteHashmap[marker.position],
  //     );
  //   }).toList();

  //   markerCluster = MarkerCluster<SiteMapMarker>(
  //     minZoom: 0,
  //     maxZoom: 21,

  //     /// Logic to maintain same data on the map view and list view is with cluster only.
  //     /// So, when cluster is enable fetch density from remote config, and when
  //     /// cluster is disable then density is 999999, so no cluster will be
  //     /// display on the map.
  //     clusterDensity:
  //         isClusterEnabled ? UmaSLProperties.clusterDensity : 999999,
  //     points: _mapMarkers,
  //     // ignore: avoid_types_on_closure_parameters
  //     createCluster: (BaseCluster? cluster, double? lng, double? lat) {
  //       lat ??= 0.0;
  //       lng ??= 0.0;
  //       final int row = ((lat + 90) ~/ gridManager.gridCellSize)
  //           .clamp(0, gridManager.rowCount - 1);
  //       final int column = ((lng + 180) ~/ gridManager.gridCellSize)
  //           .clamp(0, gridManager.columnCount - 1);

  //       return SiteMapMarker(
  //         isCluster: cluster?.isCluster,
  //         pointsSize: cluster?.pointsSize,
  //         id: cluster?.id.toString() ?? '',
  //         position: LatLng(lat, lng),
  //         row: row,
  //         column: column,
  //       );
  //     },
  //   );

  //   await applyClustering();
  // }

  // Future<void> applyClustering([double? zoom]) async {
  //   if (markerCluster == null) {
  //     return;
  //   }
  //   double? appliedZoom = zoom;
  //   final defaultZoomLevel = SiteLocatorConfig.mapZoomLevel;
  //   if (isWelcomeScreen || isAuthenticatedWelcomeScreen) {
  //     appliedZoom = currentZoomLevel ?? defaultZoomLevel;
  //   } else {
  //     try {
  //       appliedZoom ??=
  //           await googleMapController?.getZoomLevel() ?? defaultZoomLevel;
  //     } catch (_) {
  //       appliedZoom = currentZoomLevel ?? defaultZoomLevel;
  //     }
  //   }

  //   final applyClusterParam = ApplyClusterParams(
  //     markerCluster: markerCluster!,
  //     currentZoom: appliedZoom.toInt(),
  //     getSiteCluster: getSiteCluster,
  //     getSiteMarker: getSiteMarker,
  //     lowestFuelPrice: lowestFuelPrice,
  //   );

  //   final markersList = await applyClusterUseCase.execute(applyClusterParam);
  //   await Future.delayed(const Duration(milliseconds: 50));
  //   markers.clear();
  //   if (markersList.isNotEmpty) {
  //     markers.addAll(markersList);
  //   }
  // }

  // Future<Marker> getSiteCluster(
  //   SiteMapMarker cluster, {
  //   bool hasLowestFuelPriceMarker = false,
  // }) async {
  //   final icon = await CustomPin.getClusterBitmap(
  //     text: cluster.pointsSize.toString(),
  //     lowestFuelPrice: hasLowestFuelPriceMarker ? lowestFuelPrice : null,
  //   );
  //   return Marker(
  //     markerId: MarkerId(cluster.id.toString()),
  //     position: cluster.position,
  //     consumeTapEvents: true,
  //     icon: icon,
  //     onTap: () => _onClusterTap(cluster),
  //   );
  // }

  // Future<void> _onClusterTap(SiteMapMarker cluster) async {
  //   if (markerCluster == null) {
  //     return;
  //   }
  //   resetMarkers(PinVariantStore.statusList);
  //   isClusterClick = true;
  //   final markers = markerCluster!.points(int.parse(cluster.id));
  //   final markersLatLng = markers.map((e) => e.position).toList();
  //   final position = MapUtilities.getBoundsFromLatLngs(markersLatLng);
  //   var zoomLevel = await googleMapController?.getZoomLevel();

  //   if (!inFullMapViewScreen) {
  //     zoomLevel = await welcomeGoogleMapController?.getZoomLevel();
  //   }

  //   final newCenterPosition = MapUtilities.latLngBoundCenter(
  //     northeast: position.northeast,
  //     southwest: position.southwest,
  //   );

  //   if (zoomLevel != null) {
  //     final newZoomLevel = zoomLevel + 3;
  //     if (inFullMapViewScreen) {
  //       await googleMapController?.animateCamera(
  //         CameraUpdate.newLatLngZoom(
  //           newCenterPosition,
  //           newZoomLevel > 20 ? 20 : newZoomLevel,
  //         ),
  //       );
  //     } else {
  //       await welcomeGoogleMapController?.animateCamera(
  //         CameraUpdate.newLatLngZoom(
  //           newCenterPosition,
  //           newZoomLevel > 20 ? 20 : newZoomLevel,
  //         ),
  //       );
  //     }
  //     await Future.delayed(const Duration(milliseconds: 500));
  //     await applyClustering(newZoomLevel);
  //   }
  // }

  // Marker getSiteMarker(SiteMapMarker marker) {
  //   return Marker(
  //     markerId: MarkerId(marker.id),
  //     position: marker.position,
  //     anchor: PinAnchor.point(price: marker.site?.price),
  //     icon: marker.icon ??
  //         BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  //     consumeTapEvents: true,
  //     onTap: () async {
  //       final markerDetails = await PinVariantStore.getMarkerDetails(
  //         marker.site,
  //         isLowestFuelPrice:
  //             lowestFuelPrice != null && lowestFuelPrice == marker.site?.price,
  //       );
  //       if (markerDetails != null) {
  //         await onMarkerTap(markerDetails);
  //       }
  //     },
  //   );
  // }

  // bool get isClusterEnabled => SiteLocatorConfig.isClusterFeatureEnabled;

  bool isFavoriteSiteLocation(String? siteIdentifier) {
    return favoriteList.contains(siteIdentifier);
  }

  // Cluster end region

  // Future<void> _fetchFromServerOnRefreshScenario() async {
  //   isShowSearchThisArea(false);
  //   isLatLngBoundsChanged(false);
  //   markers.clear();
  //   isShowLoading(true);
  //   // setSitesLoadingProgress(SitesLoadingProgressProps.initialValue);
  //   feedRelayToSitesLoadingProgress();
  //   await fetchSitesFromServer();
  //   rawSiteLocationsForFuelPricesApi =
  //       siteLocations?.map(SiteLocation.clone).toList();
  //   await handleSiteLocationResponse();
  //   isShowLoading(false);
  // }

  // Future<void> refreshFuelPriceApi() async {
  //   try {
  //     if (canFetchSites) {
  //       await _fetchFromServerOnRefreshScenario();
  //     } else {
  //       isShowLoading(true);
  //       // setSitesLoadingProgress(SitesLoadingProgressProps.initialValue);
  //       await reassemblePinDropLogoAssetSetup();
  //       // await getFuelPricesForMarkers(
  //       //   rawSiteLocationsForFuelPricesApi ?? [],
  //       // );
  //       //processing the sitelocations pinmarkers (to update the price banner)
  //       //when only fuelPrice API calls being called
  //       //while selecting the fuel cards
  //       await processSiteLocations(siteLocations ?? []);
  //       await validateSiteLocationWithFilters();
  //     }
  //   } on Exception catch (e) {
  //     Globals().dynatrace.logError(
  //           name: SLInternalText.getSitesAPIErrorName,
  //           value: SLInternalText.getSitesAPIErrorValue,
  //           reason: e.toString(),
  //         );
  //   }
  //   isShowLoading(false);
  //   hideSitesLoadingIndicator();
  // }

  bool get canFetchSites =>
      (lastTimeFetchedMCSites()) || (!lastTimeFetchedMCSites());

  Future<void> onRecenterButtonTap() async {
    if (isShowLoading() || firstTimeLoading()) {
      return;
    }

    firstTimeLoading(true);
    isShowSearchThisArea(false);
    isLatLngBoundsChanged(false);
    sitesLoadingProgressController.isMapPositionChanged(false);
    try {
      await _onRecenterButtonTap();
    } catch (_) {}
    await _completeInitialLoader();
    firstTimeLoading(false);
  }

  Future<void> _onRecenterButtonTap() async {
    trackAction(
      AnalyticsTrackActionName.recenterButtonClickedEvent,
      // adobeCustomTag: AdobeTagProperties.mapView,
    );
    canClearSearchTextField = true;
    clearSearchPlaceInput();
    isRecenterTap = true;
    await onReCenterButtonClicked();
  }

  // Future<void> onMapViewBackButtonPressed() async {
  //   backFromWelcomeToMapView(true);
  //   if (!isShowLoading()) {
  //     unawaited(onRecenterButtonTap());
  //     resetMarkers(PinVariantStore.statusList);
  //     await moveCameraPosition(reCenterLatLngBounds);
  //     modifyCircleSize();

  //     if (Get.isDialogOpen ?? false) {
  //       Get.back();
  //     }
  //     final isSiteLocatorMapView = await _isUnAuthenticatedMapView();
  //     if (isSiteLocatorMapView) {
  //       await NavTo.welcome();
  //     } else {
  //       Get.back();
  //     }
  //   }
  // }

  Future<void> regenerateMcMarkerPins() async {
    siteLocations =
        rawSiteLocationsWithFuelPrice.map(SiteLocation.clone).toList();
    // ManageSitesPurge.removeSitesPerAsOfDate(siteLocations);
    await processSiteLocations(siteLocations ?? []);
    await validateSiteLocationWithFilters();
  }

  Future<void> checkLocationPermission() async {
    isLocationEnabled = await MapUtilities.getLocationPermissionStatus();
  }

  bool isLowestFuelPriceSite(SiteLocation siteLocation) {
    return lowestFuelPrice != null &&
        siteLocation.masterIdentifier.isNotNullEmptyOrWhitespace &&
        sitesIdentifierWithLowestFuelPrice
            .contains(siteLocation.masterIdentifier);
  }

  void _sortListByRatings() {
    sortListByRatings.value =
        getSiteLocationsForListView().map(SiteLocation.clone).toList();

    sortListByRatings().sort((a, b) {
      final aRating = a.ratings ?? PlaceRatingEntity.noRating;
      final bRating = b.ratings ?? PlaceRatingEntity.noRating;
      return bRating.compareTo(aRating);
    });

    sortListByRatings.refresh();
  }

  void _sortListByDistance() {
    final list = getSiteLocationsForListView().map(SiteLocation.clone).toList();
    if (isLocationEnabled) {
      list.sort((a, b) {
        final aMilesStr = displayMiles(a);
        final bMillesStr = displayMiles(b);

        final aMiles = double.tryParse(aMilesStr.replaceFirst(' mi', '')) ?? -1;
        final bMiles =
            double.tryParse(bMillesStr.replaceFirst(' mi', '')) ?? -1;

        if (aMiles < 0 && bMiles >= 0) {
          return 1;
        }
        if (bMiles < 0 && aMiles >= 0) {
          return -1;
        }

        return aMiles.compareTo(bMiles);
      });
    }

    sortListByDistance.value = list;
    sortListByDistance.refresh();
  }

  void _sortListByPrice() {
    sortListByPrice.value =
        getSiteLocationsForListView().map(SiteLocation.clone).toList();

    sortListByPrice().sort((a, b) {
      // final aPriceStr = a.retailPriceDiesel;
      // final bPriceStr = b.retailPriceDiesel;
      final aPriceStr = DcSiteLocatorUtils.getFuelPriceForMarker(a);
      final bPriceStr = DcSiteLocatorUtils.getFuelPriceForMarker(b);

      final aPrice = aPriceStr ?? -1;
      final bPrice = bPriceStr ?? -1;

      if (aPrice < 0 && bPrice >= 0) {
        return 1;
      }
      if (bPrice < 0 && aPrice >= 0) {
        return -1;
      }

      return aPrice.compareTo(bPrice);
    });

    sortListByPrice.refresh();
  }

  // Map<String, dynamic> filterJsonData = {};
  final RxBool firstTimeLoading = false.obs;
  final RxBool isListLoading = false.obs;
  final RxInt selectedSiteListIndex = (-1).obs;
  double lastSearchedRadius = 0;
  Future<void> onFilterSelected() async {
    firstTimeLoading(true);
    try {
      await getSiteLocationsData();
    } catch (_) {}
    firstTimeLoading(false);
  }

  String getFormattedAcceptedCards(SiteLocation siteLocation) {
    return getCardAcceptedUseCase.execute(siteLocation);
  }

  void updateRecentViewLocations(SiteLocation siteLocation) {
    if (recentViewSiteLocations().contains(siteLocation)) {
      recentViewSiteLocations().remove(siteLocation);
    }
    recentViewSiteLocations().insert(0, siteLocation);
  }

  void onRecentViewListItemClick(SiteLocation siteLocation) {
    final markerDetail = PinVariantStore.statusList.firstWhereOrNull(
      (e) =>
          e.keyIdentifier == siteLocation.masterIdentifier &&
          e.site.shopName == siteLocation.locationName,
    );

    if (markerDetail != null) {
      // TODO(Smeet): Check if markerDetail is displayed on the map.
      if (isListViewOpenedFull()) {
        isListViewOpenedFull(false);
        listViewPanelController.close();
      }
      onMarkerTap(markerDetail);
    } else {
      // TODO(Smeet): Handle the case where the marker detail is not found.
    }
  }

  void resetData() {
    siteLocations = [];
    filteredSiteLocationsList = [];
    markers.clear();
    sortListByDistance.clear();
    sortListByPrice.clear();
    sortListByRatings.clear();
    selectedListTabIndex = 0;
  }
}
