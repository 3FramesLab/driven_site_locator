import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_api_constants.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_dimensions.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/utilities/site_locator_utils.dart';
import 'package:get/get.dart';

class WebDownloadMobileAppCard extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();

  WebDownloadMobileAppCard({super.key});

  @override
  Widget build(BuildContext context) {
    return expandedListTile();
  }

  Widget expandedListTile() => Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: ExpansionTile(
          title: Text(_title, style: f16SemiboldBlackDark),
          leading: _icon,
          collapsedIconColor: Colors.black,
          iconColor: Colors.black,
          children: [
            _storeIconsRow(),
          ],
        ),
      );

  Widget _storeIconsRow() => Padding(
        padding: const EdgeInsets.only(left: 16, top: 4, bottom: 8),
        child: Row(
          children: [
            _storeIcon(
              SiteLocatorAssets.googleStore,
              () => _openStoreLink(
                SiteLocatorApiConstants.fuelmanAppGoogleStoreLink,
              ),
            ),
            _storeIcon(
              SiteLocatorAssets.appleStore,
              () => _openStoreLink(
                SiteLocatorApiConstants.fuelmanAppAppleStoreLink,
              ),
            ),
          ],
        ),
      );

  void _openStoreLink(String storeURL) => SiteLocatorUtils.launchURL(
        storeURL,
        SiteLocatorConstants.openApplyForFuelmanError,
      );

  Widget _storeIcon(String assetName, Function()? onIconTap) => Expanded(
        child: GestureDetector(
          onTap: onIconTap,
          child: Image(
            image: AssetImage(assetName),
            height: 56,
          ),
        ),
      );

  String get _title => SiteLocatorConstants.downloadFuelmanApp;

  Image get _icon => const Image(
        image: AssetImage(SiteLocatorAssets.mobilePhone),
        height: SiteLocatorDimensions.dp28,
        width: SiteLocatorDimensions.dp28,
      );
}
