import 'package:driven_site_locator/constants/view_text.dart';
import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/data/model/entitlement_repository.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_dimensions.dart';
import 'package:driven_site_locator/site_locator/widgets/site_locator_menu_cards/help_center_menu_card.dart';
import 'package:driven_site_locator/site_locator/widgets/site_locator_menu_cards/legal_privacy_menu_card.dart';
import 'package:driven_site_locator/site_locator/widgets/site_locator_menu_cards/login_menu_card.dart';
import 'package:driven_site_locator/site_locator/widgets/site_locator_menu_cards/preferences_filter_menu_card.dart';

class SiteLocatorMenu extends StatelessWidget {
  const SiteLocatorMenu({Key? key}) : super(key: key);
  static final repository = SiteLocatorEntitlementUtils.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Visibility(
          visible: repository.isLoginLogoutSettingsEnabled,
          child: LoginMenuCard(),
        ),
        _divider(),
        Visibility(
          visible: repository.isPreferenceFilterEnabled,
          child: PreferencesFilterMenuCard(),
        ),
        _divider(),
        Visibility(
          visible: repository.isHelpCenterEnabled,
          child: HelpCenterMenuCard(),
        ),
        _divider(),
        Visibility(
          visible: repository.isLegalPrivacySettingEnabled,
          child: LegalPrivacyMenuCard(),
        ),
        _divider(),
        _appVersion(),
      ],
    );
  }

  SizedBox _divider() => const SizedBox(height: 6);

  PaddedText _appVersion() => PaddedText(
        '${ViewText.version} ${AppUtils.appVersionName}',
        style: f12RegularBlack,
        padding: const EdgeInsets.only(
          top: SiteLocatorDimensions.dp11,
          left: SiteLocatorDimensions.dp15,
        ),
      );
}
