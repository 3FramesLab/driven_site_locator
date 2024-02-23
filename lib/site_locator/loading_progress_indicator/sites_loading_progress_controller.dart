import 'package:driven_site_locator/site_locator/loading_progress_indicator/sites_loading_progress_props.dart';
import 'package:get/get.dart';

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
}
