import 'package:device_info_plus/device_info_plus.dart';
import 'package:driven_site_locator/data/use_cases/base_usecase.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:get/get.dart';

class GetLocationDialogContentUseCase
    extends BaseNoParamUseCase<List<TextSpan>> {
  final SiteLocatorController siteLocatorController = Get.find();

  @override
  List<TextSpan> execute() {
    final browserInfo = siteLocatorController.browserInfoData;
    return getBrowserName(browserInfo);
  }

  List<TextSpan> getBrowserName(WebBrowserInfo browserInfo) {
    if (browserInfo.browserName.name == 'chrome') {
      return [
        const TextSpan(
          text: SiteLocatorConstants.enableLocationText,
          style: f14RegularBlack,
        ),
        const TextSpan(
          text: SiteLocatorConstants.howToDoItText,
          style: f14SemiboldBlack,
        ),
        const TextSpan(
          text: SiteLocatorConstants.useMyLocationChrome,
          style: f14RegularBlack,
        )
      ];
    } else if (browserInfo.browserName.name == 'safari') {
      return [
        const TextSpan(
          text: SiteLocatorConstants.enableLocationText,
          style: f14RegularBlack,
        ),
        const TextSpan(
          text: SiteLocatorConstants.howToDoItText,
          style: f14SemiboldBlack,
        ),
        const TextSpan(
          text: SiteLocatorConstants.useMyLocationSafari,
          style: f14RegularBlack,
        )
      ];
    } else {
      return [
        const TextSpan(
          text: SiteLocatorConstants.enableLocationText,
          style: f14RegularBlack,
        ),
      ];
    }
  }
}
