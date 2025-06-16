part of map_view_module;

class GenerateMarkersUseCase
    extends BaseUseCase<List<Marker>, GenerateMarkersParams> {
  @override
  List<Marker> execute(GenerateMarkersParams param) => param.markerDetailsList
      .map((item) => markerItem(
            item,
            param.markerDetailsList,
            param.selectedMapPinKey,
            param.onMarkerTap,
            param.clusterManager,
          ))
      .toList();

  Marker markerItem(
    MarkerDetails item,
    List<MarkerDetails> detailsList,
    String selectedKey,
    Function(MarkerDetails item)? onMarkerTap,
    ClusterManager? clusterManager,
  ) =>
      Marker(
        icon: selectedKey == item.site.id ? item.bigIcon : item.smallIcon,
        position: LatLng(item.site.latitude, item.site.longitude),
        markerId: MarkerId(item.site.id.toString()),
        consumeTapEvents: true,
        onTap: () => onMarkerTap?.call(item),
        // clusterManagerId: clusterManager?.clusterManagerId,
        anchor: selectedKey == item.site.id
            ? PinAnchor.defaultPoint
            : PinAnchor.point(price: item.site.price),
      );
}

class GenerateMarkersParams {
  final List<MarkerDetails> markerDetailsList;
  final String selectedMapPinKey;
  final Function(MarkerDetails item)? onMarkerTap;
  final ClusterManager? clusterManager;

  GenerateMarkersParams({
    required this.markerDetailsList,
    required this.selectedMapPinKey,
    this.onMarkerTap,
    this.clusterManager,
  });
}
