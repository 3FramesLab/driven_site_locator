import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_api_constants.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/modules/left_header/web_menu/web_menu_row.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/utilities/site_locator_utils.dart';
import 'package:get/get.dart';

class WebLoginMenuCard extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();

  WebLoginMenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    return WebMenuRow(
      title: _title,
      imageIcon: _icon,
      onRowTap: handleLoginCardTap,
    );
  }

  String get _title => SiteLocatorConstants.webLogin;

  AssetImage get _icon => const AssetImage(SiteLocatorAssets.badgeIcon);

  Future<void> handleLoginCardTap() async => SiteLocatorUtils.launchURL(
        SiteLocatorApiConstants.fuelmanWebUrl,
        SiteLocatorConstants.openApplyForFuelmanError,
      );
}
