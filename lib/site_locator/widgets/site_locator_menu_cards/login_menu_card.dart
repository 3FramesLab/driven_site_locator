import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/driven_site_locator.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/widgets/site_locator_menu_row.dart';
import 'package:get/get.dart';

class LoginMenuCard extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SiteLocatorMenuRow(
      title: _title,
      imageIcon: _icon,
      buttonAction: handleAuthenticateButtonAction,
    );
  }

  Future<void> handleAuthenticateButtonAction() async {
    if (siteLocatorController.isUserAuthenticated) {
      trackAction(
        AnalyticsTrackActionName.menuDrawerLogoutLinkClickEvent,
        // adobeCustomTag: AdobeTagProperties.slMenu,
      );
      await DrivenSiteLocator.instance.logoutDialog?.call();
    } else {
      trackAction(
        AnalyticsTrackActionName.menuDrawerLoginLinkClickEvent,
        // adobeCustomTag: AdobeTagProperties.slMenu,
      );
      DrivenSiteLocator.instance.navigateToLogin?.call();
    }
  }

  String get _title => siteLocatorController.isUserAuthenticated
      ? SiteLocatorConstants.logout
      : SiteLocatorConstants.login;

  AssetImage get _icon => siteLocatorController.isUserAuthenticated
      ? AssetImage(SiteLocatorAssets.logoutIcon)
      : AssetImage(SiteLocatorAssets.loginIcon);
}
