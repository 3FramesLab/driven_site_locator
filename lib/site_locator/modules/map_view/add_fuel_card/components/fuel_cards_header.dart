import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/add_fuel_card/components/change_fuel_card.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/add_fuel_card/components/fuel_cards_display_text.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/add_fuel_card/controllers/fuel_cards_controller.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:get/get.dart';

class FuelCardsHeader extends StatelessWidget implements PreferredSizeWidget {
  final FuelCardsController fuelCardsController = Get.find();
  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isAuthenticatedMapView,
      child: DrivenAppBar(
        centerTitle: false,
        title: _activeCardText(),
        toolBarHeight: 84,
        titleSpacing: 22,
        padding: const EdgeInsets.all(0),
        backgroundColor: Colors.white.withOpacity(0.7),
      ),
    );
  }

  Widget _activeCardText() {
    return Row(
      children: [
        Expanded(
          child: FuelCardsDisplayText(),
        ),
        const SizedBox(width: 5),
        ChangeFuelCard(),
      ],
    );
  }

  // bool get _isAuthenticatedMapView =>
  //     !(AppUtils.flavor != AppFlavor.comdata.name ||
  //         Get.currentRoute == AdminRoutes.dashboard ||
  //         Get.currentRoute == AdminRoutes.cardholderSiteLocatorMapPage);
  bool get _isAuthenticatedMapView =>
      !(AppUtils.flavor != AppFlavor.comdata.name ||
          siteLocatorController.isUserAuthenticated);

  @override
  // ignore: avoid_field_initializers_in_const_classes
  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 10);
}
