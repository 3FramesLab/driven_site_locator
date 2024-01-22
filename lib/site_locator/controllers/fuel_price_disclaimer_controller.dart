import 'package:driven_site_locator/site_locator/modules/filters/filter_module.dart';
import 'package:driven_site_locator/site_locator/use_cases/fuel_price_disclaimer_marked/check_fuel_price_disclaimer_status_use_case.dart';
import 'package:driven_site_locator/site_locator/use_cases/fuel_price_disclaimer_marked/save_fuel_price_disclaimer_status_use_case.dart';
import 'package:get/get.dart';

class FuelPriceDisclaimerController extends GetxController {
  RxBool isFuelPriceDisclaimerVisible = true.obs;
  RxBool isFuelDisclaimerCheckboxMarked = false.obs;

  //use case
  late CheckFuelPriceDisclaimerStatusUseCase
      checkFuelPriceDisclaimerStatusUseCase;
  late SaveFuelPriceDisclaimerStatusUseCase
      saveFuelPriceDisclaimerStatusUseCase;

  @override
  void onInit() {
    super.onInit();
    checkFuelPriceDisclaimerStatusUseCase =
        Get.put(CheckFuelPriceDisclaimerStatusUseCase());
    saveFuelPriceDisclaimerStatusUseCase =
        Get.put(SaveFuelPriceDisclaimerStatusUseCase());
    checkToShowFuelDisclaimer();
  }

  bool checkToShowFuelDisclaimer() => isFuelPriceDisclaimerVisible(
        checkFuelPriceDisclaimerStatusUseCase.execute(),
      );

  void updateFuelPriceDisclaimerValueInSP() {
    saveFuelPriceDisclaimerStatusUseCase.execute();
    isFuelPriceDisclaimerVisible(false);
  }

  void markDoneFuelPriceDisclaimer() {
    updateFuelPriceDisclaimerValueInSP();
  }

  void onAcceptFuelPriceDisclaimer() {
    markDoneFuelPriceDisclaimer();
    Get.back();
    applyFilterPreference();
  }

  void applyFilterPreference() {
    try {
      Get.find<EnhancedFilterController>().applyFilterPreference();
    } catch (_) {}
  }
}
