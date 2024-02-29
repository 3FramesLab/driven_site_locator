import 'package:driven_site_locator/data/model/entitlement_repository.dart';
import 'package:driven_site_locator/site_locator/modules/left_header/web_menu/web_menu_items/web_download_mobile_app_card.dart';
import 'package:driven_site_locator/site_locator/modules/left_header/web_menu/web_menu_items/web_help_center_card.dart';
import 'package:driven_site_locator/site_locator/modules/left_header/web_menu/web_menu_items/web_legal_privacy_card.dart';
import 'package:driven_site_locator/site_locator/modules/left_header/web_menu/web_menu_items/web_location_preferences_card.dart';
import 'package:driven_site_locator/site_locator/modules/left_header/web_menu/web_menu_items/web_login_menu_card.dart';
import 'package:driven_site_locator/site_locator/site_locator_components/common_widgets/back_button_with_title.dart';
import 'package:flutter/material.dart';

class WebMenuPage extends StatelessWidget {
  static final repository = SiteLocatorEntitlementUtils.instance;

  const WebMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackButtonWithTitle(
                title: 'Menu',
                onBackButtonPressed: () {},
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: repository.isLoginLogoutSettingsEnabled,
                child: WebLoginMenuCard(),
              ),
              Visibility(
                visible: repository.isLoginLogoutSettingsEnabled,
                child: _divider(),
              ),
              WebDownloadMobileAppCard(),
              _divider(),
              WebLocationPreferencesCard(),
              _divider(),
              const WebHelpCenterCard(),
              Visibility(
                visible: repository.isLegalPrivacySettingEnabled,
                child: _divider(),
              ),
              Visibility(
                visible: repository.isLegalPrivacySettingEnabled,
                child: const WebLegalPrivacyCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() => Container(height: 1, color: const Color(0xffe0e0e0));
}
