import 'package:driven_site_locator/data/model/entitlement_repository.dart';
import 'package:driven_site_locator/site_locator/modules/left_header/widgets/fuelman_network_sitelocator_logo.dart';
import 'package:driven_site_locator/site_locator/modules/left_header/widgets/web_menu.dart';
import 'package:flutter/material.dart';

class TopMenuLogoHeader extends StatelessWidget {
  final Function()? onMenuIconTap;

  const TopMenuLogoHeader({
    Key? key,
    this.onMenuIconTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _entitlementRepository = SiteLocatorEntitlementUtils.instance;
    return Row(
      children: [
        Visibility(
          visible: _entitlementRepository.isDisplaySettingsEnabled,
          child: WebHamburgerMenu(onMenuIconTap: onMenuIconTap),
        ),
        FuelmanNetworkSitelocatorLogo(),
      ],
    );
  }
}
