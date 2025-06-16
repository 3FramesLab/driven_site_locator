part of site_locator_module;

extension LatLngBoundsExtension on LatLngBounds {
  bool isInside({required LatLngBounds? outerBounds}) {
    if (outerBounds == null) {
      return false;
    }
    return outerBounds.contains(southwest) && outerBounds.contains(northeast);
  }
}
