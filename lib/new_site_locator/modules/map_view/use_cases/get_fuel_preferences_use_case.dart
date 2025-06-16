import 'package:driven/common/utilities/app_utils.dart';
import 'package:driven_site_locator/use_cases/base_future_usecase.dart';
import 'package:driven/modules/wallet/controllers/wallet_controller.dart';
import 'package:driven/site_locator/data/models/fuel_preferences.dart';
import 'package:driven/site_locator/data/services/site_locations_service.dart';
import 'package:driven/site_locator/use_cases/access_token/get_access_token_for_sites_use_case.dart';
import 'package:get/get.dart';

class GetFuelPreferencesUseCase extends BaseFutureUseCase<
    List<FuelPreferences>?, GetFuelPreferencesParams> {
  final SiteLocationsService siteLocationsService;
  final GetAccessTokenForSitesUseCase getAccessTokenForSitesUseCase =
      Get.put(GetAccessTokenForSitesUseCase());

  GetFuelPreferencesUseCase({required this.siteLocationsService});

  @override
  Future<List<FuelPreferences>> execute(GetFuelPreferencesParams param) async {
    if (AppUtils.isCardHolderLogin &&
        param.isUserAuthenticated &&
        param.fuelPreferencesList.isEmpty) {
      final WalletController walletController = Get.find();
      if (walletController.wallet().hasCards()) {
        if (walletController.wallet().cards().length > 3) {
          return [];
        }
        return _getFuelPreferencesFromAPI(walletController);
      }
    }
    return [];
  }

  Future<List<FuelPreferences>> _getFuelPreferencesFromAPI(
      WalletController walletController) async {
    final accessToken = await getAccessTokenForSitesUseCase.execute();
    final fuelPreferences = await siteLocationsService.getFuelPreferences(
      _getJsonRequestData(walletController),
      headerQueryParams: accessToken,
    );
    return fuelPreferences ?? [];
  }

  Map<String, dynamic> _getJsonRequestData(WalletController walletController) {
    final walletCardCustomerIds =
        walletController.wallet().cards.map((p) => p.customerId).toList();
    final sysAccountId =
        '${walletController.wallet().activeCard.accountCode}_0000_3';
    return {
      'fleetIds': walletCardCustomerIds,
      'sysAccountId': sysAccountId,
    };
  }
}

class GetFuelPreferencesParams {
  final bool isUserAuthenticated;
  final List<FuelPreferences> fuelPreferencesList;

  GetFuelPreferencesParams(
    this.fuelPreferencesList, {
    this.isUserAuthenticated = false,
  });
}
