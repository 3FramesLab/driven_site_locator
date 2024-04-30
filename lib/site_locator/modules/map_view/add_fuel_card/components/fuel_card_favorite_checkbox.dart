import 'package:driven_site_locator/constants/view_text.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/add_fuel_card/controllers/fuel_cards_controller.dart';
import 'package:get/get.dart';

class FuelCardFavoriteCheckbox extends GetView<FuelCardsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => DrivenCheckbox(
          onTap: controller.toggleSetAsFavorite,
          onChanged: (_) => controller.toggleSetAsFavorite(),
          value: controller.isFavoriteCard(),
          textWidget: _checkboxText(),
          isShowGreyCheckbox: controller.hasNoCards(),
        ));
  }

  Widget _checkboxText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          ViewText.setCardAsFavorite,
          style: f14SemiboldBlack2,
        ),
      ],
    );
  }
}
