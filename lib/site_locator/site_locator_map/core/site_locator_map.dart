import 'dart:async';

import 'package:driven_common/styles/styles_module.dart';
import 'package:driven_site_locator/site_locator/configuration/site_locator_config.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/site_locator_map/core/custom_pin_markers/pin_variant_store.dart';
import 'package:driven_site_locator/site_locator/site_locator_map/models/site.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SiteLocatorMap extends StatefulWidget {
  final List<Site> siteList;
  final bool hasToShowMarkers;
  final Function(String)? onSitePinTap;
  final double? zoom;
  final int markerSize;
  final bool? customMarker;
  final Function(CameraPosition)? onCameraMove;
  final Function()? onCameraIdle;
  final SiteLocatorController siteLocatorController;
  const SiteLocatorMap({
    required this.siteList,
    required this.siteLocatorController,
    Key? key,
    this.onSitePinTap,
    this.hasToShowMarkers = true,
    this.zoom,
    this.markerSize = 100,
    this.customMarker,
    this.onCameraMove,
    this.onCameraIdle,
  }) : super(key: key);

  @override
  SiteLocatorMapState createState() => SiteLocatorMapState();
}

class SiteLocatorMapState extends State<SiteLocatorMap> {
  Completer<GoogleMapController>? _controller;
  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _controller = Completer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GoogleMap(
        gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
            EagerGestureRecognizer.new,
          ),
        },
        zoomControlsEnabled: false,
        buildingsEnabled: false,
        myLocationButtonEnabled: false,
        circles: getCirclesSet(),
        markers: _getMarkersToDisplay,
        initialCameraPosition: getInitialCameraPosition(),
        onMapCreated: _onMapCreated,
        onCameraMove: widget.onCameraMove,
        onCameraIdle: widget.onCameraIdle,
        onTap: (point) {
          FocusScope.of(context).requestFocus(FocusNode());
          final FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild?.unfocus();
          }
          widget.siteLocatorController.resetMarkers(PinVariantStore.statusList);
        },
      );
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    widget.siteLocatorController.googleMapController = controller;
    _controller?.complete(controller);
    await widget.siteLocatorController.updateCurrentMapZoomLevel();
    _updateCamera(controller);
  }

  Set<Marker> get _getMarkersToDisplay => _clusterPins;

  Set<Marker> get _clusterPins =>
      widget.siteLocatorController.markers().toSet();

  Set<Marker> get markerPins => (widget.hasToShowMarkers
      ? Set.from(widget.siteLocatorController.markers)
      : null)!;

  void _updateCamera(GoogleMapController controller) {
    if (widget.siteLocatorController.markers().isNotEmpty) {
      widget.siteLocatorController.moveCameraPosition(
          widget.siteLocatorController.currentLatLngBounds());
    }
  }

  CameraPosition getInitialCameraPosition() => CameraPosition(
        target: widget.siteLocatorController.currentLocation(),
        zoom: SiteLocatorConfig.mapZoomLevel,
      );

  Set<Circle> getCirclesSet() {
    final siteLocatorController = widget.siteLocatorController;
    final computedRadius = siteLocatorController
        .getCircleRadius(siteLocatorController.cameraPositionZoom());
    const ratioSizer = 0.75;
    final haloCircleRadius = computedRadius * ratioSizer;
    final localeCircleRadius = computedRadius * ratioSizer * 0.2;
    return {
      Circle(
        zIndex: 1,
        circleId: const CircleId('haloCircle'),
        center: widget.siteLocatorController.currentLocation(),
        radius: haloCircleRadius,
        fillColor: Colors.purple.shade100.withOpacity(0.5),
        strokeColor: DrivenColors.brandPurple.withOpacity(0.5),
        strokeWidth: 1,
      ),
      Circle(
        zIndex: 9,
        circleId: const CircleId('currentLocaleCircle'),
        center: widget.siteLocatorController.currentLocation(),
        radius: localeCircleRadius,
        fillColor: DrivenColors.brandPurple,
        strokeColor: Colors.white,
        strokeWidth: 2,
      ),
    };
  }
}

class MarkerDetails {
  final String keyIdentifier;
  final Site site;
  final BitmapDescriptor bigIcon;
  final BitmapDescriptor smallIcon;

  MarkerDetails({
    required this.keyIdentifier,
    required this.site,
    required this.bigIcon,
    required this.smallIcon,
  });
}
