part of map_view_module;

class UpdateMarkerIconUseCase
    extends BaseUseCase<void, UpdateMarkerIconParams> {
  @override
  void execute(UpdateMarkerIconParams param) {
    if (param.markersList.isNotEmpty) {
      final Marker? selectedMarker = param.markersList.firstWhereOrNull(
          (p) => p.markerId.value == param.markerDetails.site.id);
      if (selectedMarker != null) {
        final selectedMarkerIndex = param.markersList.indexOf(selectedMarker);
        param.markersList[selectedMarkerIndex] = selectedMarker.copyWith(
          iconParam: param.isShowBigIcon
              ? param.markerDetails.bigIcon
              : param.markerDetails.smallIcon,
          anchorParam: param.isShowBigIcon
              ? PinAnchor.defaultPoint
              : PinAnchor.point(price: param.markerDetails.site.price),
          zIndexParam: param.isShowBigIcon ? 1 : null,
        );
      }
    }
  }
}

class UpdateMarkerIconParams {
  RxList<Marker> markersList;
  MarkerDetails markerDetails;
  bool isShowBigIcon;

  UpdateMarkerIconParams({
    required this.markersList,
    required this.markerDetails,
    this.isShowBigIcon = false,
  });
}
