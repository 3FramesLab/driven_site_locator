part of map_view_module;

class GetSiteLocationsInVisibleMapRegionUseCase extends BaseFutureUseCase<
    List<SiteLocation>, GetSiteLocationsInVisibleMapRegionParam> {
  @override
  Future<List<SiteLocation>> execute(
      GetSiteLocationsInVisibleMapRegionParam param) async {
    final visibleMapRegion = param.visibleMapRegion;
    final siteLocations = param.siteLocations;

    final siteLocationInRegion = <SiteLocation>[];

    siteLocationInRegion.addAll(
      siteLocations
          .where(
            (site) => visibleMapRegion.contains(
              LatLng(site.siteLatitude ?? 0, site.siteLongitude ?? 0),
            ),
          )
          .toList(),
    );

    return siteLocationInRegion;
  }
}

class GetSiteLocationsInVisibleMapRegionParam {
  List<SiteLocation> siteLocations;
  LatLngBounds visibleMapRegion;

  GetSiteLocationsInVisibleMapRegionParam({
    required this.siteLocations,
    required this.visibleMapRegion,
  });
}
