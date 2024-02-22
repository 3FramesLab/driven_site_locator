import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';

class SitesLoadingProgressProps {
  static const String fuelPumpIconPath =
      '${SiteLocatorAssets.assetPath}/fuel_pump_icon.png';
  static const String findingFuelLocationMessage = 'Finding Fueling Locations';
  static const String retrievingFuelPricesUnAuthMessage =
      'Retrieving Fuel Prices';
  static const String retrievingFuelPricesAuthMessage =
      'Retrieving Fuel Prices & Discounts';

  static const String fuelPumpIconText = 'Fuel pump icon';

  static const double parentWidth = 290;
  static const double parentHeight = 150;
  static const double maxValue = 100;
  static const double safeMaxValue = 97;

  static int stepUpPeriodicTimer = 2200;
  static int toHideAfter = 750;
  static double initialValue = 5;

  // Loading Progress Colors properties
  static Color modalBgColor = DrivenColors.black.withOpacity(0.4);
  static const Color textShadowColor = DrivenColors.black;
  static const Color backgroundColor = Colors.transparent;

  static TextStyle get loadingInfoStyle => _getLoadingInfoStyle();
  static TextStyle get loadingValueStyle => _getLoadingValueStyle();

  static TextStyle _getLoadingInfoStyle() {
    return const TextStyle(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.w600,
      shadows: [
        Shadow(
          blurRadius: 10,
          offset: Offset(0, 2),
        ),
      ],
    );
  }

  static TextStyle _getLoadingValueStyle() {
    return const TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      shadows: [
        Shadow(
          blurRadius: 10,
          offset: Offset(0, 2),
        ),
      ],
    );
  }
}
