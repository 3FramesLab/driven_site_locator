part of location_cache_module;

class ValidateLastSavedCenterLocationUseCase
    extends BaseFutureUseCase<bool, LatLng> {
  @override
  Future<bool> execute(LatLng param) async {
    final lastLatLngStr = Globals.sharedPreferences.getString(
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

    final thresholdValueForDistance = AppUtils.isComdata
        ? SiteLocatorConstants.thresholdDistanceForDFCSitesUpdateInMeters
        : SiteLocatorConstants.thresholdDistanceForSitesUpdateInMeters;

    if (distanceGap > thresholdValueForDistance) {
      return true;
    }
    return false;
  }
}
