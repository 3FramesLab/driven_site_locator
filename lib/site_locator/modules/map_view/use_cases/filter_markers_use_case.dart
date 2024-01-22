part of map_view_module;

class FilterMarkersUseCase
    extends BaseFutureUseCase<List<Marker>, FilterMarkersParams> {
  @override
  Future<List<Marker>> execute(FilterMarkersParams param) async {
    final List<Marker> filteredMarkersList = [];
    if (param.filteredSiteLocationsList.isNotEmpty &&
        param.rawMarkersList.isNotEmpty) {
      for (final SiteLocation item in param.filteredSiteLocationsList) {
        filteredMarkersList.add(
          param.rawMarkersList.firstWhere(
            (element) => element.markerId.value == item.masterIdentifier,
          ),
        );
      }
    }
    return filteredMarkersList;
  }
}

class FilterMarkersParams {
  final List<Marker> rawMarkersList;
  final List<SiteLocation> filteredSiteLocationsList;

  FilterMarkersParams({
    required this.rawMarkersList,
    required this.filteredSiteLocationsList,
  });
}
