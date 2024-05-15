part of map_view_module;

class FuelCardNumberTextField extends GetView<FuelCardsController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        cardLabel,
        const VerticalSpacer(size: 10),
        cardField,
      ],
    );
  }

  Widget get cardLabel => Row(
        children: [
          textLabel,
        ],
      );

  Widget get textLabel => const Text(
        ViewText.cardNumber,
        style: f14SemiboldGrey,
      );

  Widget get cardField => Container(
        padding: const EdgeInsets.only(left: 12),
        child: Obx(
          () => rowWidget,
        ),
      );

  Widget get rowWidget => Row(
        children: [
          fieldText,
          const Spacer(),
        ],
      );

  Widget get fieldText => Text(
        controller.maskedCardNumber,
        style: f20BoldBlackDark,
      );
}
