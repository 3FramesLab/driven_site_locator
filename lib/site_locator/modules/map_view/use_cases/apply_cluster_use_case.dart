part of map_view_module;

class ApplyClusterUseCase extends BaseFutureUseCase<void, ApplyClusterParams> {
  @override
  Future<void>? execute(ApplyClusterParams param) async {
    final markerCluster = param.markerCluster;
    final currentLatLngBounds = param.currentLatLngBounds;
    final siteLocationDisplayData = param.siteLocationDisplayData;
    final markers = param.markers;
    final siteLocationHashmap = param.siteLocationHashmap;

    final List<Marker> clusterMarkers = [];

    /// Use this constants value, when [currentLatLngBounds] is not in use.
    // final List<MapMarker> clusters =
    //     markerCluster.clusters([-180, -85, 180, 85], param.currentZoom);

    final List<MapMarker> clusters = markerCluster.clusters(
      [
        currentLatLngBounds.southwest.longitude,
        currentLatLngBounds.southwest.latitude,
        currentLatLngBounds.northeast.longitude,
        currentLatLngBounds.northeast.latitude,
      ],
      param.currentZoom,
    );
    siteLocationDisplayData.clear();
    for (final cluster in clusters) {
      if (cluster.isCluster ?? false) {
        final clusterMarker = await param.getSiteCluster(cluster);
        clusterMarkers.add(clusterMarker);

        final points = markerCluster.points(int.parse(cluster.id));
        for (final point in points) {
          addSiteLocation(
            siteLocationDisplayData: siteLocationDisplayData,
            id: point.id,
            siteLocationHashmap: siteLocationHashmap,
          );
        }
      } else {
        final individualMarker = param.getSiteMarker(cluster);
        clusterMarkers.add(individualMarker);
        addSiteLocation(
          siteLocationDisplayData: siteLocationDisplayData,
          id: cluster.id,
          siteLocationHashmap: siteLocationHashmap,
        );
      }
    }
    markers.clear();
    markers.addAll(clusterMarkers);
  }

  void addSiteLocation({
    required List<SiteLocation> siteLocationDisplayData,
    required String id,
    required Map<String, SiteLocation> siteLocationHashmap,
  }) {
    final siteLocation = siteLocationHashmap[id];
    if (siteLocation != null) {
      siteLocationDisplayData.add(siteLocation);
    }
  }
}

class ApplyClusterParams {
  final MarkerCluster<MapMarker> markerCluster;
  final LatLngBounds currentLatLngBounds;
  final int currentZoom;
  final List<SiteLocation> siteLocationDisplayData;
  final RxList<Marker> markers;
  final Future<Marker> Function(MapMarker cluster) getSiteCluster;
  final Marker Function(MapMarker marker) getSiteMarker;
  final Map<String, SiteLocation> siteLocationHashmap;

  const ApplyClusterParams({
    required this.markerCluster,
    required this.currentLatLngBounds,
    required this.currentZoom,
    required this.siteLocationDisplayData,
    required this.markers,
    required this.getSiteCluster,
    required this.getSiteMarker,
    required this.siteLocationHashmap,
  });
}
