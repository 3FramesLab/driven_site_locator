import 'package:driven_site_locator/config/site_locator_navigation.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/configuration/site_locator_config.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/styles/site_locator_colors.dart';
import 'package:driven_site_locator/site_locator/widgets/site_locator_menu_row.dart';

class HelpCenterMenuCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SiteLocatorMenuRow(
      title: SiteLocatorConstants.helpCenter,
      icon: _helpCenterIcon(),
      buttonAction: navToHelpCenterPage,
    );
  }

  void navToHelpCenterPage() {
    trackAction(
      AnalyticsTrackActionName.menuDrawerHelpCenterLinkClickEvent,
      // adobeCustomTag: AdobeTagProperties.slMenu,
    );
    SiteLocatorNavigation.instance.toCommonWebView(
      url: SiteLocatorConfig.helpCenterUrl,
      title: SiteLocatorConstants.helpCenter,
    );
  }

  Icon _helpCenterIcon() => const Icon(
        Icons.help_center_outlined,
        color: SiteLocatorColors.white,
      );
}
