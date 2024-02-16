import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class FuelGaugeProps {
  // static const String scaleBgPath =
  //     'assets/site_locator/fuel_gauge_scale_bg.png';
  static const String scaleBgPath =
      'packages/driven_site_locator/assets/site_locator/fuel_gauge_scale_bg.png';
  static const String findingFuelLocationMessage = 'Finding Fueling Locations';
  static const String retrievingFuelPricesUnAuthMessage =
      'Retrieving Fuel Prices';
  static const String retrievingFuelPricesAuthMessage =
      'Retrieving Fuel Prices & Discounts';

  static const double parentWidth = 290;
  static const double parentHeight = 150;
  static const double needleDegree = 162.46;
  static const double segmentsRadius = 10;
  static const double gaugeRadius = 126.61;
  static const double pointerSize = 30;
  static const double maxValue = 100;

  static const double thickness = 35;
  static const double spacing = 8;
  static const bool hasProgressBar = false;
  static const bool hasPointer = true;
  static int stepUpPeriodicTimer = 2200;
  static int toHideAfter = 750;
  static double initialValue = 5;

  // Fuel Gauge Colors properties
  static Color modalBgColor = DrivenColors.black.withOpacity(0.4);
  static const Color textShadowColor = DrivenColors.black;
  static const Color pointerColor = DrivenColors.red;
  static const Color progressBarColorDefault = Colors.transparent;
  static const Color backgroundColor = Colors.transparent;

  static BoxDecoration get dialScaleBg => _getDialScaleBg();
  static GaugePointer get needlePointer => _getNeedlePointer();
  static GaugeAxis get gaugeAxis => _getGaugeAxis();
  static TextStyle get loadingInfoStyle => _getLoadingInfoStyle();
  static TextStyle get loadingValueStyle => _getLoadingValueStyle();

  static BoxDecoration _getDialScaleBg() {
    return const BoxDecoration(
      image: DecorationImage(
        image: AssetImage(scaleBgPath),
        fit: BoxFit.cover,
      ),
    );
  }

  static GaugePointer _getNeedlePointer() {
    return const GaugePointer.needle(
      width: pointerSize * 0.4,
      height: pointerSize * 4.5,
      color: pointerColor,
      position: GaugePointerPosition.center(
        offset: Offset(0, pointerSize * 0.3125),
      ),
    );
  }

  static GaugeAxis _getGaugeAxis() {
    return GaugeAxis(
      max: 100,
      degrees: needleDegree,
      pointer: needlePointer,
      progressBar: null,
      style: const GaugeAxisStyle(
        thickness: thickness,
        background: backgroundColor,
        segmentSpacing: spacing,
        blendColors: false,
      ),
    );
  }

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
      fontSize: 30,
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
