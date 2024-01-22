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
          ))
      .toList();

  Marker markerItem(
    MarkerDetails item,
    List<MarkerDetails> detailsList,
    String selectedKey,
    Function(MarkerDetails item)? onMarkerTap,
  ) =>
      Marker(
        icon: selectedKey == item.site.id ? item.bigIcon : item.smallIcon,
        position: LatLng(item.site.latitude, item.site.longitude),
        markerId: MarkerId(item.site.id.toString()),
        consumeTapEvents: true,
        onTap: () => onMarkerTap?.call(item),
        anchor: selectedKey == item.site.id
            ? const Offset(0.5, 1)
            : (item.site.price?.isNotEmpty ?? false)
                ? const Offset(0.8, 1)
                : const Offset(0.5, 1),
      );
}

class GenerateMarkersParams {
  final List<MarkerDetails> markerDetailsList;
  final String selectedMapPinKey;
  final Function(MarkerDetails item)? onMarkerTap;

  GenerateMarkersParams({
    required this.markerDetailsList,
    required this.selectedMapPinKey,
    this.onMarkerTap,
  });
}
