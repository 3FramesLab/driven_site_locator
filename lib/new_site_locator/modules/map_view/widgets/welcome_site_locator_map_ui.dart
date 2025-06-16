part of map_view_module;

class WelcomeSiteLocatorMapUI extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();
  final Function(CameraPosition)? onCameraMove;
  final Function()? onCameraIdle;

  WelcomeSiteLocatorMapUI({
    Key? key,
    this.onCameraIdle,
    this.onCameraMove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: siteLocatorController.getMapHeight(context),
      child: WelcomeSiteLocatorMap(
        key: ValueKey<int>(siteLocatorController.welcomeMapKeyValue),
        customMarker: true,
        zoom: UmaSLProperties.mapZoomLevel,
        onCameraMove: onCameraMove,
        onCameraIdle: onCameraIdle,
      ),
    );
  }
}
