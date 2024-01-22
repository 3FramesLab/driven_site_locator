import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/data/use_cases/base_usecase.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';

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

        if (AppUtils.isComdata) {
          pinDropBgPath = param.hasGallonUp ?? false
              ? SiteLocatorAssets.pinBgGallonUpFilePathDFC
              : SiteLocatorAssets.pinBgNormalFilePathDFC;
        }
        return pinDropBgPath;

      // Pin drop type with price banner
      case PinDropImageType.bannerPinDropBg:
        String bannerPinDropBgPath = param.hasDiscount ?? false
            ? SiteLocatorAssets.discountPriceBannerPinFilePath
            : SiteLocatorAssets.normalPriceBannerPinFilePath;

        if (AppUtils.isComdata) {
          bannerPinDropBgPath = param.hasGallonUp ?? false
              ? SiteLocatorAssets.gallonUpPriceBannerPinFilePathDFC
              : SiteLocatorAssets.normalPriceBannerPinFilePathDFC;
        }
        return bannerPinDropBgPath;

      // Big Pin drop (selected view)
      case PinDropImageType.bigPinDropBg:
        String bigPinDropBgPath = param.hasDiscount ?? false
            ? SiteLocatorAssets.pinBgDiscountFilePath
            : SiteLocatorAssets.pinBgFilePath;

        if (AppUtils.isComdata) {
          bigPinDropBgPath = param.hasGallonUp ?? false
              ? SiteLocatorAssets.pinBgGallonUpFilePathDFC
              : SiteLocatorAssets.pinBgNormalFilePathDFC;
        }
        return bigPinDropBgPath;
    }
  }
}

class PindropImagePathUseCaseParam {
  final PinDropImageType type;
  final bool? hasDiscount;
  final bool? hasGallonUp;

  PindropImagePathUseCaseParam({
    this.type = PinDropImageType.pinDropBg,
    this.hasDiscount = false,
    this.hasGallonUp = false,
  });
}

enum PinDropImageType {
  pinDropBg,
  bannerPinDropBg,
  bigPinDropBg,
}
