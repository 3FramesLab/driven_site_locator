// ignore_for_file: must_be_immutable

part of sl_list_module;

class SLCardFuelPriceFork extends StatelessWidget {
  SLCardFuelPriceFork(this.siteLocation, {Key? key}) : super(key: key);

  final SiteLocation siteLocation;
  final SLSiteLocatorController siteLocatorController = Get.find();
  bool showSavingsText = false;
  double retailPrice = 0;
  double discountPrice = 0;

  @override
  Widget build(BuildContext context) {
    _anyPriceAvailable();
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ..._fuelPricePack(),
          _savingsLabelText,
          _lowestFuelPriceTag,
        ],
      ),
    );
  }

  List<Widget> _fuelPricePack() {
    final displayFuelPrice = UmaSLProperties.displayFuelPrice;
    if (displayFuelPrice == SLInternalText.dieselKey) {
      showSavingsText = true;
      retailPrice = siteLocation.retailPriceDiesel ?? 0;
      discountPrice = _discountedDieselPrice ?? 0;
      return [_dieselPricePack];
    } else if (displayFuelPrice == SLInternalText.gasKey) {
      showSavingsText = true;
      retailPrice = siteLocation.retailPriceGas ?? 0;
      discountPrice = siteLocation.discountPriceGas ?? 0;
      return [_gasPricePack];
    } else if (displayFuelPrice == SLInternalText.cngKey) {
      showSavingsText = true;
      retailPrice = siteLocation.retailPriceCng ?? 0;
      discountPrice = siteLocation.discountPriceCng ?? 0;
      return [_cngPricePack];
    }

    return [
      _dieselPricePack,
      _gasPricePack,
      _cngPricePack,
    ];
  }

  Widget get _savingsLabelText {
    if (showSavingsText &&
        retailPrice > 0 &&
        discountPrice > 0 &&
        retailPrice > discountPrice) {
      return _savingText();
    }
    return const SizedBox.shrink();
  }

  Widget _savingText() {
    final displayText = DcSiteLocatorUtils.getGallonSavingText(
      retailPrice: retailPrice,
      discountPrice: discountPrice,
    );

    if (displayText.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: DrivenColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          displayText,
          style: f12SemiboldWhite,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textScaler: _textScaler,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget get _lowestFuelPriceTag {
    if (siteLocatorController.isLowestFuelPriceSite(siteLocation)) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: DrivenColors.goldenYellow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            SLViewText.lowest,
            style: f12SemiBoldBlack,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textScaler: _textScaler,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  void _anyPriceAvailable() {
    int priceCount = 0;
    if (_isDieselDiscountAvailable || _isDieselRetailAvailable) {
      retailPrice = siteLocation.retailPriceDiesel ?? 0;
      discountPrice = _discountedDieselPrice ?? 0;
      priceCount++;
    }
    if (_isGasDiscountAvailable || _isGasRetailAvailable) {
      retailPrice = siteLocation.retailPriceGas ?? 0;
      discountPrice = siteLocation.discountPriceGas ?? 0;
      priceCount++;
    }
    if (_isCngDiscountAvailable || _isCngRetailAvailable) {
      retailPrice = siteLocation.retailPriceCng ?? 0;
      discountPrice = siteLocation.discountPriceCng ?? 0;
      priceCount++;
    }

    if (priceCount == 1) {
      showSavingsText = true;
    }
  }

  Widget get _dieselPricePack => ListItemPrice(
        fuelType: SLViewText.diesel,
        discountPrice: _discountedDieselPrice,
        retailPrice: siteLocation.retailPriceDiesel,
      );

  Widget get _gasPricePack => ListItemPrice(
        fuelType: SLViewText.gas,
        discountPrice:
            _displayDiscountedPrice ? siteLocation.discountPriceGas : null,
        retailPrice: siteLocation.retailPriceGas,
      );

  Widget get _cngPricePack => ListItemPrice(
        fuelType: SLViewText.cng,
        discountPrice:
            _displayDiscountedPrice ? siteLocation.discountPriceCng : null,
        retailPrice: siteLocation.retailPriceCng,
      );

  bool get _displayDiscountedPrice =>
      DcSiteLocatorUtils.displayDiscountedPrice();

  double? get _discountedDieselPrice => _displayDiscountedPrice
      ? siteLocation.discountPriceDiesel
      : siteLocation.newDiscountPriceDiesel;

  bool get _isDieselRetailAvailable =>
      siteLocation.retailPriceDiesel != null &&
      siteLocation.retailPriceDiesel != 0;

  bool get _isGasRetailAvailable =>
      siteLocation.retailPriceGas != null && siteLocation.retailPriceGas != 0;

  bool get _isCngRetailAvailable =>
      siteLocation.retailPriceCng != null && siteLocation.retailPriceCng != 0;

  bool get _isDieselDiscountAvailable =>
      _discountedDieselPrice != null && _discountedDieselPrice != 0;

  bool get _isGasDiscountAvailable =>
      siteLocation.discountPriceGas != null &&
      siteLocation.discountPriceGas != 0;

  bool get _isCngDiscountAvailable =>
      siteLocation.discountPriceCng != null &&
      siteLocation.discountPriceCng != 0;

  // Widget get _lowestTag => Container(
  //       margin: const EdgeInsets.only(bottom: 2),
  //       child: const TagText(
  //         title: SLViewText.lowest,
  //         padding: EdgeInsets.only(left: 8, top: 2, right: 8, bottom: 4),
  //         color: DrivenColors.goldenYellow,
  //         fontSize: 14,
  //         textColor: DrivenColors.black,
  //         radius: 20,
  //       ),
  //     );

  TextScaler get _textScaler => const TextScaler.linear(1);
}
