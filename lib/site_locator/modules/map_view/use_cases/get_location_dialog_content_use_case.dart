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
    if (GetPlatform.isAndroid) {
      return _defaultLocationEnableText;
    } else if (GetPlatform.isIOS) {
      return [
        const TextSpan(
          text: SiteLocatorConstants.enableLocationTextForIOS,
          style: f14RegularBlack,
        )
      ];
    } else {
      final browserName = siteLocatorController.browserName.value;
      return getLocationDialogContent(browserName);
    }
  }

  List<TextSpan> getLocationDialogContent(String browserName) {
    if (browserName == SiteLocatorConstants.chromeBrowser) {
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
    } else if (browserName == SiteLocatorConstants.safariBrowser) {
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
      return _defaultLocationEnableText;
    }
  }

  List<TextSpan> get _defaultLocationEnableText => [
        const TextSpan(
          text: SiteLocatorConstants.enableLocationText,
          style: f14RegularBlack,
        )
      ];
}
