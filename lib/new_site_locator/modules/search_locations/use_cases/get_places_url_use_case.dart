part of search_location_module;

class GetPlacesURLUseCase extends BaseNoParamUseCase<String> {
  @override
  String execute() {
    var componentsForFetchingPlaces = 'country:us|country:ca';
    if (AppUtils.isFuelman) {
      componentsForFetchingPlaces = 'country:us';
    }
    return 'https://maps.googleapis.com/maps/api/place/autocomplete/json?key=${SiteLocatorApiConstants.googleAPIKey}&components=$componentsForFetchingPlaces&radius=${SiteLocatorApiConstants.radiusForFetchingPlaces}';
  }
}
