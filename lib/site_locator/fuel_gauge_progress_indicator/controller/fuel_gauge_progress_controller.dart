import 'package:driven_site_locator/site_locator/fuel_gauge_progress_indicator/fuel_gauge_dial_props.dart';
import 'package:get/get.dart';

class FuelGaugeProgressController extends GetxController {
  RxDouble progressValue = 0.0.obs;
  RxBool canShowFuelGaugeIndicator = false.obs;
  RxString statusMessage = FuelGaugeProps.findingFuelLocationMessage.obs;

  void setFindingSiteLocationsMessage() {
    statusMessage(FuelGaugeProps.findingFuelLocationMessage);
  }

  void setRetrievingFuelPricesMessage({required bool isUserAuthenticated}) {
    final message = isUserAuthenticated
        ? FuelGaugeProps.retrievingFuelPricesAuthMessage
        : FuelGaugeProps.retrievingFuelPricesUnAuthMessage;
    statusMessage(message);
  }

  void resetMessage() {
    statusMessage(FuelGaugeProps.findingFuelLocationMessage);
  }
}
