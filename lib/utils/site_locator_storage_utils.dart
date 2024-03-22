import 'package:driven_common/data/data_module.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_storage_keys.dart';

class SiteLocatorStorageUtils {
  static Future<void> setIsLocationPermissionAllowed(
      {required bool value}) async {
    await PreferenceUtils.setBool(
      SiteLocatorStorageKeys.isLocationPermissionAllowed,
      value: value,
    );
  }

  static bool getIsLocationPermissionAllowed() =>
      PreferenceUtils.getBool(
        SiteLocatorStorageKeys.isLocationPermissionAllowed,
      ) ??
      false;
}
