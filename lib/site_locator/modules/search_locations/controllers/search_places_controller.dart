part of search_location_module;

class SearchPlacesController extends GetxController with SearchLocationState {
  SiteLocationsService siteLocationsService = Get.find();
  RxList<Predictions> placesList = <Predictions>[].obs;

  @override
  void onInit() {
    super.onInit();
    initUseCases();
  }

  void initUseCases() {
    getPlacesResultUseCase = Get.put(
        GetPlacesResultUseCase(siteLocationsService: siteLocationsService));
    getPlacesURLUseCase = Get.put(GetPlacesURLUseCase());
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
      print(placesList);
    } catch (_) {
      Globals().dynatrace.logError(
            name: DynatraceErrorMessages.placesAPIErrorName,
            value: DynatraceErrorMessages.placesAPIErrorValue,
          );
    }
    isLoading(false);
  }

  Color get getIconBGColor => searchIconName() == SiteLocatorConstants.search
      ? Colors.black
      : Colors.white;

  Color get getIconColor => searchIconName() == SiteLocatorConstants.search
      ? Colors.white
      : Colors.black;

  IconData get getIcon => searchIconName() == SiteLocatorConstants.search
      ? Icons.search
      : Icons.clear;

  Future<void> getUpdatedSitesData(
    SiteLocatorController siteLocatorController,
  ) async =>
      siteLocatorController.onReCenterButtonClicked();

  Future<void> resetMapViewOnClearSearchTextfield(
    SiteLocatorController siteLocatorController,
  ) async =>
      getUpdatedSitesData(siteLocatorController);

  Future<void> resetListViewOnClearSearchTextfield(
    SiteLocatorController siteLocatorController,
  ) async {
    siteLocatorController.isInitialListLoading(true);
    await getUpdatedSitesData(siteLocatorController);
    await siteLocatorController.setListViewInitializers();
    siteLocatorController.isInitialListLoading(false);
  }

  void resetUI() {
    searchTextEditingController.text = '';
    searchIconName(SiteLocatorConstants.search);
  }

  void clearTextInput() {
    searchTextEditingController.clear();
    searchText = '';
    searchIconName(SiteLocatorConstants.search);
  }
}
