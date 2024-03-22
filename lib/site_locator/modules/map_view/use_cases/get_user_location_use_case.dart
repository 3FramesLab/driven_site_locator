part of map_view_module;

class GetUserLocationUseCase extends BaseNoParamFutureUseCase<LatLng> {
  @override
  Future<LatLng> execute() async {
    var currentUserLocation = SiteLocatorConstants.defaultUserLocation;
    if (kIsWeb) {
      try {
        if (SiteLocatorStorageUtils.getIsLocationPermissionAllowed()) {
          final currentUserPosition = await Geolocator.getCurrentPosition();
          currentUserLocation = LatLng(
              currentUserPosition.latitude, currentUserPosition.longitude);
        }
        return currentUserLocation;
      } catch (_) {
        await SiteLocatorStorageUtils.setIsLocationPermissionAllowed(
            value: false);
        return currentUserLocation;
      }
    } else {
      final permissionStatus = await Geolocator.checkPermission();
      if (permissionStatus == LocationPermission.always ||
          permissionStatus == LocationPermission.whileInUse) {
        final currentUserPosition = await Geolocator.getCurrentPosition();
        currentUserLocation =
            LatLng(currentUserPosition.latitude, currentUserPosition.longitude);
      }
      return currentUserLocation;
    }
  }
}
