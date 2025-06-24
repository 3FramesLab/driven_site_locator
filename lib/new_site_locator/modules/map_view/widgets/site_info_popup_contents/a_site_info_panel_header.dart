part of map_view_module;

class SiteInfoPanelHeader extends StatelessWidget {
  final SLSiteLocatorController siteLocatorController = Get.find();
  final SiteLocation siteLocation;

  SiteInfoPanelHeader({
    required this.siteLocation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _brandLogo,
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _brandNameText,
                _siteNameText,
                // _locationAddress(context),
                _getRatings(siteLocation),
              ],
            ),
          ),
        ),
        _cancelButton(context),
      ],
    );
  }

  Widget get _brandLogo => Padding(
        padding: const EdgeInsets.only(right: 8, top: 8),
        child: Semantics(
          container: true,
          label: SLSemanticStrings.siteInfoBrandLogo,
          child: SiteInfoUtils.getDisplayBrandLogo(
            siteLocation,
            hasToSwitchMCSites: siteLocatorController.hasToSwitchMCSites.value,
          ),
        ),
      );

  Widget get _brandNameText => Text(
        SiteInfoUtils.displayFuelBrandName(siteLocation),
        style: f18ExtraBoldBlack,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

  Widget get _siteNameText => Text(
        SiteInfoUtils.getLocationName(siteLocation),
        style: f14SemiBoldBlack,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

  Widget _cancelButton(context) {
    return InkWell(
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        child: const Icon(
          Icons.close,
          color: DrivenColors.black,
          size: 24,
        ),
      ),
      onTap: () {
        Navigator.of(context, rootNavigator: true)
            .pop(siteLocatorController.selectedMapPinKey);
      },
    );
  }

  Widget _getRatings(selectedSiteLocation) {
    return SiteRating(
      selectedSiteLocation,
      padding: const EdgeInsets.only(top: 5, bottom: 5),
    );
  }

  // Widget _locationAddress(context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         SiteInfoUtils.getLocationName(selectedSiteLocation),
  //         style: f18ExtraBoldBlack,
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //       Text(
  //         getFullAddress(),
  //         style: f16RegularGrey,
  //         maxLines: 2,
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //     ],
  //   );
  // }
}
