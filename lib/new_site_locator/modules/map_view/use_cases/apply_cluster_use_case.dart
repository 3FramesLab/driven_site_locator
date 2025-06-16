part of map_view_module;

// class ApplyClusterUseCase
//     extends BaseFutureUseCase<List<Marker>, ApplyClusterParams> {
//   @override
//   Future<List<Marker>> execute(ApplyClusterParams param) async {
//     final lowestFuelPrice = param.lowestFuelPrice;
//     final markerCluster = param.markerCluster;
//     final List<Marker> clusterMarkers = [];

//     /// Use this constants value, when [currentLatLngBounds] is not in use.
//     final List<SiteMapMarker> clusters =
//         markerCluster.clusters([-180, -85, 180, 85], param.currentZoom);

//     for (final cluster in clusters) {
//       double? bestPriceInCluster;
//       if (cluster.isCluster ?? false) {
//         bool hasLowestFuelPriceMarker = false;
//         try {
//           final subMarkers = markerCluster.points(int.parse(cluster.id));

//           if (subMarkers.isNotEmpty) {
//             if (lowestFuelPrice != null && lowestFuelPrice > 0) {
//               hasLowestFuelPriceMarker = _validateClusterHasLowestFuelPrice(
//                 lowestFuelPrice,
//                 subMarkers,
//               );
//             }
//             if (!hasLowestFuelPriceMarker) {
//               bestPriceInCluster = calculateBestPriceInCluster(subMarkers);
//             }
//           }
//         } catch (_) {}

//         final clusterMarker = await param.getSiteCluster(
//           cluster,
//           hasLowestFuelPriceMarker: hasLowestFuelPriceMarker,
//           bestPriceInCluster: bestPriceInCluster,
//         );
//         clusterMarkers.add(clusterMarker);
//       } else {
//         final individualMarker = param.getSiteMarker(cluster);
//         clusterMarkers.add(individualMarker);
//       }
//     }
//     return clusterMarkers;
//   }

//   bool _validateClusterHasLowestFuelPrice(
//     double lowestFuelPrice,
//     List<SiteMapMarker> mapMarkers,
//   ) {
//     for (final marker in mapMarkers) {
//       if (marker.site?.price != null && marker.site!.price! >= 0) {
//         final price = marker.site!.price!;
//         if (price == lowestFuelPrice) {
//           return true;
//         }
//       }
//     }

//     return false;
//   }

//   double? calculateBestPriceInCluster(List<SiteMapMarker> mapMarkers) {
//     double? bestPrice;
//     for (final marker in mapMarkers) {
//       final price = marker.site?.price;
//       if (price != null && price >= 0) {
//         if (bestPrice == null || price < bestPrice) {
//           bestPrice = price;
//         }
//       }
//     }
//     return bestPrice;
//   }
// }

// class ApplyClusterParams {
//   final MarkerCluster<SiteMapMarker> markerCluster;
//   final int currentZoom;
//   final Future<Marker> Function(
//     SiteMapMarker cluster, {
//     bool hasLowestFuelPriceMarker,
//     double? bestPriceInCluster,
//   }) getSiteCluster;
//   final Marker Function(SiteMapMarker marker) getSiteMarker;
//   final double? lowestFuelPrice;

//   const ApplyClusterParams({
//     required this.markerCluster,
//     required this.currentZoom,
//     required this.getSiteCluster,
//     required this.getSiteMarker,
//     this.lowestFuelPrice,
//   });
// }
