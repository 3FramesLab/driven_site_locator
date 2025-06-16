part of sl_widget_module;

class RepresentativePricing extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final bool showAddCard;

  const RepresentativePricing({
    required this.padding,
    this.showAddCard = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _guestHeader;
  }

  Widget get _guestHeader => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: padding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: _representativePricing),
              _addCard,
            ],
          ),
        ),
      );

  Widget get _representativePricing =>
      DcSiteLocatorUtils.displayRepresentativePricing()
          ? Container(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FittedBox(
                    child: Text(
                      SLViewText.representativePricingCAPS,
                      style: f14BoldBlack,
                    ),
                  ),
                  FittedBox(
                    child: DrivenText(
                      text: _dateStr,
                      style: f14RegularBlack,
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink();

  String get _dateStr =>
      '(As of ${DcSiteLocatorUtils.getRepresentativePricingDate()})';

  Widget get _addCard => showAddCard ? AddCard() : const SizedBox.shrink();
}
