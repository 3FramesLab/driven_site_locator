part of list_view_module;

class CardInfoBodyRight extends StatelessWidget {
  CardInfoBodyRight(this.siteLocation, {Key? key}) : super(key: key);

  final SiteLocation siteLocation;
  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardInfoFuelPriceFork(siteLocation),
          _favoriteSection(),
          _serviceOrTime(),
        ],
      ),
    );
  }

  Widget _favoriteSection() {
    return Obx(() {
      final favoriteKey = siteLocation.siteIdentifier?.toString() ??
          SiteLocatorConstants.unknownKey;
      final topPadding =
          SiteInfoUtils.canDisplayBrandLogo(siteLocation) ? 8.0 : 18.0;
      return Semantics(
        container: true,
        label: SemanticStrings.siteInfoFavorite,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: SiteInfoDetail(
            iconData: siteLocatorController.favoriteList.contains(favoriteKey)
                ? Icons.favorite
                : Icons.favorite_outline,
            iconColor: siteLocatorController.favoriteList.contains(favoriteKey)
                ? DrivenColors.brandPurple
                : DrivenColors.textColor,
            description:
                siteLocatorController.favoriteList.contains(favoriteKey)
                    ? SiteLocatorConstants.favorite
                    : SiteLocatorConstants.addFavorite,
            onDescriptionTap: () =>
                siteLocatorController.manageFavorite(favoriteKey),
          ),
        ),
      );
    });
  }

  Widget _serviceOrTime() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: AppUtils.isComdata ? _timeWidget() : _serviceWidget(),
    );
  }

  Widget _serviceWidget() => SiteInfoUtils.getServiceWidget(siteLocation);

  Widget _timeWidget() => SiteInfoUtils.getTimeWidget(siteLocation);
}
