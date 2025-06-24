part of site_locator_module;

class ExternalMapUtils {
  final SLSiteLocatorController _siteLocatorController = Get.find();
  final double? _lat;
  final double? _lng;

  ExternalMapUtils(this._lat, this._lng);

  Future<void> openExternalMapApp(BuildContext context) async {
    _siteLocatorController.isBottomModalSheetOpened(true);
    await _showAvailableMapAppsBottomSheet(context);
  }

  Future<void> _showAvailableMapAppsBottomSheet(BuildContext context) async {
    _siteLocatorController.isBottomModalSheetVisible = true;
    final installedMaps = await _getInstalledMaps();
    _showBottomModalSheet(
      context,
      _mapAppsListView(installedMaps),
    );
  }

  Future<List<String>> _getInstalledMaps() async {
    List<String> installedMapsStringList = [];
    final installedMaps = await MapLauncher.installedMaps;
    installedMapsStringList = installedMaps.map((map) => map.mapName).toList();
    installedMapsStringList.add(SLViewText.cancel);
    return installedMapsStringList;
  }

  void _showBottomModalSheet(BuildContext context, Widget builderWidget) =>
      showModalBottomSheet(
        enableDrag: false,
        context: context,
        builder: (_) => builderWidget,
      ).whenComplete(_closeModalBottomSheet);

  Widget _mapAppsListView(List<String> installedMaps) {
    return SizedBox(
      height: _getMapListViewHeight(installedMaps),
      child: SiteInfoBottomSheetView(
        itemList: installedMaps,
        onItemTapped: (selectedMap) async {
          await _onMapItemTapped(selectedMap);
        },
      ),
    );
  }

  Future<void> _onMapItemTapped(String selectedMap) async {
    final availableMaps = await MapLauncher.installedMaps;
    if (selectedMap == SLViewText.cancel) {
      _closeMapListSheet();
    } else {
      final selectedAvailableMap =
          availableMaps.firstWhere((map) => map.mapName == selectedMap);
      await _openDirectionsApp(selectedAvailableMap);
    }
  }

  void _closeModalBottomSheet() {
    _siteLocatorController.isBottomModalSheetOpened(false);
  }

  Future<void> _openDirectionsApp(AvailableMap selectedMap) async {
    if (_lat != null && _lng != null) {
      Get.back();
      _siteLocatorController.isBottomModalSheetVisible = false;
      await DcSiteLocatorUtils.openExternalMapApp(
        selectedMap,
        originLatLng: _getOriginCoords(),
        destinationLatLng: Coords(_lat, _lng),
      );
    }
  }

  Coords _getOriginCoords() {
    return Coords(_siteLocatorController.prevUserCenterLocation.latitude,
        _siteLocatorController.prevUserCenterLocation.longitude);
  }

  void _closeMapListSheet() {
    _siteLocatorController.isBottomModalSheetOpened(false);
    Get.back();
  }

  double _getMapListViewHeight(List<String> installedMaps) =>
      installedMaps.length * SLInternalText.siteInfoBottomListItemHeight >
              Get.height * 0.44
          ? Get.height * 0.44
          : installedMaps.length * SLInternalText.siteInfoBottomListItemHeight;
}
