part of search_location_module;

class SLGetPlacesURLUseCase extends BaseNoParamUseCase<String> {
  @override
  String execute() {
    const componentsForFetchingPlaces = 'country:us|country:ca';

    return 'https://maps.googleapis.com/maps/api/place/autocomplete/json?key=${ApiConstants.googleAPIKey}&components=$componentsForFetchingPlaces&radius=${ApiConstants.radiusForFetchingPlaces}';
  }
}
