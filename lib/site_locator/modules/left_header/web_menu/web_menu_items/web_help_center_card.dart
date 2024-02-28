import 'package:driven_site_locator/config/site_locator_navigation.dart';
import 'package:driven_site_locator/site_locator/configuration/site_locator_config.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/modules/left_header/web_menu/web_menu_row.dart';
import 'package:driven_site_locator/site_locator/styles/site_locator_colors.dart';
import 'package:flutter/material.dart';

class WebHelpCenterCard extends StatelessWidget {
  const WebHelpCenterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return WebMenuRow(
      title: SiteLocatorConstants.helpCenter,
      icon: _helpCenterIcon(),
      onRowTap: navToHelpCenterPage,
    );
  }

  void navToHelpCenterPage() {
    SiteLocatorNavigation.instance.toCommonWebView(
      url: SiteLocatorConfig.helpCenterUrl,
      title: SiteLocatorConstants.helpCenter,
    );
  }

  Icon _helpCenterIcon() => const Icon(
        Icons.help_center_outlined,
        color: SiteLocatorColors.black,
      );
}
