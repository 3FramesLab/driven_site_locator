import 'package:driven_site_locator/data/use_cases/base_future_usecase.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/controllers/site_locator_token_controller.dart';
import 'package:get/get.dart';

class GetAccessTokenForSitesUseCase extends BaseNoParamFutureUseCase<String> {
  @override
  Future<String> execute() async {
    String? siteLocatorAccessToken;
    if (isAccessTokenExpired) {
      final SiteLocatorAccessTokenController siteLocatorAccessTokenController =
          Get.put(SiteLocatorAccessTokenController());
      siteLocatorAccessToken =
          await siteLocatorAccessTokenController.getAccessToken();
    } else {
      siteLocatorAccessToken = PreferenceUtils.getString(
        SiteLocatorConstants.siteLocatorAccessToken,
      );
    }
    return siteLocatorAccessToken ?? '';
  }

  bool get isAccessTokenExpired {
    bool isTokenExpired = true;
    final lastUpdatedTime = PreferenceUtils.getString(
      SiteLocatorConstants.siteLocatorAccessTokenLastUpdatedTime,
    );
    if (lastUpdatedTime != null) {
      final lastUpdatedTimeInDateTime =
          DateTime.fromMillisecondsSinceEpoch(int.parse(lastUpdatedTime));
      final timeDiffInMinutes =
          DateTime.now().difference(lastUpdatedTimeInDateTime).inMinutes;
      if (timeDiffInMinutes <
          SiteLocatorConstants.siteLocatorAccessTokenExpiryTimeInMinutes) {
        isTokenExpired = false;
      }
    }
    return isTokenExpired;
  }
}
