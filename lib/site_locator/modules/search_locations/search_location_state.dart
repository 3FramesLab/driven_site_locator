part of search_location_module;

mixin SearchLocationState {
  final searchTextEditingController = TextEditingController();
  String searchText = '';
  String currentLocation = '';
  RxString searchIconName = SiteLocatorConstants.searchIconName.obs;
  RxBool isLoading = false.obs;

  late GetPlacesResultUseCase getPlacesResultUseCase;
  late GetPlacesURLUseCase getPlacesURLUseCase;
}
