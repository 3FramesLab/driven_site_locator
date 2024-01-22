part of discount_module;

class DiscountController extends GetxController {
  final SiteLocatorController siteLocatorController = Get.find();
  final SimpleSaverDiscountValueUseCase _simpleSaverDiscountValueUseCase =
      Get.put(SimpleSaverDiscountValueUseCase());

  bool get isShowDeepSaverNotAvailableDetails =>
      Discounts.deepSaverBrandsValidateList.contains(
        siteLocatorController.selectedSiteLocation().fuelBrand?.toLowerCase(),
      );

  String get simpleSaverDiscountValue =>
      _simpleSaverDiscountValueUseCase.execute(
        SimpleSaverDiscountValueParams(
          selectedSiteFuelBrand: siteLocatorController
              .selectedSiteLocation()
              .fuelBrand
              ?.toLowerCase(),
        ),
      );
}
