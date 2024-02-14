import 'package:driven_site_locator/site_locator/modules/left_header/widgets/fuelman_network_sitelocator_logo.dart';
import 'package:driven_site_locator/site_locator/modules/left_header/widgets/hamberger_menu.dart';
import 'package:flutter/material.dart';

class TopMenuLogoHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HambergerMenu(),
        FuelmanNetworkSitelocatorLogo(),
      ],
    );
  }
}
