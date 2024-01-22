part of location_cache_module;

class ValidateLastSavedCenterLocationUseCase
    extends BaseFutureUseCase<bool, LatLng> {
  @override
  Future<bool> execute(LatLng param) async {
    final lastLatLngStr = Globals().sharedPreferences.getString(
          SiteLocatorStorageKeys.lastUserCenterLoc,
        );

    if (lastLatLngStr == null) {
      return true;
    }

    final lastCurrentLocation = MapUtilities.getLatLng(lastLatLngStr);
    final distanceGap = MapUtilities.distanceBetweenTwoLocation(
      lastCurrentLocation,
      param,
    );

    if (distanceGap >
        SiteLocatorConstants.thresholdDistanceForSitesUpdateInMeters) {
      return true;
    }
    return false;
  }
}
