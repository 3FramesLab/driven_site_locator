part of map_view_module;

class FuelCardsItemView extends GetView<FuelCardsController> {
  final Function() onTap;
  final FuelCard fuelCard;

  const FuelCardsItemView({
    required this.fuelCard,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      shape: DrivenRectangleBorder.mediumRounded,
      child: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return _cardTile(context);
  }

  Widget _cardTile(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(0, _topPadding, 0, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _favoriteCardIcon(),
            _cardListTile(),
          ],
        ),
      );

  double get _topPadding =>
      fuelCard.isFavoriteCard != null && fuelCard.isFavoriteCard! ? 10 : 20;

  Widget _cardListTile() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cardNumberRow(),
            const SizedBox(width: 8),
            _cardActionsRow(),
          ],
        ),
      );

  Flexible _cardActionsRow() => Flexible(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _editIcon(),
            const SizedBox(width: 8),
            _deleteIcon(),
          ],
        ),
      );

  Row _cardNumberRow() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardIcon(),
          const SizedBox(width: 18),
          _cardNameWithNumber,
        ],
      );

  Flexible _deleteIcon() => Flexible(
        child: GestureDetector(
          onTap: _removeCardDialog,
          child: Semantics(
            label: SemanticStrings.deleteCard,
            child: Image.asset(
              SiteLocatorAssets.deleteIcon,
              height: 24,
              width: 24,
            ),
          ),
        ),
      );

  Flexible _editIcon() => Flexible(
        child: GestureDetector(
          key: const Key(WidgetKeys.editCardKey),
          onTap: () => SiteLocatorNavigation.instance.editFuelCard(fuelCard),
          child: Image.asset(
            SiteLocatorAssets.editIcon,
            height: 24,
            width: 24,
          ),
        ),
      );

  Widget _favoriteCardIcon() => Visibility(
        visible: fuelCard.isFavoriteCard ?? false,
        child: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Icon(
            Icons.favorite,
            color: DrivenColors.black90,
            size: 22,
            semanticLabel: SemanticStrings.favoriteCard,
          ),
        ),
      );

  Widget _cardIcon() => Image.asset(
        SiteLocatorAssets.creditCard,
        color: DrivenColors.brandPurple,
        height: 24,
        width: 24,
      );

  Widget _cardTitleWithBalance(String cardTitle) => Body1Regular14Lh23(
        cardTitle,
        style: f14RegularBlackDark,
        overflow: TextOverflow.fade,
        maxLines: 1,
        textAlign: TextAlign.left,
      );

  Widget get _cardNameWithNumber => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Get.width * 0.35),
            child: _cardTitleWithBalance(fuelCard.cardNickName ?? ''),
          ),
          const SizedBox(width: 3),
          _cardTitleWithBalance(
            '- *${fuelCard.cardLastFourDigit ?? ''}',
          ),
        ],
      );

  Widget get removeCardButton => PrimaryButton(
        onPressed: _onRemoveCardClick,
        text: ViewText.removeCardTitle,
      );

  Widget get cancelButton => ClickableText(
        onTap: Get.back,
        title: ViewText.cancel,
      );

  Future<void> _onRemoveCardClick() async {
    if (fuelCard.id != null) {
      await controller.deleteFuelCards(fuelCard);
    }
    Get.back();
  }

  void _removeCardDialog() {
    Get.dialog(
      DrivenDialog(
        text: const [TextSpan(text: ViewText.removeCardDialogTitle)],
        primaryButton: removeCardButton,
        secondaryButton: cancelButton,
      ),
    );
  }
}
