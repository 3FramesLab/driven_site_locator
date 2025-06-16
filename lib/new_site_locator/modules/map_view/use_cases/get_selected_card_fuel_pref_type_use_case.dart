import 'package:driven_site_locator/use_cases/base_future_usecase.dart';
import 'package:driven/modules/wallet/controllers/wallet_controller.dart';
import 'package:driven/site_locator/data/models/fuel_preferences.dart';
import 'package:get/get.dart';

class GetSelectedCardFuelPrefTypeUseCase extends BaseFutureUseCase<
    FuelPreferenceType, GetSelectedCardFuelPrefTypeParams> {
  @override
  Future<FuelPreferenceType> execute(
      GetSelectedCardFuelPrefTypeParams param) async {
    final selectedCardCustomerId = Get.find<WalletController>()
        .wallet()
        .activeCard
        .customerId
        .toLowerCase();

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
