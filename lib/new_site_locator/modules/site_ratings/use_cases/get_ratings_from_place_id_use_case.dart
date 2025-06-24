part of site_ratings_module;

class GetRatingsFromPlaceIdUseCase
    extends BaseFutureUseCase<double, GetRatingsFromPlaceIdParams> {
  final SLSiteLocationsService siteLocationsService;

  GetRatingsFromPlaceIdUseCase({required this.siteLocationsService});

  @override
  Future<double> execute(GetRatingsFromPlaceIdParams param) async {
    final rating = await getRatingFromAPI(param.placeId);

    return rating;
  }

  Future<double> getRatingFromAPI(String placeId) async {
    try {
      final result = await siteLocationsService.fetchSiteRating(placeId);
      if (result != null) {
        return _parseRating(result);
      }
      return PlaceRatingEntity.noRating;
    } catch (_) {
      return PlaceRatingEntity.error;
    }
  }

  double _parseRating(PlaceRatingEntity result) {
    return result.rating ?? PlaceRatingEntity.noRating;
  }
}

class GetRatingsFromPlaceIdParams {
  final String placeId;

  GetRatingsFromPlaceIdParams({
    required this.placeId,
  });
}
