import 'package:driven_site_locator/data/model/entitlement_repository.dart';
import 'package:driven_site_locator/site_locator/modules/left_header/web_menu/web_menu_items/web_download_mobile_app_card.dart';
import 'package:driven_site_locator/site_locator/modules/left_header/web_menu/web_menu_items/web_location_prefs_card.dart';
import 'package:driven_site_locator/site_locator/modules/left_header/web_menu/web_menu_items/web_login_menu_card.dart';
import 'package:driven_site_locator/site_locator/site_locator_components/common_widgets/back_button_with_title.dart';
import 'package:driven_site_locator/site_locator/widgets/site_locator_menu_cards/help_center_menu_card.dart';
import 'package:driven_site_locator/site_locator/widgets/site_locator_menu_cards/legal_privacy_menu_card.dart';
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
              const SizedBox(height: 30),
              Visibility(
                visible: repository.isLoginLogoutSettingsEnabled,
                child: WebLoginMenuCard(),
              ),
              _divider(),
              const SizedBox(height: 20),
              WebDownloadMobileApp(),
              _divider(),
              const SizedBox(height: 20),
              WebLocationPreferences(),
              _divider(),
              const SizedBox(height: 20),
              Visibility(
                visible: repository.isHelpCenterEnabled,
                child: HelpCenterMenuCard(),
              ),
              _divider(),
              const SizedBox(height: 20),
              Visibility(
                visible: repository.isLegalPrivacySettingEnabled,
                child: LegalPrivacyMenuCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() => Container(height: 1, color: Color(0xffe0e0e0));
}
