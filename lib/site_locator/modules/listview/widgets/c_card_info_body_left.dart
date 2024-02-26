part of list_view_module;

class CardInfoBodyLeft extends StatelessWidget {
  CardInfoBodyLeft(this.siteLocation, {Key? key}) : super(key: key);

  final SiteLocation siteLocation;

  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shopName(),
              CardInfoFuelPriceFork(siteLocation),
            ],
          ),
          _streetName(),
          _drivingMiles(),
        ],
      ),
    );
  }

  Widget _shopName() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _brandLogo(),
        const HorizontalSpacer(size: 4),
        _locationNameWidget(),
      ],
    );
  }

  Semantics _brandLogo() {
    return Semantics(
      container: true,
      label: SemanticStrings.siteInfoBrandLogo,
      child: SiteInfoUtils.getDisplayBrandLogo(siteLocation),
    );
  }

  Widget _streetName() {
    final topPadding =
        SiteInfoUtils.canDisplayBrandLogo(siteLocation) ? 8.0 : 18.0;
    return Padding(
      padding: EdgeInsets.only(left: 15, top: topPadding),
      child: _streetWidget(),
    );
  }

  Widget _drivingMiles() {
    final milesData = siteLocatorController.displayMiles(siteLocation);
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10),
      child: Semantics(
        container: true,
        label: SemanticStrings.siteInfoDrivingDistance,
        child: SiteInfoDetail(
          iconData: Icons.drive_eta_outlined,
          description: milesData,
        ),
      ),
    );
  }

  Widget _locationNameWidget() {
    return Expanded(
      child: Semantics(
        container: true,
        label: SemanticStrings.siteInfoLocationName,
        child: Text(
          SiteInfoUtils.getLocationName(siteLocation),
          style: f16BoldBlackDark,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _streetWidget() {
    return Row(
      children: [
        _addressIcon(),
        const HorizontalSpacer(size: 7.5),
        _addressText()
      ],
    );
  }

  Widget _addressIcon() => Semantics(
        container: true,
        label: SemanticStrings.siteInfoAddressIcon,
        child: const Icon(
          Icons.pin_drop_outlined,
          size: SiteLocatorConstants.siteInfoIconSize,
          color: DrivenColors.textColor,
        ),
      );

  Widget _addressText() => Expanded(
        child: Semantics(
          container: true,
          label: SemanticStrings.siteInfoAddressText,
          child: Text(
            SiteInfoUtils.getStreetAddress(siteLocation),
            style: f14RegularBlack,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      );
}
