part of location_cache_module;

class LocationCacheUtils {
  static final LocationCacheUtils _singleton = LocationCacheUtils._internal();

  factory LocationCacheUtils() => _singleton;

  LocationCacheUtils._internal();

  ShouldFetchSitesFromRemoteUseCase shouldFetchSitesFromRemoteUseCase =
      ShouldFetchSitesFromRemoteUseCase();
  GetLocationCacheFileUseCase getLocationCacheFileUseCase =
      GetLocationCacheFileUseCase();
  WriteSitesInLocationCacheUseCase writeSitesInLocationCacheUseCase =
      WriteSitesInLocationCacheUseCase();
  ReadSitesFromLocationCacheUseCase readSitesFromLocationCacheUseCase =
      ReadSitesFromLocationCacheUseCase();
  ValidateLastSavedCenterLocationUseCase validateLastCenterLocationUseCase =
      ValidateLastSavedCenterLocationUseCase();

  Future<bool> shouldFetchSitesFromRemote(
      LatLng currentLocation, double mapRadius) async {
    return (await _validateLastSyncTimeSites(mapRadius)) ||
        (await _validateLastCurrentLocSites(currentLocation));
  }

  Future<bool> _validateLastCurrentLocSites(LatLng currentLocation) async {
    return validateLastCenterLocationUseCase.execute(currentLocation);
  }

  Future<bool> _validateLastSyncTimeSites(double mapRadius) async {
    return shouldFetchSitesFromRemoteUseCase
        .execute(ShouldFetchSitesFromRemoteParams(mapRadius));
  }

  Future<bool> writeLocationCache({
    required List<SiteLocation> sites,
    required LatLng centerLocation,
    required double mapRadius,
  }) async {
    return safeLaunchAsync<bool>(
      SitesLocationCacheConstants.writeSitesLocationCache,
      tryAction: () async =>
          _writeLocationCache(sites, centerLocation, mapRadius),
      catchAction: () async => false,
    );
  }

  Future<bool> _writeLocationCache(
    List<SiteLocation> sites,
    LatLng centerLocation,
    double mapRadius,
  ) async {
    final writeSitesInLocationCacheParams = WriteSitesInLocationCacheParams(
      sites: sites,
      locationCacheFile: await _locationCacheFile,
      centerLocation: centerLocation,
      mapRadius: mapRadius,
    );

    return writeSitesInLocationCacheUseCase.execute(
      writeSitesInLocationCacheParams,
    );
  }

  Future<List<SiteLocation>?> readLocationCache() async {
    return safeLaunchAsync<List<SiteLocation>?>(
      SitesLocationCacheConstants.readSitesLocationCache,
      tryAction: _readLocationCache,
      catchAction: () async => [],
    );
  }

  Future<List<SiteLocation>?> _readLocationCache() async {
    final readSitesFromLocationCacheParams = ReadSitesFromLocationCacheParams(
      locationCacheFile: await _locationCacheFile,
    );
    return readSitesFromLocationCacheUseCase.execute(
      readSitesFromLocationCacheParams,
    );
  }

  Future<File> get _locationCacheFile async =>
      getLocationCacheFileUseCase.execute();
}
