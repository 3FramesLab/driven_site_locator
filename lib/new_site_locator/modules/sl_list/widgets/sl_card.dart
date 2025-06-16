part of sl_list_module;

class SLCard extends GetView<SiteLocatorController> {
  static final _entitlementRepository = SiteLocatorEntitlementUtils.instance;
  final SiteLocatorController _siteLocatorController = Get.find();

  final SiteLocation siteLocation;
  final int index;

  SLCard(this.siteLocation, this.index);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onListItemTap,
      child: Container(
        color: SiteInfoUtils.getCardBgColor(index),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _brandNameText,
                              _siteNameText,
                            ],
                          ),
                          SiteMilesAway(siteLocation: siteLocation),
                          SiteAddress(siteLocation: siteLocation),
                          if (isGoogleRatingEnabled) _ratings,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 3),
                  SLCardFuelPriceFork(siteLocation),
                ],
              ),
            ),
            _footer,
            SiteInfoUtils.slCardDivider(),
          ],
        ),
      ),
    );
  }

  Widget get _brandNameText => Text(
        SiteInfoUtils.displayFuelBrandName(siteLocation),
        style: f16ExtraBoldBlack,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

  Widget get _siteNameText => Text(
        SiteInfoUtils.getLocationName(siteLocation),
        style: f14SemiBoldBlack,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

  void onListItemTap() {
    /// Uncomment below lines if we want expand and collapse the addition
    /// card details on tap.
    // controller.selectedSiteListIndex.value =
    //     controller.selectedSiteListIndex() == index ? -1 : index;
    _siteLocatorController.updateRecentViewLocations(siteLocation);
    siteDetailPopup(siteLocation);
  }

  Widget get _footer => Obx(() {
        return controller.selectedSiteListIndex() == index
            ? SLCardDetailsFooter(siteLocation: siteLocation)
            : const SizedBox.shrink();
      });

  Widget get _ratings => SiteRating(
        siteLocation,
        showSeparator: false,
        padding: const EdgeInsets.only(bottom: 6),
      );

  bool get isGoogleRatingEnabled =>
      _entitlementRepository.isGoogleRatingEnabled;
}
