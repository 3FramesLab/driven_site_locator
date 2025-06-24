part of search_location_module;

class SLGetSelectedPlaceLatLngUseCase extends BaseFutureUseCase<
    GoogleGeoCodingModel?, GetLatLngForSelectedPlaceUseCaseParams> {
  final SLSiteLocationsService siteLocationsService;
  SLGetSelectedPlaceLatLngUseCase({required this.siteLocationsService});
  @override
  Future<GoogleGeoCodingModel?> execute(
          GetLatLngForSelectedPlaceUseCaseParams param) async =>
      await siteLocationsService.fetchPlaceLatLngByPlaceId(
        param.googleGeoCodingUrl,
        param.placeId,
      );
}

class GetLatLngForSelectedPlaceUseCaseParams {
  String googleGeoCodingUrl;
  String placeId;
  GetLatLngForSelectedPlaceUseCaseParams(
    this.googleGeoCodingUrl,
    this.placeId,
  );
}
