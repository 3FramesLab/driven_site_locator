part of map_view_module;

class SiteInfoPopupMiddleContent extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();
  final SiteLocation selectedSiteLocation;
  final filterController = Get.find<AuthSLTypeChoicesController>();

  SiteInfoPopupMiddleContent(this.selectedSiteLocation);

  @override
  Widget build(BuildContext context) {
    return _popupMiddleContent(context);
  }

  Widget _popupMiddleContent(context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: DrivenColors.grey100,
      ),
      child: Column(
        children: [
          if (getIsServiceStation()) _serviceStationText,
          if (_isAnyPriceAvailable) ...[
            ..._fuelPricePack(),
            const SizedBox(height: DrivenDimensions.dp8),
          ] else
            _fuelPriceNoAvailableText,
          _applyForComdataCard,
          _actionButtons,
          const SizedBox(height: DrivenDimensions.dp8),
        ],
      ),
    );
  }

  List<Widget> _fuelPricePack() {
    final displayFuelPrice = UmaSLProperties.displayFuelPrice;
    if (displayFuelPrice == SLInternalText.dieselKey) {
      return [_dieselPricePack];
    } else if (displayFuelPrice == SLInternalText.gasKey) {
      return [_gasPricePack];
    } else if (displayFuelPrice == SLInternalText.cngKey) {
      return [_cngPricePack];
    }

    return [
      _dieselPricePack,
      _gasPricePack,
      _cngPricePack,
    ];
  }

  Widget get _serviceStationText => const Padding(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        child: DrivenText(
          text: SLViewText.thisIsAServiceLocation,
          style: f16ExtraBoldBlack,
        ),
      );

  Widget get _fuelPriceNoAvailableText => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: DrivenText(
          text: SLViewText.fuelPriceNotAvailable,
          style: getIsServiceStation() ? f14RegularBlack : f16ExtraBoldBlack,
        ),
      );

  bool getIsServiceStation() {
    return selectedSiteLocation.primaryBusiness == 'VM';
  }

  Widget get _actionButtons => SiteInfoActionButtons(selectedSiteLocation);

  Widget get _dieselPricePack => DiscountedPrice(
        fuelType: SLViewText.diesel,
        discountPrice: _displayDiscountedPrice
            ? selectedSiteLocation.discountPriceDiesel
            : selectedSiteLocation.newDiscountPriceDiesel,
        retailPrice: selectedSiteLocation.retailPriceDiesel,
      );

  Widget get _gasPricePack => DiscountedPrice(
        fuelType: SLViewText.gas,
        discountPrice: _displayDiscountedPrice
            ? selectedSiteLocation.discountPriceGas
            : null,
        retailPrice: selectedSiteLocation.retailPriceGas,
      );

  Widget get _cngPricePack => DiscountedPrice(
        fuelType: SLViewText.cng,
        discountPrice: _displayDiscountedPrice
            ? selectedSiteLocation.discountPriceCng
            : null,
        retailPrice: selectedSiteLocation.retailPriceCng,
      );

  Widget get _applyForComdataCard => ApplyForComdataCard();

  bool get _displayDiscountedPrice =>
      DcSiteLocatorUtils.displayDiscountedPrice();

  bool get _isAnyPriceAvailable =>
      (_isDieselRetailAvailable ||
          (_isDieselRetailAvailable && _isDieselDiscountAvailable)) ||
      (_isGasRetailAvailable ||
          (_isGasRetailAvailable && _isGasDiscountAvailable)) ||
      (_isCngRetailAvailable ||
          (_isCngRetailAvailable && _isCngDiscountAvailable));

  bool get _isDieselRetailAvailable =>
      selectedSiteLocation.retailPriceDiesel != null &&
      selectedSiteLocation.retailPriceDiesel != 0;

  bool get _isGasRetailAvailable =>
      selectedSiteLocation.retailPriceGas != null &&
      selectedSiteLocation.retailPriceGas != 0;

  bool get _isCngRetailAvailable =>
      selectedSiteLocation.retailPriceCng != null &&
      selectedSiteLocation.retailPriceCng != 0;

  bool get _isDieselDiscountAvailable =>
      selectedSiteLocation.discountPriceDiesel != null &&
      selectedSiteLocation.discountPriceDiesel != 0;

  bool get _isGasDiscountAvailable =>
      selectedSiteLocation.discountPriceGas != null &&
      selectedSiteLocation.discountPriceGas != 0;

  bool get _isCngDiscountAvailable =>
      selectedSiteLocation.discountPriceCng != null &&
      selectedSiteLocation.discountPriceCng != 0;

  // List<Widget> getFuelColumnChildren() {
  //   final selectedFilters = filterController.selectedSiteFiltersKeysMap();

  //   final columnChildren = <Widget>[];

  //   if (selectedFilters.isNotEmpty &&
  //       selectedFilters[SLInternalText.fuelKey] != null) {
  //     final values = selectedFilters[SLInternalText.fuelKey];
  //     if (values != null && values.isNotEmpty) {
  //       if (values.contains(SLInternalText.dieselKey)) {
  //         columnChildren.add(_dieselPricePack);
  //       }
  //       if (values.contains(SLInternalText.gasKey)) {
  //         columnChildren.add(_gasPricePack);
  //       }
  //       if (values.contains(SLInternalText.cngKey)) {
  //         columnChildren.add(_cngPricePack);
  //       }
  //     }
  //     return columnChildren;
  //   } else {
  //     return [
  //       _dieselPricePack,
  //       _gasPricePack,
  //       _cngPricePack,
  //     ];
  //   }
  // }
}
