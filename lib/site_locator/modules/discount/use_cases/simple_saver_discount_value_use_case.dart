import 'package:driven_site_locator/data/use_cases/base_usecase.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';

class SimpleSaverDiscountValueUseCase
    extends BaseUseCase<String, SimpleSaverDiscountValueParams> {
  @override
  String execute(SimpleSaverDiscountValueParams param) =>
      Discounts.simpleSaverBrandsValidateList
              .contains(param.selectedSiteFuelBrand)
          ? Discounts.simpleSaverBrandedDieselUnleadedRebate
          : Discounts.simpleSaverUnBrandedDieselUnleadedRebate;
}

class SimpleSaverDiscountValueParams {
  String? selectedSiteFuelBrand;
  SimpleSaverDiscountValueParams({required this.selectedSiteFuelBrand});
}
