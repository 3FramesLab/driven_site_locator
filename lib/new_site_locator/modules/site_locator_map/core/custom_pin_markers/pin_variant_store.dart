part of site_locator_map_module;

int startTime = DateTime.now().millisecondsSinceEpoch;

class SLPinVariantStore {
  static List<MarkerDetails> statusList = [];

  static Future<List<MarkerDetails>> init() async {
    _clear();
    // ignore: join_return_with_assignment
    statusList = await generateStore(siteList: []);
    return statusList;
  }

  static Future<void> iniDefaultLogos() async {
    await _setDefaultPinLogo();
  }

  static void _clear() {
    statusList = [];
  }

  static Future<void> siteListPinStore(List<Site> siteList) async {
    _clear();
    statusList = await generateStore(siteList: siteList);
  }

  static Future<List<MarkerDetails>> generateStore({
    List<Site>? siteList,
    double? lowestFuelPrice,
  }) async {
    final List<MarkerDetails> listTemp = [];
    if (!DefaultBrandLogos.isSetup) {
      await DefaultBrandLogos().setup();
    }

    startTime = DateTime.now().millisecondsSinceEpoch;

    await _setDefaultPinLogo();

    final sites = siteList ?? [];

    // Prepare all MarkerDetails in parallel
    final markerFutures = sites.map((site) async {
      final normalPinDropIcon = getImage(site) ??
          await NormalPinDrop.make(
            site,
            isLowestFuelPrice: lowestFuelPrice != null &&
                lowestFuelPrice > 0 &&
                lowestFuelPrice == site.price,
          );
      final selectedPinDropIcon =
          getImage(site, isSelected: true) ?? await SelectedPinDrop.make(site);

      return MarkerDetails(
        keyIdentifier: site.id,
        site: site,
        smallIcon: normalPinDropIcon,
        bigIcon: selectedPinDropIcon,
      );
    }).toList();

    final results = await Future.wait(markerFutures);

    listTemp.addAll(results);

    final endTime = DateTime.now().millisecondsSinceEpoch;
    final trackedTime = endTime - startTime;
    debugPrint('debug-print Pindrop creation time = $trackedTime');
    return listTemp;
  }

  static Future<MarkerDetails?> getMarkerDetails(
    Site? site, {
    bool isLowestFuelPrice = false,
  }) async {
    await _setDefaultPinLogo();

    if (site != null) {
      // final normalPinDropIcon =
      //     await NormalPinDrop.make(site, isLowestFuelPrice: isLowestFuelPrice);
      final normalPinDropIcon = getImage(site) ??
          await NormalPinDrop.make(site, isLowestFuelPrice: isLowestFuelPrice);

      // final selectedPinDropIcon = await SelectedPinDrop.make(site);
      final selectedPinDropIcon =
          getImage(site, isSelected: true) ?? await SelectedPinDrop.make(site);

      return MarkerDetails(
        keyIdentifier: site.id,
        site: site,
        smallIcon: normalPinDropIcon,
        bigIcon: selectedPinDropIcon,
      );
    }
    return null;
  }

  static BitmapDescriptor? fuelPin;
  static BitmapDescriptor? servicePin;
  static BitmapDescriptor? fuelPinSelected;
  static BitmapDescriptor? servicePinSelected;

  static BitmapDescriptor? getImage(Site site, {bool isSelected = false}) {
    if (site.isServiceStation) {
      return isSelected ? servicePinSelected : servicePin;
    }
    if (site.price == null || site.price! <= 0) {
      if (!NormalPinDrop.isTopBrand(site.brandLogoIdentifier)) {
        return isSelected ? fuelPinSelected : fuelPin;
      }
    }
    return null;
  }

  static Future<void> _setDefaultPinLogo() async {
    // for no price no logo, its fuel
    final fuelSite = Site(
      id: 'fuel',
      latitude: 0,
      longitude: 0,
      shopName: '',
    );
    fuelPin ??= await NormalPinDrop.make(fuelSite);

    // for no price no logo, its service
    final serviceSite = Site(
      id: 'service',
      latitude: 0,
      longitude: 0,
      shopName: '',
      isServiceStation: true,
    );
    servicePin ??= await NormalPinDrop.make(serviceSite);

    // for no price no logo, its fuel, SELECTED
    final fuelSiteSelected = Site(
      id: 'fuel',
      latitude: 0,
      longitude: 0,
      shopName: '',
    );
    fuelPinSelected ??= await SelectedPinDrop.make(fuelSiteSelected);

    // for no price no logo, its service, SELECTED
    final serviceSiteSelected = Site(
      id: 'service',
      latitude: 0,
      longitude: 0,
      shopName: '',
      isServiceStation: true,
    );
    servicePinSelected ??= await SelectedPinDrop.make(serviceSiteSelected);
  }
}
