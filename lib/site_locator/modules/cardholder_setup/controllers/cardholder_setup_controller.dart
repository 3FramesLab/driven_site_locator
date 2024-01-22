part of cardholder_setup_module;

class CardholderSetupController extends GetxController {
  RxList<String> selectedPreferences = <String>[].obs;

  // use cases
  /// same as CheckSetUpWizardVisitStatusUseCase
  late CheckSetupVisitUseCase checkSetupVisitUseCase;
  late ChangeCardholderFilterPreferenceStatusUseCase
      changeCardholderFilterPreferenceStatusUseCase;

  // reusing use cases
  late SaveSetUpWizardVisitStatusUseCase saveSetUpWizardVisitStatusUseCase;
  late SaveFilterPreferencesUseCase saveFilterPreferencesUseCase;

  @override
  void onInit() {
    super.onInit();
    checkSetupVisitUseCase = CheckSetupVisitUseCase();
    saveSetUpWizardVisitStatusUseCase = SaveSetUpWizardVisitStatusUseCase();
    changeCardholderFilterPreferenceStatusUseCase =
        ChangeCardholderFilterPreferenceStatusUseCase();
    saveFilterPreferencesUseCase = SaveFilterPreferencesUseCase();
  }

  bool checkToShowSetup() => checkSetupVisitUseCase.execute();

  void onCloseClick() {
    if (Get.currentRoute == SiteLocatorRoutes.cardholderSetupPageOne) {
      onCloseSetup();
    } else {
      onCompleteSetup();
    }
  }

  // closing setup before completing
  void onCloseSetup() {
    saveSetUpWizardVisitStatusUseCase.execute();
    try {
      final siteLocatorController = Get.find<SiteLocatorController>();
      siteLocatorController.forceResetCanRecenterMapView = true;
      Get.back();
      if (!siteLocatorController.isUserAuthenticated) {
        siteLocatorController.navigateToSiteLocatorMapViewPage();
      } else {
        if (!Globals().isCardHolderLogin) {
          navigateToAdminDashboard();
        } else {
          // AdminRouteHelper.cardholderSiteLocatorMap();
          DrivenSiteLocator.instance.navigateToCardholderSiteLocatorMap?.call();
        }
      }
    } catch (_) {}
  }

  void navigateToAdminDashboard() {
    try {
      // Get.find<DashboardController>().navigateToAdminLocatorTab();
      DrivenSiteLocator.instance.navigateToAdminLocatorTab?.call();
    } catch (_) {}
  }

  Future<void> onCompleteSetup() async {
    if (selectedPreferences().isNotEmpty) {
      await applyFilterPreferences();
    }
    onCloseSetup();
    initEnhancedFilter();
  }

  void initEnhancedFilter() {
    try {
      Get.find<EnhancedFilterController>().initData();
    } catch (_) {}
  }

  void onPreferenceCheckChange({
    required SiteFilter siteFilter,
    required bool isChecked,
  }) {
    final param = ChangeCardholderFilterPreferenceStatusParam(
      siteFilter: siteFilter,
      selectedPreferences: List.from(selectedPreferences()),
    );

    selectedPreferences.value =
        changeCardholderFilterPreferenceStatusUseCase.execute(param);
  }

  bool containsFilter(String filterKey) =>
      selectedPreferences().contains(filterKey);

  Future<void> applyFilterPreferences() async =>
      await saveFilterPreferencesUseCase.execute(selectedPreferences());
}
