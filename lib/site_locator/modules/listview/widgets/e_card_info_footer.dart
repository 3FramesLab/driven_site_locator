part of list_view_module;

class CardInfoFooter extends StatelessWidget {
  CardInfoFooter(this.siteLocation, {Key? key}) : super(key: key);
  final SiteLocation siteLocation;
  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    final width = _getWidthBasedOnFilter();
    return Center(
      child: Container(
        width: width,
        padding: const EdgeInsets.only(right: 10, top: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _directionsButton(context),
            _detailsButton(),
            _discountOrGallon(),
          ],
        ),
      ),
    );
  }

  Widget _directionsButton(BuildContext context) {
    return Expanded(
      child: Center(
        child: TextButton(
          onPressed: () => _onDirectionClick(context),
          child: const Text(
            SiteLocatorConstants.directions,
            style: f16SemiboldBlack2Underline,
          ),
        ),
      ),
    );
  }

  Widget _detailsButton() {
    return Expanded(
      child: Center(
        child: TextButton(
          onPressed: _onDetailsClick,
          child: const Text(
            SiteLocatorConstants.details,
            style: f16SemiboldBlack2Underline,
          ),
        ),
      ),
    );
  }

  Widget _discountSite() {
    return SiteInfoUtils.canDisplayDiscount(siteLocation)
        ? const Expanded(
            child: Center(
              child: Chip(
                label: Text(
                  SiteLocatorConstants.discountSite,
                  style: f14BoldBlack,
                ),
                backgroundColor: SiteLocatorColors.discountBg,
                padding: EdgeInsets.only(top: 4, bottom: 6, left: 2, right: 2),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _gallonUp() {
    return SiteLocatorConfig.hasGallonNetwork(siteLocation)
        ? const Expanded(
            child: Center(
              child: Chip(
                label: Text(SiteLocatorConstants.gallonUp, style: f14BoldWhite),
                backgroundColor: SiteLocatorColors.darkBlue,
                padding: EdgeInsets.only(top: 4, bottom: 6, left: 2, right: 2),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  void _onDirectionClick(BuildContext context) {
    siteLocatorController.getListViewDirectionsLinkClickTrackAction();
    ExternalMapUtils(
      siteLocation.siteLatitude,
      siteLocation.siteLongitude,
    ).openExternalMapApp(context);
  }

  void _onDetailsClick() {
    siteLocatorController.getListViewDetailsLinkClickTrackAction();
    siteLocatorController.openSiteInfoFullView(siteLocation);
  }

  Widget _discountOrGallon() {
    return AppUtils.isComdata ? _gallonUp() : _discountSite();
  }

  double? _getWidthBasedOnFilter() {
    return SiteInfoUtils.canDisplayDiscount(siteLocation) ||
            SiteLocatorConfig.hasGallonNetwork(siteLocation)
        ? null
        : 250.0;
  }
}
