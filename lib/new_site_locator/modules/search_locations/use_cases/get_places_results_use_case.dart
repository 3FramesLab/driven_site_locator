part of search_location_module;

class SLGetPlacesResultUseCase
    extends BaseFutureUseCase<GooglePlacesModel?, GetPlacesResultParams> {
  final SLSiteLocationsService siteLocationsService;
  SLGetPlacesResultUseCase({required this.siteLocationsService});
  @override
  Future<GooglePlacesModel?> execute(GetPlacesResultParams param) async =>
      await siteLocationsService.fetchPlacesData(
        param.googlePlacesAutoCompleteUrl,
        param.searchText,
        currentLocation: param.currentLocation,
      );
}

class GetPlacesResultParams {
  String googlePlacesAutoCompleteUrl;
  String searchText;
  String currentLocation;
  GetPlacesResultParams(
    this.googlePlacesAutoCompleteUrl,
    this.searchText,
    this.currentLocation,
  );
}
