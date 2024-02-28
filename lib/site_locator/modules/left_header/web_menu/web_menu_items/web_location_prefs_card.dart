import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_dimensions.dart';
import 'package:driven_site_locator/site_locator/modules/left_header/web_menu/share_my_current_location_switch.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:get/get.dart';

class WebLocationPreferencesCard extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();

  WebLocationPreferencesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return expandedListTile();
  }

  Widget expandedListTile() => ExpansionTile(
        title: Text(_title, style: f16SemiboldBlack),
        leading: _icon,
        collapsedIconColor: Colors.black,
        children: [
          _locationPreferences(),
        ],
      );

  Widget _locationPreferences() => Padding(
        padding: const EdgeInsets.only(left: 16, top: 4, bottom: 8),
        child: Row(
          children: [
            Transform.scale(
              scale: 0.8,
              child: ShareMyCurrentLocationSwitch(),
            ),
            const SizedBox(width: 10),
            _shareMyLocation(),
          ],
        ),
      );

  Widget _shareMyLocation() => const Text(
        SiteLocatorConstants.shareMyCurrentLocation,
        style: f14RegularBlack,
      );

  String get _title => SiteLocatorConstants.locationPreferences;

  Image get _icon => const Image(
        image: AssetImage(SiteLocatorAssets.mapPin),
        height: SiteLocatorDimensions.dp28,
        width: SiteLocatorDimensions.dp28,
      );
}
