import 'package:driven_site_locator/analytics/adobe_tag_properties.dart';
import 'package:driven_site_locator/analytics/site_locator_track_action_name.dart';
import 'package:driven_site_locator/data/model/app_utils.dart';
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
        SiteLocatorAnalyticsTrackActionName.menuDrawerLogoutLinkClickEvent,
        adobeCustomTag: AdobeTagProperties.slMenu.value,
      );
      await DrivenSiteLocator.instance.logoutDialog?.call();
    } else {
      trackAction(
        SiteLocatorAnalyticsTrackActionName.menuDrawerLoginLinkClickEvent,
        adobeCustomTag: AdobeTagProperties.slMenu.value,
      );
      await DrivenSiteLocator.instance.navigateToLogin?.call(
        isCardHolderLogin: AppUtils.isComdata,
      );
    }
  }

  String get _title => siteLocatorController.isUserAuthenticated
      ? SiteLocatorConstants.logout
      : AppUtils.isComdata
          ? SiteLocatorConstants.loginOrSignUp
          : SiteLocatorConstants.login;

  AssetImage get _icon => siteLocatorController.isUserAuthenticated
      ? const AssetImage(SiteLocatorAssets.logoutIcon)
      : const AssetImage(SiteLocatorAssets.loginIcon);
}
