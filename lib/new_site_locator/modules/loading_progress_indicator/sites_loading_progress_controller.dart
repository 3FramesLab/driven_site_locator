part of loading_progress_indicator_module;

class SitesLoadingProgressController extends GetxController {
  RxDouble progressValue = 0.0.obs;
  RxBool canShowIndicator = false.obs;
  RxString statusMessage =
      SitesLoadingProgressProps.findingFuelLocationMessage.obs;

  void setFindingSiteLocationsMessage() {
    statusMessage(SitesLoadingProgressProps.findingFuelLocationMessage);
  }

  void setRetrievingFuelPricesMessage({required bool isUserAuthenticated}) {
    final message = isUserAuthenticated
        ? SitesLoadingProgressProps.retrievingFuelPricesAuthMessage
        : SitesLoadingProgressProps.retrievingFuelPricesUnAuthMessage;
    statusMessage(message);
  }

  void resetMessage() {
    statusMessage(SitesLoadingProgressProps.findingFuelLocationMessage);
  }

  final RxBool isMapPositionChanged = false.obs;
  final buttonArea = 160.0;
  final buttonWidthAnimationDuration = const Duration(milliseconds: 300);
  final buttonHeight = 50.0;
  final loaderProgressAnimationDuration = const Duration(milliseconds: 100);
  RxDouble buttonWidth = 160.0.obs;
  RxBool isLoading = false.obs;
  RxDouble loaderProgress = 0.0.obs;
  RxBool completeMapLoader = false.obs;

  Future<void> onSearchThisAreaButtonTap() async {
    isMapPositionChanged(false);
    final siteLocatorController = Get.find<SiteLocatorController>();
    if (!isLoading.value && !completeMapLoader.value) {
      buttonWidth.value = 50;
      await Future.delayed(buttonWidthAnimationDuration);
      isLoading.value = true;
      try {
        await siteLocatorController.onSearchThisAreaButtonTap();
      } catch (_) {}
      isLoading.value = false;
      completeMapLoader.value = true;
      buttonWidth.value = 175;
      await Future.delayed(buttonWidthAnimationDuration);
      await Future.delayed(const Duration(milliseconds: 500));
      if (!isMapPositionChanged()) {
        siteLocatorController.isShowSearchThisArea(false);
        siteLocatorController.isLatLngBoundsChanged(false);
      }
      completeMapLoader.value = false;
      loaderProgress.value = 0.0;
    }
  }
}
