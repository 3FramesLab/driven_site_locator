part of map_view_module;

class GetMapZoomLevelUseCase
    extends BaseUseCase<double, GetMapZoomLevelParams> {
  @override
  double execute(GetMapZoomLevelParams param) => getMapZoomLevel(param);

  double getMapZoomLevel(GetMapZoomLevelParams param) {
    double referenceZoomLevel = 11;
    const double zoomAdjusted = 10.123;
    const double scaleFactor = 500;
    const int logFactor = 16;
    final radius = param.mapRadius;
    if (radius > 0) {
      final radiusElevated = radius + radius / 2;
      final scale = radiusElevated / scaleFactor;
      final calcZoom = logFactor - log(scale) / log(2);
      referenceZoomLevel = calcZoom - zoomAdjusted;
    }
    final resultZoomLevel = double.parse(referenceZoomLevel.toStringAsFixed(4));
    return resultZoomLevel;
  }
}

class GetMapZoomLevelParams {
  double mapRadius;
  GetMapZoomLevelParams(this.mapRadius);
}
