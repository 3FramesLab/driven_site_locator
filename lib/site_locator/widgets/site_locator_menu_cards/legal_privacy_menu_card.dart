import 'package:driven_site_locator/analytics/adobe_tag_properties.dart';
import 'package:driven_site_locator/analytics/site_locator_track_action_name.dart';
import 'package:driven_site_locator/config/site_locator_navigation.dart';
import 'package:driven_site_locator/constants/api_constants.dart';
import 'package:driven_site_locator/constants/app_strings.dart';
import 'package:driven_site_locator/constants/internal_text.dart';
import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/widgets/site_locator_menu_row.dart';

class LegalPrivacyMenuCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SiteLocatorMenuRow(
      title: SiteLocatorConstants.legalPrivacy,
      imageIcon: const AssetImage(SiteLocatorAssets.legalPrivacyPolicyIcon),
      buttonAction: AppUtils.isComdata ? navToLegalPageComdata : navToLegalPage,
    );
  }

  void navToLegalPage() {
    trackAction(
      SiteLocatorAnalyticsTrackActionName.menuDrawerLegalPrivacyLinkClickEvent,
      adobeCustomTag: AdobeTagProperties.slMenu.value,
    );
    SiteLocatorNavigation.instance.toCommonWebView(
      url: ApiConstants.fuelmanLegalUrl,
      title: AppStrings.fuelmanLegalPrivacy,
    );
  }

  void navToLegalPageComdata() {
    trackAction(
      SiteLocatorAnalyticsTrackActionName.menuDrawerLegalPrivacyLinkClickEvent,
      adobeCustomTag: AdobeTagProperties.slMenu.value,
    );
    SiteLocatorNavigation.instance.toCommonWebView(
      url: InternalText.comdataLegalDocsUrl,
      title: AppStrings.fuelmanLegalPrivacy,
    );
  }
}
