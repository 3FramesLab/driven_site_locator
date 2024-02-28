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

  Widget expandedListTile() => ExpansionTile(
        title: Text(_title, style: _textStyle),
        leading: _icon,
        collapsedIconColor: Colors.black,
        children: [
          _storeIconsRow(),
        ],
      );

  Widget _storeIconsRow() => Row(
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

  TextStyle get _textStyle =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

  Image get _icon => const Image(
        image: AssetImage(SiteLocatorAssets.mobilePhone),
        height: SiteLocatorDimensions.dp28,
        width: SiteLocatorDimensions.dp28,
      );
}
