import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/data/use_cases/base_usecase.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';

class GetMapZoomLevelUseCase
    extends BaseUseCase<double, GetMapZoomLevelParams> {
  @override
  double execute(GetMapZoomLevelParams param) => getMapZoomLevel(param);

  double getMapZoomLevel(GetMapZoomLevelParams param) {
    double mapZoomLevel = AppUtils.isComdata ? 9.0 : 12.6;
    if (param.mapRadius.isBetween(1, 3)) {
      mapZoomLevel = 12.6;
    } else if (param.mapRadius.isBetween(3, 6.5)) {
      mapZoomLevel = 11.0;
    } else if (param.mapRadius.isBetween(7, 11.5)) {
      mapZoomLevel = 10.5;
    } else if (param.mapRadius.isBetween(12, 16.5)) {
      mapZoomLevel = 10.0;
    } else if (param.mapRadius.isBetween(17, 26.5)) {
      mapZoomLevel = 9.5;
    } else if (param.mapRadius.isBetween(27, 31.5)) {
      mapZoomLevel = 9.0;
    } else if (param.mapRadius.isBetween(32, 51.5)) {
      mapZoomLevel = 8.0;
    } else if (param.mapRadius.isBetween(52, 76.5)) {
      mapZoomLevel = 7.0;
    } else if (param.mapRadius.isBetween(77, 101.5)) {
      mapZoomLevel = 6.8;
    }
    return mapZoomLevel;
  }
}

class GetMapZoomLevelParams {
  double mapRadius;
  GetMapZoomLevelParams(this.mapRadius);
}
