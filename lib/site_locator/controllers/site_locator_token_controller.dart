import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_api_constants.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/data/services/site_locator_access_token_service.dart';
import 'package:get/get.dart';

class SiteLocatorAccessTokenController extends GetxController {
  String? siteLocatorAccessToken;

  SiteLocatorAccessTokenService siteLocatorAccessTokenService =
      Get.put(SiteLocatorAccessTokenService());

  Future<String?> getAccessToken() async {
    final response = await siteLocatorAccessTokenService
        .getAccessToken(SiteLocatorApiConstants.siteLocatorAccessTokenJson);
    if (response != null && response.accessToken != null) {
      siteLocatorAccessToken = response.accessToken;
      await saveAccessToken();
    }
    return siteLocatorAccessToken;
  }

  Future<void> saveAccessToken() async {
    await PreferenceUtils.setString(
        SiteLocatorConstants.siteLocatorAccessToken, siteLocatorAccessToken!);
    await PreferenceUtils.setString(
        SiteLocatorConstants.siteLocatorAccessTokenLastUpdatedTime,
        DateTime.now().millisecondsSinceEpoch.toString());
  }
}
