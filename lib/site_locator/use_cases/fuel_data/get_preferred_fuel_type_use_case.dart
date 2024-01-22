import 'package:driven_site_locator/data/use_cases/base_usecase.dart';
import 'package:driven_site_locator/site_locator/constants/site_filter_keys_constants.dart';

class GetPreferredFuelTypeUseCase
    extends BaseUseCase<String, PreferredFuelTypeParams> {
  @override
  String execute(PreferredFuelTypeParams param) {
    String preferredFuelType = param.defaultFuelType;
    if (param.savedFiltersList != null && param.savedFiltersList!.isNotEmpty) {
      if (param.savedFiltersList!
          .contains(FuelTypeFilterKeys.unleadedRegular)) {
        preferredFuelType = FuelTypeFilterKeys.unleadedRegular;
      } else if (param.savedFiltersList!.contains(FuelTypeFilterKeys.diesel)) {
        preferredFuelType = FuelTypeFilterKeys.diesel;
      }
    }
    return preferredFuelType;
  }
}

class PreferredFuelTypeParams {
  final List<String>? savedFiltersList;
  final String defaultFuelType;

  PreferredFuelTypeParams({
    required this.defaultFuelType,
    this.savedFiltersList,
  });
}
