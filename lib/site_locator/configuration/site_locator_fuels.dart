import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/site_locator/constants/site_filter_keys_constants.dart';
import 'package:driven_site_locator/site_locator/controllers/fuel_data_controller.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';

class FuelData {
  final String type;
  final double price;
  final String displayPrice;

  FuelData({
    required this.type,
    required this.price,
    required this.displayPrice,
  });
  factory FuelData.blank() => FuelData(type: '', price: 0, displayPrice: '');
}

class SiteLocatorFuels {
  static FuelData getData(SiteLocation siteLocation) {
    final preferredFuelType = AppUtils.isComdata
        ? getPreferredFuelType(FuelTypeFilterKeys.diesel)
        : getPreferredFuelType(FuelTypeFilterKeys.unleadedRegular);
    return getPreferredFuelData(preferredFuelType, siteLocation);
  }

  static String getPreferredFuelType(String defaultFuelType) =>
      FuelDataController().getPreferredFuelType(defaultFuelType);

  static FuelData getPreferredFuelData(
    String preferredFuelType,
    SiteLocation siteLocation,
  ) =>
      FuelDataController().getPreferredFuelData(
        siteLocation,
        preferredFuelType,
      );
}
