part of site_locator_map_module;

class SLPindropImagePathUseCase
    extends BaseUseCase<String, PindropImagePathUseCaseParam> {
  SLPindropImagePathUseCase();

  @override
  String execute(PindropImagePathUseCaseParam param) {
    switch (param.type) {
      // Pin drop type without price banner
      case PinDropImageType.pinDropBg:
        const pinDropBgPath = SLAssets.pinBgNormalFilePathDFC;
        return pinDropBgPath;

      // Pin drop type with price banner
      case PinDropImageType.bannerPinDropBg:
        String bannerPinDropBgPath = SLAssets.normalPriceBannerPinFilePathDFC;

        if (param.hasLowestFuelPrice) {
          bannerPinDropBgPath = SLAssets.lowestPricePinDrop;
        }
        return bannerPinDropBgPath;

      // Big Pin drop (selected view)
      case PinDropImageType.bigPinDropBg:
        String bigPinDropBgPath = param.hasDiscount ?? false
            ? SLAssets.pinBgDiscountFilePath
            : SLAssets.pinBgFilePath;

        bigPinDropBgPath = SLAssets.selectedWithLogoPinFilePathDFC;

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
