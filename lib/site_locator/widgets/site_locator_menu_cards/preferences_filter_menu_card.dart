import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/widgets/site_locator_menu_row.dart';
import 'package:get/get.dart';

class PreferencesFilterMenuCard extends StatelessWidget {
  final siteLocatorController = Get.find<SiteLocatorController>();

  @override
  Widget build(BuildContext context) {
    return SiteLocatorMenuRow(
      title: SiteLocatorConstants.preferencesFilters,
      imageIcon: const AssetImage(SiteLocatorAssets.preferencesFilterIcon),
      buttonAction: navToPreferencesFilterPage,
    );
  }

  void navToPreferencesFilterPage() {
    trackAction(
      AnalyticsTrackActionName.menuDrawerPreferencesFiltersLinkClickEvent,
    );
    siteLocatorController.navigateToEnhancedFilter();
  }
}
