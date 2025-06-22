part of site_locator_map_module;

class DefaultBrandLogos {
  static bool isSetup = false;

  Future<void> setup() async {
    await CustomPin.preCacheSiteLocatorAssets();
    isSetup = true;
  }
}
