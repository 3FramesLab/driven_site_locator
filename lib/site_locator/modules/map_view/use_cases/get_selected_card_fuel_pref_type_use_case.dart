import 'package:driven_site_locator/data/use_cases/base_future_usecase.dart';
import 'package:driven_site_locator/driven_site_locator.dart';
import 'package:driven_site_locator/site_locator/data/models/fuel_preferences.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/use_cases/cache_fuel_price/manage_cache_fuel_prices.dart';
import 'package:get/get.dart';

class GetSelectedCardFuelPrefTypeUseCase extends BaseFutureUseCase<
    FuelPreferenceType, GetSelectedCardFuelPrefTypeParams> {
  @override
  Future<FuelPreferenceType> execute(
      GetSelectedCardFuelPrefTypeParams param) async {
    final selectedCardCustomerId =
        DrivenSiteLocator.instance.customerId.toLowerCase();
    ManageCacheFuelPrices.selectedCardCustomerIdCached = selectedCardCustomerId;
    final selectedCardDetails = param.fuelPreferencesList
        .firstWhereOrNull((e) => e.customerId == selectedCardCustomerId);
    if (selectedCardDetails != null) {
      return selectedCardDetails.fuelPreferenceType ?? FuelPreferenceType.both;
    }
    return FuelPreferenceType.both;
  }
}

class GetSelectedCardFuelPrefTypeParams {
  final List<FuelPreferences> fuelPreferencesList;

  GetSelectedCardFuelPrefTypeParams({required this.fuelPreferencesList});
}
