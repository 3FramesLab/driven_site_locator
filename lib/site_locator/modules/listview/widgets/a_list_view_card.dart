part of list_view_module;

class SiteLocationInfoCard extends GetView<SiteLocatorController> {
  const SiteLocationInfoCard(this.siteLocation, this.index);

  final SiteLocation siteLocation;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SiteInfoUtils.getCardBgColor(index),
      child: Padding(
        padding: SiteInfoUtils.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _fuelPriceAsOfDateBanner(),
            _cardInfoBody(context),
            SiteInfoUtils.divider(),
            CardInfoFooter(siteLocation),
          ],
        ),
      ),
    );
  }

  Widget _fuelPriceAsOfDateBanner() {
    return AppUtils.isComdata
        ? Center(
            child: FuelPriceAsOfDateBanner(
                siteLocation, FuelPriceAsOfDateBannerViewType.listCard),
          )
        : const SizedBox.shrink();
  }

  Widget _cardInfoBody(BuildContext context) {
    if (kIsWeb) {
      return Row(
        children: [
          Expanded(child: CardInfoBodyLeft(siteLocation)),
          const SizedBox(width: 15),
          Expanded(child: CardInfoBodyRight(siteLocation)),
        ],
      );
    } else {
      return Wrap(
        children: [
          CardInfoBodyLeft(siteLocation),
          const SizedBox(width: 15),
          CardInfoBodyRight(siteLocation),
        ],
      );
    }
  }
}
