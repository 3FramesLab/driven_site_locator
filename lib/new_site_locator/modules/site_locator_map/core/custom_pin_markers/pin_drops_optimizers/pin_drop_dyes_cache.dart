part of site_locator_map_module;

enum PinDyeType {
  mc,
  pc,
}

class PinDropDyesCache {
  static Map<PinDropDyeKey, ui.Image> normalPinDyeStore = {};
  static Map<PinDropDyeKey, ui.Image> selectedPinDyeStore = {};

  static PinDropDyeKey dyeKey(
    Site site,
    String type, {
    bool hasLowestFuelPrice = false,
    bool isBig = false,
  }) {
    // hasDiscount & hasGallonUp merged to single param
    final hasDiscount =
        AppUtils.isComdata ? site.hasGallonUp : site.hasDiscount;

    return PinDropDyeKey(
      slType: type,
      hasPrice: getPriceCheck(site.price),
      hasDiscount: hasDiscount,
      // brandLogo: getLogo(site.brandLogoIdentifier),
      brandLogo: site.brandLogoIdentifier ?? '',
      isService: site.isServiceStation,
      // brandLogo: isBig
      //     ? site.brandLogoIdentifier ?? ''
      // : getLogo(site.brandLogoIdentifier),
      hasLowestFuelPrice: hasLowestFuelPrice,
    );
  }

  static bool getPriceCheck(double? price) {
    if (price != null && price > 0) {
      return true;
    }
    return false;
  }

  // static String getLogo(String? logo) => logo ?? '';
  // TODO(Smeet): may be use later for brand logo
//   static String getLogo(String? brandLogoName) {
//     final logo = NormalPinDrop.isTop5Brand(brandLogoName) ? brandLogoName : '';
//     return logo ?? '';
//     // return brandLogoName ?? '';
//   }
}

class PinDropDyeKey extends Equatable {
  final String slType;
  final bool hasPrice;
  final bool hasDiscount;
  final String brandLogo;
  final bool isService;
  final bool hasLowestFuelPrice;

  const PinDropDyeKey({
    required this.slType,
    required this.hasPrice,
    required this.hasDiscount,
    required this.brandLogo,
    required this.isService,
    required this.hasLowestFuelPrice,
  });

  @override
  List<Object?> get props => [
        slType,
        hasPrice,
        hasDiscount,
        brandLogo,
        isService,
        hasLowestFuelPrice,
      ];
}
