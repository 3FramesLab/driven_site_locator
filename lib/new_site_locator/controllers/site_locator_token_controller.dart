import 'package:driven_site_locator/config/globals.dart';
import 'package:driven_site_locator/constants/api_constants.dart';
import 'package:driven_site_locator/new_site_locator/data/services/site_locator_access_token_service.dart';
import 'package:driven_site_locator/new_site_locator/new_site_locator_module.dart';
import 'package:get/get.dart';

class SLSiteLocatorAccessTokenController extends GetxController {
  String? siteLocatorAccessToken;

  SLSiteLocatorAccessTokenService siteLocatorAccessTokenService =
      Get.put(SLSiteLocatorAccessTokenService());

  Future<String?> getAccessToken() async {
    final response = await siteLocatorAccessTokenService
        .getAccessToken(ApiConstants.jwtAccessTokenJson);
    if (response != null && response.accessToken != null) {
      siteLocatorAccessToken = response.accessToken;
      await saveAccessToken();
    }
    return siteLocatorAccessToken;
  }

  Future<void> saveAccessToken() async {
    await Globals().sharedPreferences.setString(
        SLInternalText.siteLocatorAccessToken, siteLocatorAccessToken!);
    await Globals().sharedPreferences.setString(
          SLInternalText.siteLocatorAccessTokenLastUpdatedTime,
          DateTime.now().millisecondsSinceEpoch.toString(),
        );
  }
}
