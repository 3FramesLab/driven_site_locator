part of site_locator_map_module;

class SiteLocatorMap extends StatefulWidget {
  final bool hasToShowMarkers;
  final Function(String)? onSitePinTap;
  final double? zoom;
  final int markerSize;
  final bool? customMarker;
  final Function(CameraPosition)? onCameraMove;
  final Function()? onCameraIdle;
  final SLSiteLocatorController siteLocatorController = Get.find();
  final bool isFixedCircleRadiusVisible;
  final bool isMovingCircleRadiusVisible;
  final Color fixedCircleRadiusColor;
  final Color movingCircleRadiusColor;

  SiteLocatorMap({
    Key? key,
    this.onSitePinTap,
    this.hasToShowMarkers = true,
    this.zoom,
    this.markerSize = 100,
    this.isFixedCircleRadiusVisible = false,
    this.isMovingCircleRadiusVisible = false,
    this.fixedCircleRadiusColor = DrivenColors.primary,
    this.movingCircleRadiusColor = DrivenColors.successGreenColor,
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
    return Obx(
      () => GoogleMap(
        padding: const EdgeInsets.all(25),
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
        // clusterManagers: widget.siteLocatorController.clusterManager == null
        //     ? <ClusterManager>{}
        //     : {widget.siteLocatorController.clusterManager!},
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
      ),
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller?.complete(controller);
    widget.siteLocatorController.googleMapController = controller;
    if (widget.siteLocatorController.isFirstLaunch) {
      await widget.siteLocatorController.getInitialPageLoadData(
        mapController: controller,
      );
    }

    await widget.siteLocatorController
        .updateCurrentMapZoomLevel(mapController: controller);
    await _updateCamera(controller);
  }

  Set<Marker> get _getMarkersToDisplay => _clusterPins;

  Set<Marker> get _clusterPins =>
      widget.siteLocatorController.markers().toSet();

  Set<Marker> get markerPins => (widget.hasToShowMarkers
      ? Set.from(widget.siteLocatorController.markers)
      : null)!;

  Future<void> _updateCamera(GoogleMapController controller) async {
    if (widget.siteLocatorController.selectedPlace != null &&
        SLSessionManager().isUserAuthenticated) {
      await widget.siteLocatorController.getLatLngForSelectedPlace(
          widget.siteLocatorController.selectedPlace!);
    } else if (widget.siteLocatorController.markers().isNotEmpty) {
      await widget.siteLocatorController.moveCameraPosition(
          widget.siteLocatorController.currentLatLngBounds());
    } else {
      await widget.siteLocatorController.initMapData();
    }
  }

  CameraPosition getInitialCameraPosition() => CameraPosition(
        target: widget.siteLocatorController.currentLocation(),
        zoom: UmaSLProperties.mapZoomLevel,
      );

  Set<Circle> getCirclesSet() {
    final siteLocatorController = widget.siteLocatorController;
    final computedRadius = siteLocatorController
        .getCircleRadius(siteLocatorController.cameraPositionZoom());
    const ratioSizer = 0.75;
    final haloCircleRadius = computedRadius * ratioSizer;
    final localeCircleRadius = computedRadius * ratioSizer * 0.2;
    const tealDark = DrivenColors.primary;

    return {
      Circle(
        zIndex: 1,
        circleId: const CircleId('haloCircle'),
        center: widget.siteLocatorController.currentLocation(),
        radius: haloCircleRadius,
        fillColor: tealDark.withOpacity(0.3),
        strokeColor: tealDark.withOpacity(0.5),
        strokeWidth: 0,
      ),
      Circle(
        zIndex: 9,
        circleId: const CircleId('currentLocaleCircle'),
        center: widget.siteLocatorController.currentLocation(),
        radius: localeCircleRadius,
        fillColor: tealDark,
        strokeColor: Colors.white,
        strokeWidth: 3,
      ),
      if (widget.isMovingCircleRadiusVisible &&
          siteLocatorController.centerLatLng() != null)
        Circle(
          zIndex: 5,
          circleId: const CircleId('movingRadiusCircleBoundary'),
          center: siteLocatorController.centerLatLng()!,
          radius: 1609.34 * UmaSLProperties.mapRadiusCircle,
          strokeColor: widget.movingCircleRadiusColor,
          strokeWidth: 2,
        ),
      if (widget.isFixedCircleRadiusVisible &&
          _displayFixedRadiusCircleBoundary)
        Circle(
          zIndex: 4,
          circleId: const CircleId('fixedRadiusCircleBoundary'),
          center: siteLocatorController.fixedCenterLatLng()!,
          radius: 1609.34 * UmaSLProperties.mapRadiusCircle,
          strokeColor: widget.fixedCircleRadiusColor,
          strokeWidth: 2,
        ),
    };
  }

  bool get _displayFixedRadiusCircleBoundary =>
      widget.siteLocatorController.fixedCenterLatLng() != null &&
      widget.siteLocatorController.markers().isNotEmpty;
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
