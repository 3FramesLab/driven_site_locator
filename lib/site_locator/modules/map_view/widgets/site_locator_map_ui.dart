part of map_view_module;

class SiteLocatorMapUI extends StatelessWidget {
  final SiteLocatorController siteLocatorController;
  final Function(CameraPosition)? onCameraMove;
  final Function()? onCameraIdle;

  const SiteLocatorMapUI({
    required this.siteLocatorController,
    Key? key,
    this.onCameraIdle,
    this.onCameraMove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: siteLocatorController.getMapHeight(context),
        child: SiteLocatorMap(
          siteLocatorController: siteLocatorController,
          key: ValueKey<int>(siteLocatorController.mapKeyValue()),
          siteList: siteLocatorController.siteList(),
          customMarker: true,
          zoom: SiteLocatorConfig.mapZoomLevel,
          onCameraMove: onCameraMove,
          onCameraIdle: onCameraIdle,
        ),
      ),
    );
  }
}
