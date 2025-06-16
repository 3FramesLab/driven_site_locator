part of map_view_module;

class SiteMapMarker with ClusterItem {
  final Site? site;
  final Marker marker;
  final LatLng latLng;

  SiteMapMarker({
    required this.latLng,
    required this.marker,
    this.site,
  });

  @override
  LatLng get location => latLng;
}
