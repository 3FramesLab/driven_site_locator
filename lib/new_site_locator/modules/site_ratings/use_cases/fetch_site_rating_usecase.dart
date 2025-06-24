part of site_ratings_module;

class FetchSiteRatingUseCase
    extends BaseFutureUseCase<double, FetchSiteRatingUseCaseParams> {
  final SLSiteLocationsService siteLocationsService;
  final FetchPlaceIDUseCase fetchPlaceIDUseCase;

  FetchSiteRatingUseCase({
    required this.siteLocationsService,
    required this.fetchPlaceIDUseCase,
  });

  @override
  Future<double> execute(FetchSiteRatingUseCaseParams param) async {
    final rating = await getRatingFromAPI(param.siteLocation);

    return rating;
  }

  Future<double> getRatingFromAPI(SiteLocation siteLocation) async {
    try {
      final p = FetchPlaceIDUseCaseParams(
        siteLocation: siteLocation,
      );

      final placeID = await fetchPlaceIDUseCase.execute(p);

      if (placeID.isNotEmpty) {
        final result = await siteLocationsService.fetchSiteRating(placeID);
        if (result != null) {
          return _parseRating(result);
        }
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

class FetchSiteRatingUseCaseParams {
  final SiteLocation siteLocation;

  FetchSiteRatingUseCaseParams({
    required this.siteLocation,
  });
}
