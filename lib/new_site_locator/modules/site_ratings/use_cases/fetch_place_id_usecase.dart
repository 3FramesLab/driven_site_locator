part of site_ratings_module;

class FetchPlaceIDUseCase
    extends BaseFutureUseCase<String, FetchPlaceIDUseCaseParams> {
  final SLSiteLocationsService siteLocationsService;

  FetchPlaceIDUseCase({required this.siteLocationsService});

  @override
  Future<String> execute(FetchPlaceIDUseCaseParams param) async {
    final placeID = await _getPlaceIDFromAPI(param);

    return placeID;
  }

  Future<String> _getPlaceIDFromAPI(FetchPlaceIDUseCaseParams param) async {
    final siteLocation = param.siteLocation;
    final businessName = siteLocation.locationName ?? '';
    final streetAddress = siteLocation.locationStreetAddress ?? '';
    final city = siteLocation.locationCity ?? '';
    final state = siteLocation.locationState ?? '';
    final zip = siteLocation.locationZip ?? '';
    if (businessName.isEmpty) {
      return '';
    }
    if (streetAddress.isEmpty) {
      return '';
    }
    final businessAddress = '$businessName, $streetAddress';
    final searchQuery = '$businessAddress, $city, $state $zip';
    try {
      final result =
          await siteLocationsService.fetchPlaceIDByAddress(searchQuery);
      if (result != null) {
        return _parsePlaceID(result);
      }
      return '';
    } catch (_) {
      return '';
    }
  }

  String _parsePlaceID(PlacesEntity result) {
    if (result.places?.isNotEmpty ?? false) {
      final placeID = result.places![0].id;
      return placeID ?? '';
    }
    return '';
  }
}

class FetchPlaceIDUseCaseParams {
  final SiteLocation siteLocation;

  FetchPlaceIDUseCaseParams({
    required this.siteLocation,
  });
}
