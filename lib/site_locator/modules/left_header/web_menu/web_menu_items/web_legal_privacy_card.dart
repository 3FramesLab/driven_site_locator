import 'package:driven_site_locator/config/site_locator_navigation.dart';
import 'package:driven_site_locator/constants/api_constants.dart';
import 'package:driven_site_locator/constants/app_strings.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/modules/left_header/web_menu/web_menu_row.dart';
import 'package:driven_site_locator/site_locator/styles/site_locator_colors.dart';

class WebLegalPrivacyCard extends StatelessWidget {
  const WebLegalPrivacyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return WebMenuRow(
      title: SiteLocatorConstants.legalPrivacy,
      icon: _legalPrivacyIcon(),
      onRowTap: navToLegalPage,
    );
  }

  void navToLegalPage() {
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
