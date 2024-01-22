import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/semantic_strings.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_dimensions.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/styles/site_locator_colors.dart';
import 'package:driven_site_locator/site_locator/widgets/common/custom_card_with_shadow.dart';
import 'package:get/get.dart';

class SiteLocatorMenuIcon extends StatelessWidget {
  SiteLocatorMenuIcon({Key? key}) : super(key: key);
  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: SiteLocatorDimensions.dp16),
      child: Semantics(
        container: true,
        label: SemanticStrings.siteLocatorMenuIcon,
        child: GestureDetector(
          onTap: _onTap,
          child: CustomCardWithShadow(
            child: _menuIcon(),
          ),
        ),
      ),
    );
  }

  CircleAvatar _menuIcon() => CircleAvatar(
        radius: SiteLocatorDimensions.dp26,
        backgroundColor: SiteLocatorColors.white,
        child: _icon(),
      );

  Widget _icon() => const Icon(
        Icons.menu,
        size: SiteLocatorDimensions.dp24,
        color: SiteLocatorColors.black,
      );

  void _onTap() {
    trackAction(
      AnalyticsTrackActionName.menuDrawerVisitEvent,
    );
    siteLocatorController.clearSearchPlaceInput();
    siteLocatorController.resetMapViewScreen();
    siteLocatorController.menuPanelController.open();
  }
}
