part of map_view_module;

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
