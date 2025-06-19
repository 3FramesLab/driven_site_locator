part of site_locator_map_module;

class DefaultBrandLogos {
  static ui.Image? small;
  static ui.Image? big;

  Future<void> setup() async {
    small =
        await CustomPin.defaultLogo(BrandLogoSize.small, BrandLogoSize.small);
    big = await CustomPin.defaultLogo(BrandLogoSize.big, BrandLogoSize.big,
        bigSize: true);
    await CustomPin.preCacheSiteLocatorAssets();
  }
}
