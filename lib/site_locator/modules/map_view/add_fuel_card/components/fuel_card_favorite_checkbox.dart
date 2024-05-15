part of map_view_module;

class FuelCardFavoriteCheckbox extends GetView<FuelCardsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => DrivenCheckbox(
          onTap: controller.toggleSetAsFavorite,
          onChanged: (_) => controller.toggleSetAsFavorite(),
          value: controller.isFavoriteCard(),
          textWidget: _checkboxText(),
          isShowGreyCheckbox: controller.isShowGreyCheckbox,
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
