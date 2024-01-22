import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/utilities/map_utilities.dart';
import 'package:driven_site_locator/site_locator/utilities/site_locator_utils.dart';
import 'package:driven_site_locator/site_locator/widgets/bottom_sheet/site_info_bottom_sheet_view.dart';
import 'package:get/get.dart';
import 'package:map_launcher/map_launcher.dart';

class ExternalMapUtils {
  final SiteLocatorController _siteLocatorController = Get.find();
  final double? _lat;
  final double? _lng;

  ExternalMapUtils(this._lat, this._lng);

  Future<void> openExternalMapApp(BuildContext context) async {
    if (await _isLocationPermissionGranted) {
      _siteLocatorController.isBottomModalSheetOpened(true);
      await _showAvailableMapAppsBottomSheet(context);
    } else {
      _enableLocationDialog();
    }
  }

  void _enableLocationDialog() {
    MapUtilities.showLocationEnableDialog();
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
    installedMapsStringList.add(SiteLocatorConstants.cancel);
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
    if (selectedMap == SiteLocatorConstants.cancel) {
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
      await SiteLocatorUtils.openExternalMapApp(
        selectedMap,
        Coords(_lat!, _lng!),
      );
    }
  }

  void _closeMapListSheet() {
    _siteLocatorController.isBottomModalSheetOpened(false);
    Get.back();
  }

  double _getMapListViewHeight(List<String> installedMaps) =>
      installedMaps.length * SiteLocatorConstants.siteInfoBottomListItemHeight >
              Get.height * 0.44
          ? Get.height * 0.44
          : installedMaps.length *
              SiteLocatorConstants.siteInfoBottomListItemHeight;

  Future<bool> get _isLocationPermissionGranted async =>
      MapUtilities.getLocationPermissionStatus();
}
