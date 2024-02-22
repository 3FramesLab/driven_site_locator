import 'package:driven_site_locator/config/site_locator_navigation.dart';
import 'package:driven_site_locator/constants/api_constants.dart';
import 'package:driven_site_locator/constants/app_strings.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/styles/site_locator_colors.dart';
import 'package:driven_site_locator/site_locator/widgets/site_locator_menu_row.dart';

class LegalPrivacyMenuCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SiteLocatorMenuRow(
      title: SiteLocatorConstants.legalPrivacy,
      icon: _legalPrivacyIcon(),
      buttonAction: navToLegalPage,
    );
  }

  void navToLegalPage() {
    trackAction(
      AnalyticsTrackActionName.menuDrawerLegalPrivacyLinkClickEvent,
      // adobeCustomTag: AdobeTagProperties.slMenu,
    );
    SiteLocatorNavigation.instance.toCommonWebView(
      url: ApiConstants.fuelmanLegalUrl,
      title: AppStrings.fuelmanLegalPrivacy,
    );
  }

  Icon _legalPrivacyIcon() => const Icon(
        Icons.policy_outlined,
        color: SiteLocatorColors.white,
      );
}
