part of map_view_module;

class SiteLocatorMapUI extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();
  static final entitlementRepository = SiteLocatorEntitlementUtils.instance;
  final Function(CameraPosition)? onCameraMove;
  final Function()? onCameraIdle;

  SiteLocatorMapUI({
    Key? key,
    this.onCameraIdle,
    this.onCameraMove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SiteLocatorMap(
        key: ValueKey<int>(siteLocatorController.mapKeyValue()),
        customMarker: true,
        zoom: UmaSLProperties.mapZoomLevel,
        onCameraMove: onCameraMove,
        onCameraIdle: onCameraIdle,
        isFixedCircleRadiusVisible:
            entitlementRepository.isFixedCircleRadiusEnabled,
        isMovingCircleRadiusVisible:
            entitlementRepository.isMovingCircleRadiusEnabled,
        fixedCircleRadiusColor: _fixedCircleRadiusColor,
        movingCircleRadiusColor: _movingCircleRadiusColor,
      ),
    );
  }

  Color get _fixedCircleRadiusColor => DrivenColors.primary;

  Color get _movingCircleRadiusColor =>
      entitlementRepository.isFixedCircleRadiusEnabled
          ? DrivenColors.successGreenColor
          : DrivenColors.primary;
}
