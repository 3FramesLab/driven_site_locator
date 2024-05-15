part of map_view_module;

class FuelCardsDisplayText extends StatelessWidget {
  final TextStyle style;
  final double? nickNameWidth;

  FuelCardsDisplayText({
    this.style = f14SemiboldBlack,
    this.nickNameWidth,
  });

  final FuelCardsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (controller.hasNoCards() ||
              controller.favoriteFuelCard.cardNickName == null)
          ? _headerText(ViewText.addCardToSeeDiscounts)
          : _nickNameWithNumber,
    );
  }

  // Show favourite card as header text
  Widget get _nickNameWithNumber {
    return Row(
      children: [
        ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: nickNameWidth ?? Get.width * 0.4),
          child: _headerText(controller.favoriteFuelCard.cardNickName ?? ''),
        ),
        const SizedBox(width: 3),
        _headerText(
          '- *${controller.favoriteFuelCard.cardLastFourDigit ?? ''}',
        ),
      ],
    );
  }

  Widget _headerText(String text) {
    return Body1SemiBold16Lh23(
      text,
      style: f16SemiboldBlackDark,
      overflow: TextOverflow.fade,
      maxLines: 1,
    );
  }
}
