import 'package:driven_site_locator/data/use_cases/base_usecase.dart';
import 'package:driven_site_locator/site_locator/constants/location_circle_constants.dart';

class ComputeCircleRadiusUseCase extends BaseUseCase<double, double> {
  ComputeCircleRadiusUseCase();

  @override
  double execute(double param) {
    final zoomvalue = param;
    double radius = LocationCircleConstants.radiusBenchMark;
    if (zoomvalue >= LocationCircleConstants.zoomGuideRail) {
      final radiusConfig =
          LocationCircleConstants.radiusRangeList.firstWhere((element) {
        return zoomvalue > (element['min'] ?? 0) &&
            zoomvalue <= (element['max'] ?? 0);
      });
      radius =
          radiusConfig['radius'] ?? LocationCircleConstants.radiusBenchMark;
    }
    return radius;
  }
}
