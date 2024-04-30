import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/add_fuel_card/components/fuel_cards_item_view.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/add_fuel_card/controllers/fuel_cards_controller.dart';
import 'package:get/get.dart';

class FuelCardsSelectionForm extends GetView<FuelCardsController> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: controller.cards.length,
      separatorBuilder: (c, i) => const SizedBox(height: 6),
      itemBuilder: (c, i) => _cardListItemBuilder(controller.cards, i),
    );
  }

  Widget _cardListItemBuilder(cards, index) {
    return FuelCardsItemView(
      fuelCard: controller.cards[index],
      onTap: () => controller.cardSelected(cards[index]),
    );
  }
}
