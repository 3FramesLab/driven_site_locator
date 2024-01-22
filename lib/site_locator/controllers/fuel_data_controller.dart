import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/configuration/site_locator_fuels.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_storage_keys.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/use_cases/fuel_data/get_fuel_data_use_case.dart';
import 'package:driven_site_locator/site_locator/use_cases/fuel_data/get_preferred_fuel_type_use_case.dart';
import 'package:get/get.dart';

class FuelDataController extends GetxController {
  GetPreferredFuelTypeUseCase getPreferredFuelTypeUseCase =
      Get.put(GetPreferredFuelTypeUseCase());
  GetFuelDataUseCase getFuelDataUseCase = Get.put(GetFuelDataUseCase());

  List<String> get savedFilterList =>
      PreferenceUtils.getStringList(
        SiteLocatorStorageKeys.selectedSiteFilters,
      ) ??
      [];

  String getPreferredFuelType(
    String defaultFuel,
  ) =>
      getPreferredFuelTypeUseCase.execute(
        PreferredFuelTypeParams(
          savedFiltersList: savedFilterList,
          defaultFuelType: defaultFuel,
        ),
      );

  FuelData getPreferredFuelData(
    SiteLocation siteLocation,
    String preferredFuelType,
  ) =>
      getFuelDataUseCase.execute(
        FuelDataParams(
          preferredFuelType: preferredFuelType,
          siteLocation: siteLocation,
        ),
      );
}
