import 'package:driven_common/globals.dart';
import 'package:driven_site_locator/data/use_cases/base_future_usecase.dart';
import 'package:driven_site_locator/driven_site_locator.dart';
import 'package:driven_site_locator/site_locator/data/models/fuel_preferences.dart';
import 'package:driven_site_locator/site_locator/data/services/site_locations_service.dart';
import 'package:driven_site_locator/site_locator/use_cases/access_token/get_access_token_for_sites_use_case.dart';
import 'package:get/get.dart';

class GetFuelPreferencesUseCase extends BaseFutureUseCase<
    List<FuelPreferences>?, GetFuelPreferencesParams> {
  final SiteLocationsService siteLocationsService;
  final GetAccessTokenForSitesUseCase getAccessTokenForSitesUseCase =
      Get.put(GetAccessTokenForSitesUseCase());

  GetFuelPreferencesUseCase({required this.siteLocationsService});

  @override
  Future<List<FuelPreferences>> execute(GetFuelPreferencesParams param) async {
    if (Globals().isCardHolderLogin &&
        param.isUserAuthenticated &&
        param.fuelPreferencesList.isEmpty) {
      if (DrivenSiteLocator.instance.hasCards()) {
        return _getFuelPreferencesFromAPI();
      }
    }
    return [];
  }

  Future<List<FuelPreferences>> _getFuelPreferencesFromAPI() async {
    final accessToken = await getAccessTokenForSitesUseCase.execute();
    final fuelPreferences = await siteLocationsService.getFuelPreferences(
      _getJsonRequestData(),
      headerQueryParams: accessToken,
    );
    return fuelPreferences ?? [];
  }

  Map<String, dynamic> _getJsonRequestData() {
    final sysAccountId = '${DrivenSiteLocator.instance.accountCode}_0000_3';
    return {
      'fleetIds': DrivenSiteLocator.instance.walletCardCustomerIds,
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
