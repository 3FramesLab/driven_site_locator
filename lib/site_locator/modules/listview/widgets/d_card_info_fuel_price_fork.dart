part of list_view_module;

class CardInfoFuelPriceFork extends StatelessWidget {
  CardInfoFuelPriceFork(this.siteLocation, {Key? key}) : super(key: key);

  final SiteLocation siteLocation;
  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) =>
      (AppUtils.isComdata) ? _dieselPriceSection() : _fuelPriceSection();

  Widget _fuelPriceSection() {
    final price = SiteInfoUtils.getFuelPrice(siteLocation);
    final fuelType = SiteInfoUtils.getFuelTitle(siteLocation);
    final displayPriceFuelType = price.isNotEmpty ? '$price - $fuelType' : '';

    return _displayPriceItem(displayPriceFuelType);
  }

  Widget _dieselPriceSection() {
    final dieselPacks = siteLocatorController.getDieselPricesPack(siteLocation);
    final price = dieselPacks.netPrice.isNotEmpty
        ? dieselPacks.netPrice
        : dieselPacks.retailPrice;
    final fuelSaleType = dieselPacks.typeLabel;
    final displayDieselPriceType = price.isNotEmpty && fuelSaleType.isNotEmpty
        ? '$price ($fuelSaleType)'
        : '';

    return _displayPriceItem(displayDieselPriceType);
  }

  Widget _displayPriceItem(String displayText) {
    final double topPadding =
        SiteInfoUtils.canDisplayBrandLogo(siteLocation) ? 10 : 0;
    return Container(
      // margin: EdgeInsets.only(top: topPadding),
      child: Semantics(
        container: true,
        label: SemanticStrings.siteInfoFuelPrice,
        child: Text(displayText, style: f16BoldBlackDark),
      ),
    );
  }
}
