part of map_view_module;

class SiteMilesAway extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();
  final SiteLocation siteLocation;

  SiteMilesAway({
    required this.siteLocation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: _drivingMiles(),
    );
  }

  Widget contentRow(String text, {TextStyle? style}) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _icon,
          const SizedBox(width: 4),
          _shareYourLocationText(text, style: style),
        ],
      );

  Widget get _icon => const Icon(
        Icons.directions_car_outlined,
        color: DrivenColors.grey,
        size: 16,
      );

  Widget _shareYourLocationText(String text, {TextStyle? style}) => Expanded(
        child: Text(
          text,
          style: style ?? f14RegularGrey,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );

  Widget _drivingMiles() {
    return Obx(
      () {
        final SiteLocatorController siteLocatorController = Get.find();
        final milesData = siteLocatorController.displayMiles(siteLocation);

        final linkStyle = f14RegularGrey.copyWith(
          decoration: TextDecoration.underline,
        );

        final isLocationPermissionGranted =
            siteLocatorController.isLocationEnabled;

        final myLocaFlag = siteLocatorController.isLocationEnabled;

        if (siteLocatorController.getMilesInProgress()) {
          return const SizedBox();
        } else if (!isLocationPermissionGranted) {
          return GestureDetector(
            onTap: _onShareMyLocationTap,
            child: contentRow(
              SLInternalText.shareYourLocation,
              style: linkStyle,
            ),
          );
        } else {
          return contentRow(
            SiteInfoUtils.milesDescription(
              milesData,
              isLocationEnabled: myLocaFlag,
            ),
          );
        }
      },
    );
  }

  void _onShareMyLocationTap() {
    Get.dialog(
      ShareMyLocationDialog(
        onAllowShareMyLocation: siteLocatorController.onShareYourLocationClick,
      ),
    );
  }
}
