// ignore_for_file: parameter_assignments

import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/utilities/math_utils.dart';
import 'package:driven_site_locator/site_locator/widgets/dialogs/single_function_dialog.dart';
import 'package:driven_site_locator/utils/site_locator_storage_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUtilities {
  static const num earthRadius = 6371009.0;

  static LatLngBounds toBounds(LatLng center, double radiusInMeters) {
    final distanceFromCenterToCorner = radiusInMeters * sqrt(2.0);
    final southwestCorner = computeOffset(
        LatLng(center.latitude, center.longitude),
        distanceFromCenterToCorner / earthRadius,
        MathUtil.toRadians(225.0));
    final northeastCorner = computeOffset(
        LatLng(center.latitude, center.longitude),
        distanceFromCenterToCorner / earthRadius,
        MathUtil.toRadians(45.0));
    return LatLngBounds(
        southwest: LatLng(southwestCorner.latitude, southwestCorner.longitude),
        northeast: LatLng(northeastCorner.latitude, northeastCorner.longitude));
  }

  static LatLng computeOffset(LatLng from, num distance, num heading) {
    final fromLat = MathUtil.toRadians(from.latitude);
    final fromLng = MathUtil.toRadians(from.longitude);
    final cosDistance = cos(distance);
    final sinDistance = sin(distance);
    final sinFromLat = sin(fromLat);
    final cosFromLat = cos(fromLat);
    final sinLat =
        cosDistance * sinFromLat + sinDistance * cosFromLat * cos(heading);
    final dLng = atan2(sinDistance * cosFromLat * sin(heading),
        cosDistance - sinFromLat * sinLat);

    return LatLng(MathUtil.toDegrees(asin(sinLat)).toDouble(),
        MathUtil.toDegrees(fromLng + dLng).toDouble());
  }

  static double latRad(double lat) {
    final double sinValue = sin(lat * pi / 180);
    final double radX2 = log((sinValue + 1) / (1 - sinValue)) / 2;
    return max(min(radX2, pi), -pi) / 2;
  }

  static double getMapBoundZoom(
      LatLngBounds bounds, double mapWidth, double mapHeight) {
    final LatLng northEast = bounds.northeast;
    final LatLng southWest = bounds.southwest;

    final double latFraction =
        (latRad(northEast.latitude) - latRad(southWest.latitude)) / pi;

    final double lngDiff = northEast.longitude - southWest.longitude;
    final double lngFraction =
        ((lngDiff < 0) ? (lngDiff + 360) : lngDiff) / 360;

    final double latZoom =
        (log(mapHeight / 256 / latFraction) / ln2).floorToDouble();
    final double lngZoom =
        (log(mapWidth / 256 / lngFraction) / ln2).floorToDouble();

    return min(latZoom, lngZoom);
  }

  static Future<bool> getLocationPermissionStatus() async {
    if (kIsWeb) {
      try {
        if (SiteLocatorStorageUtils.getIsLocationPermissionAllowed()) {
          await Geolocator.getCurrentPosition();
          return true;
        }
        return false;
      } catch (_) {
        await SiteLocatorStorageUtils.setIsLocationPermissionAllowed(
            value: false);
        return false;
      }
    } else {
      final status = await Geolocator.checkPermission();

      return status == LocationPermission.always ||
          status == LocationPermission.whileInUse;
    }
  }

  static Future<void> onLocationSettingsEnableCounter() async {
    final isLocationPermissionGranted = await getLocationPermissionStatus();
    if (!isLocationPermissionGranted) {
      final int? tapCount = PreferenceUtils.getInt(
          SiteLocatorConstants.locationEnableCounter,
          defaultValue: 0);
      if (tapCount == SiteLocatorConstants.locationEnableDialogCount - 1) {
        if (Get.isDialogOpen ?? false) {
          await Future.delayed(const Duration(
            seconds: SiteLocatorConstants.noLocationsErrorModalTime + 1,
          ));
        }
        showLocationEnableDialog();
      } else {
        await updateTapCount(tapCount! + 1);
      }
    }
  }

  static void showLocationEnableDialog() {
    Get.dialog(
      const SingleFunctionDialog(
        dialogTitle: SiteLocatorConstants.locationEnableDialogTitle,
        buttonTitle: SiteLocatorConstants.locationEnableDialogButtonText,
        onButtonTap: onOpenSettingsButtonPress,
        onCancelTap: onCancelTap,
      ),
      barrierDismissible: false,
    );
  }

  static void onOpenSettingsButtonPress() {
    AppSettings.openAppSettings();
    updateTapCount(0);
    Get.back();
  }

  static void onCancelTap() {
    updateTapCount(0);
    Get.back();
  }

  static Future<void> updateTapCount(int count) async => PreferenceUtils.setInt(
        SiteLocatorConstants.locationEnableCounter,
        value: count,
      );

  static String appendLatLng(LatLng latLng) {
    return '${latLng.latitude},${latLng.longitude}';
  }

  static LatLng getLatLng(String latLng) {
    final values = latLng.split(',');
    return LatLng(double.parse(values[0]), double.parse(values[1]));
  }

  static double distanceBetweenTwoLocation(LatLng from, LatLng to) =>
      Geolocator.distanceBetween(
        from.latitude,
        from.longitude,
        to.latitude,
        to.longitude,
      );

  static LatLng latLngBoundCenter({
    required LatLng northeast,
    required LatLng southwest,
  }) {
    if ((southwest.longitude - northeast.longitude > 180) ||
        (northeast.longitude - southwest.longitude > 180)) {
      southwest = LatLng(southwest.latitude, southwest.longitude + 360);
      southwest = LatLng(southwest.latitude, southwest.longitude % 360);

      northeast = LatLng(northeast.latitude, northeast.longitude + 360);
      northeast = LatLng(northeast.latitude, northeast.longitude % 360);
    }

    return LatLng(
      (southwest.latitude + northeast.latitude) / 2,
      (southwest.longitude + northeast.longitude) / 2,
    );
  }

  static LatLngBounds getBoundsFromLatLngs(List<LatLng> list) {
    double x0 = 0, x1 = 0, y0 = 0, y1 = 0;
    for (final latLng in list) {
      if (x0 == 0) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) {
          x1 = latLng.latitude;
        }
        if (latLng.latitude < x0) {
          x0 = latLng.latitude;
        }
        if (latLng.longitude > y1) {
          y1 = latLng.longitude;
        }
        if (latLng.longitude < y0) {
          y0 = latLng.longitude;
        }
      }
    }
    return LatLngBounds(
      northeast: LatLng(x1, y1),
      southwest: LatLng(x0, y0),
    );
  }
}
