import 'package:google_maps_flutter/google_maps_flutter.dart';

extension LatLngBoundsExtension on LatLngBounds {
  bool isInside({required LatLngBounds? outerBounds}) {
    if (outerBounds == null) {
      return false;
    }
    return outerBounds.contains(southwest) && outerBounds.contains(northeast);
  }
}
