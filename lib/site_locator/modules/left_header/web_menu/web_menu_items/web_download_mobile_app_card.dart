import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/widgets/site_locator_menu_row.dart';
import 'package:get/get.dart';

class WebDownloadMobileApp extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();

  WebDownloadMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteLocatorMenuRow(
      title: _title,
      imageIcon: _icon,
      buttonAction: () {},
    );
  }

  String get _title => SiteLocatorConstants.downloadFuelmanApp;

  AssetImage get _icon => const AssetImage(SiteLocatorAssets.mobilePhone);
}
