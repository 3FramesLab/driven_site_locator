part of search_location_module;

class SLSearchPlacesController extends GetxController with SearchLocationState {
  SLSiteLocationsService siteLocationsService = Get.find();
  RxList<Predictions> placesList = <Predictions>[].obs;
  RxList<Predictions> recentSearches = <Predictions>[].obs;

  RxBool isRecentSearchesVisible = false.obs;

  late SaveGooglePlacePredictionUseCase saveGooglePlacePredictionUseCase;
  late GetGooglePlaceFromPlaceIdUseCase getGooglePlaceFromPlaceIdUseCase;

  @override
  void onInit() {
    super.onInit();
    initUseCases();
  }

  void initUseCases() {
    getPlacesResultUseCase = Get.put(
        GetPlacesResultUseCase(siteLocationsService: siteLocationsService));
    getPlacesURLUseCase = Get.put(GetPlacesURLUseCase());
    saveGooglePlacePredictionUseCase = SaveGooglePlacePredictionUseCase(
      hive: Globals().hive,
    );
    getGooglePlaceFromPlaceIdUseCase = GetGooglePlaceFromPlaceIdUseCase(
      hive: Globals().hive,
    );
  }

  Future<void> getPlacesResults() async {
    isLoading(true);
    try {
      final googlePlacesAutoCompleteUrl = getPlacesURLUseCase.execute();
      final placesResponse = await getPlacesResultUseCase.execute(
        GetPlacesResultParams(
          googlePlacesAutoCompleteUrl,
          searchText,
          currentLocation,
        ),
      );
      placesList(placesResponse?.predictions ?? []);
    } catch (_) {
      Globals().dynatrace.logError(
            name: SLInternalText.placesAPIErrorName,
            value: SLInternalText.placesAPIErrorValue,
          );
    }
    isLoading(false);
  }

  Color get getIconBGColor => searchIconName() == SLInternalText.search
      ? DrivenColors.primary
      : Colors.white;

  Color get getIconColor => searchIconName() == SLInternalText.search
      ? Colors.white
      : DrivenColors.primary;

  IconData get getIcon =>
      searchIconName() == SLInternalText.search ? Icons.search : Icons.clear;

  Future<void> getUpdatedSitesData(
    SLSiteLocatorController siteLocatorController,
  ) async =>
      siteLocatorController.onReCenterButtonClicked();

  Future<void> resetMapViewOnClearSearchTextfield(
    SLSiteLocatorController siteLocatorController,
  ) async =>
      getUpdatedSitesData(siteLocatorController);

  Future<void> resetListViewOnClearSearchTextfield(
    SLSiteLocatorController siteLocatorController,
  ) async {
    siteLocatorController.isInitialListLoading(true);
    await getUpdatedSitesData(siteLocatorController);
    await siteLocatorController.setListViewInitializers();
    siteLocatorController.isInitialListLoading(false);
  }

  void resetUI() {
    searchTextEditingController.text = '';
    searchIconName(SLInternalText.search);
  }

  void clearTextInput() {
    searchTextEditingController.clear();
    searchText = '';
    searchIconName(SLInternalText.search);
  }

  Future<void> getRecentSearches() async {
    final existingPredictions =
        await getGooglePlaceFromPlaceIdUseCase.execute();

    recentSearches(existingPredictions);
    recentSearches.refresh();
  }

  Future<void> savePrediction(Predictions? prediction) async {
    if (prediction != null) {
      prediction.modifiedOn = DateTime.now();

      final existingPredictions =
          await getGooglePlaceFromPlaceIdUseCase.execute();

      if (existingPredictions.contains(prediction)) {
        existingPredictions.remove(prediction);
      }
      existingPredictions.insert(0, prediction);

      await saveGooglePlacePredictionUseCase.execute(
        SaveGooglePlacePredictionParam(predictions: existingPredictions),
      );
    }
  }
}
