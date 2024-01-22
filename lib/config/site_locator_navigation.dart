import 'package:driven_common/common/common_routes.dart';
import 'package:driven_site_locator/config/site_locator_routes.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:get/get.dart';

class SiteLocatorNavigation {
  SiteLocatorNavigation._internal();

  static final SiteLocatorNavigation _instance =
      SiteLocatorNavigation._internal();

  static SiteLocatorNavigation get instance => _instance;

  void toCommonWebView({required String url, required String title}) {
    Get.toNamed(
      CommonRoutes.commonWebView,
      arguments: {
        CommonRouteArguments.webViewUrl: url,
        CommonRouteArguments.webViewTitle: title,
      },
    );
  }

  void cardholderSetupPageOne({dynamic arguments}) =>
      Get.toNamed(SiteLocatorRoutes.cardholderSetupPageOne,
          arguments: arguments);

  void cardholderSetupPageTwo({dynamic arguments}) =>
      Get.offNamed(SiteLocatorRoutes.cardholderSetupPageTwo,
          arguments: arguments);

  void cardholderSetupPageThree({dynamic arguments}) =>
      Get.offNamed(SiteLocatorRoutes.cardholderSetupPageThree,
          arguments: arguments);
}
