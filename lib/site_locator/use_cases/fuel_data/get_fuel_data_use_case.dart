import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/data/use_cases/base_usecase.dart';
import 'package:driven_site_locator/site_locator/configuration/site_locator_fuels.dart';
import 'package:driven_site_locator/site_locator/constants/site_filter_keys_constants.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';

class GetFuelDataUseCase extends BaseUseCase<FuelData, FuelDataParams> {
  @override
  FuelData execute(FuelDataParams param) {
    switch (param.preferredFuelType) {
      case FuelTypeFilterKeys.unleadedRegular:
        return fuelDisplayData(
          FuelTypeLabel.unleaded,
          param.siteLocation.unleadedRegularPrice,
        );
      case FuelTypeFilterKeys.diesel:
        return fuelDisplayData(
          FuelTypeLabel.diesel,
          param.siteLocation.dieselPrice,
        );
      case FuelTypeFilterKeys.unleadedPremium:
        return fuelDisplayData(
          FuelTypeLabel.unleaded,
          param.siteLocation.unleadedRegularPrice,
        );
      case FuelTypeFilterKeys.unleadedPlus:
        return fuelDisplayData(
          FuelTypeLabel.unleaded,
          param.siteLocation.unleadedRegularPrice,
        );
      default:
        return fuelDisplayData(
          FuelTypeLabel.unleaded,
          param.siteLocation.unleadedRegularPrice,
        );
    }
  }

  FuelData fuelDisplayData(
    String type,
    double? fuelPrice,
  ) {
    final price = _getAccuratePrice(fuelPrice ?? 0);
    final displayPrice = _getAccurateDisplayPrice(fuelPrice ?? 0);
    return fuelPrice == null || fuelPrice == 0
        ? FuelData.blank()
        : FuelData(
            type: type,
            price: price,
            displayPrice: displayPrice,
          );
  }

  static double _getAccuratePrice(double fuelPrice) =>
      AppUtils.getPrice(fuelPrice);

  static String _getAccurateDisplayPrice(double fuelPrice) {
    final displayPrice = AppUtils.getPriceString(fuelPrice);
    return displayPrice == '0.00' ? '' : '\$$displayPrice';
  }
}

class FuelDataParams {
  final String preferredFuelType;
  final SiteLocation siteLocation;

  FuelDataParams({
    required this.preferredFuelType,
    required this.siteLocation,
  });
}
