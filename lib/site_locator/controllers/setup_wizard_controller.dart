import 'package:driven_site_locator/site_locator/data/models/site_filter.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/use_cases/setup_wizard/personalized_filters/change_filter_preference_status_use_case.dart';
import 'package:driven_site_locator/site_locator/use_cases/setup_wizard/personalized_filters/save_filter_preferences_use_case.dart';
import 'package:driven_site_locator/site_locator/use_cases/setup_wizard/setup_wizard_parent/check_setup_wizard_visit_use_case.dart';
import 'package:driven_site_locator/site_locator/use_cases/setup_wizard/setup_wizard_parent/save_setup_wizard_visit_use_case.dart';
import 'package:driven_site_locator/site_locator/widgets/dialogs/fuel_price_disclaimer_dialog.dart';
import 'package:get/get.dart';

class SetUpWizardController extends GetxController {
  RxBool canShowSetUpWizard = false.obs;
  RxList<String> selectedPreferences = <String>[].obs;

  //use cases
  late CheckSetUpWizardVisitStatusUseCase checkSetUpWizardVisitStatusUseCase;
  late SaveSetUpWizardVisitStatusUseCase saveSetUpWizardVisitStatusUseCase;
  late ChangeFilterPreferencesStatusUseCase
      changeFilterPreferencesStatusUseCase;
  late SaveFilterPreferencesUseCase saveFilterPreferencesUseCase;

  @override
  void onInit() {
    super.onInit();
    checkSetUpWizardVisitStatusUseCase = CheckSetUpWizardVisitStatusUseCase();
    saveSetUpWizardVisitStatusUseCase = SaveSetUpWizardVisitStatusUseCase();
    changeFilterPreferencesStatusUseCase =
        ChangeFilterPreferencesStatusUseCase();
    saveFilterPreferencesUseCase = SaveFilterPreferencesUseCase();
    checkToShowSetUpWizard();
  }

  bool checkToShowSetUpWizard() =>
      canShowSetUpWizard(checkSetUpWizardVisitStatusUseCase.execute());

  void onSetUpWizardClosedHandler() {
    try {
      (Get.find<SiteLocatorController>()).forceResetCanRecenterMapView = true;
    } catch (_) {}
    canShowSetUpWizard(false);
    saveSetUpWizardVisitStatusUseCase.execute();
    _showFuelPriceDisclaimer();
  }

  Future<void> _showFuelPriceDisclaimer() => Get.dialog(
        FuelPriceDisclaimerDialog(),
        barrierDismissible: false,
      );

  void completesSetUpWizard() {
    onSetUpWizardClosedHandler();
  }

  void onPreferenceCheckChange({
    required SiteFilter siteFilter,
    required bool isChecked,
  }) {
    final param = ChangeFilterPreferenceStatusUseCaseParam(
      siteFilter: siteFilter,
      isChecked: isChecked,
      selectedPreferences: List.from(selectedPreferences()),
    );

    selectedPreferences.value =
        changeFilterPreferencesStatusUseCase.execute(param);
  }

  Future<void> applyFilterPreferences() async =>
      await saveFilterPreferencesUseCase.execute(selectedPreferences());
}
