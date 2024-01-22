import 'package:driven_common/analytics/analytics.dart';
import 'package:driven_common/driven_components/driven_components_module.dart';
import 'package:driven_common/globals.dart';
import 'package:driven_common/utils/safe_launch.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SiteLocatorUtils {
  static Future<bool> launchURL(
    String url,
    String errorMessage, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async =>
      await _canSafeLaunchUrl(url)
          ? await _safeLaunchUrl(url, mode)
          : _showFlashErrorMessage(errorMessage);

  static Future<bool> _canSafeLaunchUrl(String url) async => safeLaunchAsync(
        SiteLocatorConstants.launchUrlOrPhone,
        tryAction: () => Globals().canLaunch(url),
        catchAction: () => Future.value(false),
      );

  static Future<bool> _safeLaunchUrl(String url, LaunchMode mode) async =>
      safeLaunchAsync(
        SiteLocatorConstants.launchUrlOrPhone,
        tryAction: () => Globals().launch(url, mode: mode),
        catchAction: () => Future.value(false),
      );

  static bool _showFlashErrorMessage(String errorMessage) {
    BaseDrivenFlashBar.show(message: errorMessage);
    return false;
  }

  static Future<void> openExternalMapApp(
    AvailableMap selectedMap,
    Coords destinationLatLng,
  ) async {
    await safeLaunchAsync(
      SiteLocatorConstants.launchDirections,
      tryAction: () => _openExternalAppTap(selectedMap, destinationLatLng),
      catchAction: () => Future.value(false),
    );
  }

  String getCSVFromList(List<dynamic> stringList) => stringList.join(', ');

  static void hideKeyboard() {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
    } catch (_) {}
  }

  static Future<void> _openExternalAppTap(
      AvailableMap selectedMap, Coords destinationLatLng) async {
    trackAction(
      AnalyticsTrackActionName.siteInfoDrawerViewAllDiscountsLinkClickEvent,
    );
    await selectedMap.showDirections(destination: destinationLatLng);
  }
}
