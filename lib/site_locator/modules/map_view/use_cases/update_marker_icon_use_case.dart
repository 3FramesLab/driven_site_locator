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
