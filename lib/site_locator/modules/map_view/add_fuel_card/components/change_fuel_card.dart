import 'package:driven_site_locator/config/site_locator_routes.dart';
import 'package:driven_site_locator/constants/view_text.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/driven_site_locator.dart';
import 'package:driven_site_locator/site_locator/constants/semantic_strings.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/add_fuel_card/controllers/fuel_cards_controller.dart';
import 'package:get/get.dart';

class ChangeFuelCard extends StatelessWidget {
  final FuelCardsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(_changeCardLink);
  }

  Widget _changeCardLink() {
    return Semantics(
      label: SemanticStrings.changeFuelCards,
      container: true,
      child: InkWell(
        onTap: controller.onAddCardClicked,
        child: _changeCardText(),
      ),
    );
  }

  Widget _changeCardText() => Text(
        changeCardText,
        style: f16SemiboldBlackUnderline,
      );

  void navigateFromChangeCardLink() {
    if (controller.hasNoCards()) {
      DrivenSiteLocator.instance.addCardNavigation?.call();
    } else {
      Get.toNamed(SiteLocatorRoutes.fuelCardsSelection);
    }
  }

  String get changeCardText {
    if (controller.hasAtLeastTwoCards()) {
      return ViewText.changeCard;
    } else {
      return ViewText.addCard;
    }
  }
}
