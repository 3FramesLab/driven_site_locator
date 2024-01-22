import 'package:driven_site_locator/site_locator/site_locator_map/core/custom_pin_markers/custom_pin.dart';
import 'package:driven_site_locator/site_locator/site_locator_map/core/site_locator_map.dart';
import 'package:driven_site_locator/site_locator/site_locator_map/models/site.dart';

class PinVariantStore {
  static List<MarkerDetails> statusList = [];

  static Future<List<MarkerDetails>> init() async {
    _clear();
    // ignore: join_return_with_assignment
    statusList = await generateStore(siteList: []);
    return statusList;
  }

  static void _clear() {
    statusList = [];
  }

  static Future<void> siteListPinStore(List<Site> siteList) async {
    _clear();
    statusList = await generateStore(siteList: siteList);
  }

  static Future<List<MarkerDetails>> generateStore(
      {List<Site>? siteList}) async {
    final List<MarkerDetails> listTemp = [];

    for (final Site site in siteList ?? []) {
      final markerCanvasIcon = await CustomPin.normalMarker(site);
      final selectedMarkerCanvasIcon = await CustomPin.selectedMarker(site);

      listTemp.add(
        MarkerDetails(
          keyIdentifier: site.id,
          site: site,
          smallIcon: markerCanvasIcon,
          bigIcon: selectedMarkerCanvasIcon,
        ),
      );
    }
    return listTemp;
  }

  static Future<MarkerDetails?> getMarkerDetails(Site? site) async {
    if (site != null) {
      final markerCanvasIcon = await CustomPin.normalMarker(site);
      final selectedMarkerCanvasIcon = await CustomPin.selectedMarker(site);

      return MarkerDetails(
        keyIdentifier: site.id,
        site: site,
        smallIcon: markerCanvasIcon,
        bigIcon: selectedMarkerCanvasIcon,
      );
    }
    return null;
  }
}
