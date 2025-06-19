part of site_locator_map_module;

class PindropImagePathUseCase
    extends BaseUseCase<String, PindropImagePathUseCaseParam> {
  PindropImagePathUseCase();

  @override
  String execute(PindropImagePathUseCaseParam param) {
    switch (param.type) {
      // Pin drop type without price banner
      case PinDropImageType.pinDropBg:
        String pinDropBgPath = param.hasDiscount ?? false
            ? SiteLocatorAssets.pinBgDiscountFilePath
            : SiteLocatorAssets.pinBgFilePath;

        // pinDropBgPath = param.hasGallonUp ?? false
        // final xPath = param.hasGallonUp ?? false
        //     ? SiteLocatorAssets.pinBgGallonUpFilePathDFC
        //     : SiteLocatorAssets.pinBgNormalFilePathDFC;

        pinDropBgPath = SiteLocatorAssets.pinBgNormalFilePathDFC;
        return pinDropBgPath;

      // Pin drop type with price banner
      case PinDropImageType.bannerPinDropBg:
        String bannerPinDropBgPath = param.hasDiscount ?? false
            ? SiteLocatorAssets.discountPriceBannerPinFilePath
            : SiteLocatorAssets.normalPriceBannerPinFilePath;

        // final xPath = param.hasGallonUp ?? false
        //     ? SiteLocatorAssets.gallonUpPriceBannerPinFilePathDFC
        //     : SiteLocatorAssets.normalPriceBannerPinFilePathDFC;

        bannerPinDropBgPath = SiteLocatorAssets.normalPriceBannerPinFilePathDFC;

        if (param.hasLowestFuelPrice) {
          bannerPinDropBgPath = SiteLocatorAssets.lowestPricePinDrop;
        }
        return bannerPinDropBgPath;

      // Big Pin drop (selected view)
      case PinDropImageType.bigPinDropBg:
        String bigPinDropBgPath = param.hasDiscount ?? false
            ? SiteLocatorAssets.pinBgDiscountFilePath
            : SiteLocatorAssets.pinBgFilePath;

        // bigPinDropBgPath = param.hasGallonUp ?? false
        // final xPath = param.hasGallonUp ?? false
        //     ? SiteLocatorAssets.pinBgGallonUpFilePathDFC
        //     : SiteLocatorAssets.selectedWithLogoPinFilePathDFC;

        bigPinDropBgPath = SiteLocatorAssets.selectedWithLogoPinFilePathDFC;

        return bigPinDropBgPath;
    }
  }
}

class PindropImagePathUseCaseParam {
  final PinDropImageType type;
  final bool? hasDiscount;
  final bool? hasGallonUp;
  final bool hasLowestFuelPrice;

  PindropImagePathUseCaseParam({
    this.type = PinDropImageType.pinDropBg,
    this.hasDiscount = false,
    this.hasGallonUp = false,
    this.hasLowestFuelPrice = false,
  });
}

enum PinDropImageType {
  pinDropBg,
  bannerPinDropBg,
  bigPinDropBg,
}
