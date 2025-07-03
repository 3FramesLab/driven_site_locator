part of map_view_module;

class DCUnauthSLMapViewPage extends StatefulWidget {
  const DCUnauthSLMapViewPage({Key? key}) : super(key: key);

  @override
  State<DCUnauthSLMapViewPage> createState() => DCUnauthSLMapViewPageState();
}

class DCUnauthSLMapViewPageState extends State<DCUnauthSLMapViewPage>
    with WidgetsBindingObserver {
  final SLSearchPlacesController searchPlacesController = Get.find();
  final siteInfoScrollController = ScrollController();
  final listViewPanelScrollController = ScrollController();

  final SLSiteLocatorController siteLocatorController = Get.find();
  final AuthSLTypeChoicesController authSLTypeChoicesController = Get.find();
  bool isFirstTime = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        if (!isFirstTime) {
          siteLocatorController.onMapViewResume();
        }
        isFirstTime = false;
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    siteLocatorController.googleMapController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void initState() {
    MapUtilities.onLocationSettingsEnableCounter();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      siteLocatorController.isListViewOpenedFull(false);
      await authSLTypeChoicesController.updateAuthFilterList();
      DcSiteLocatorUtils.setPreFilters();
      siteLocatorController.isFullMapViewFirstLaunch = true;
      siteLocatorController.isUnauthSLChannel(true);
      siteLocatorController.markers.clear();
      await siteLocatorController.showSLHelpSheet();

      await siteLocatorController.updateCurrentMapZoomLevel(
          mapController: siteLocatorController.googleMapController);

      siteLocatorController.isFullMapViewFirstLaunch = false;

      await siteLocatorController.checkLocationPermission();
    });

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    siteLocatorController.isUnauthSLChannel(true);
    siteLocatorController.platform = Theme.of(context).platform;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: _bodyContainer(context),
      ),
    );
  }

  Widget _bodyContainer(BuildContext context) {
    return Obx(() => PopScope(
          canPop: siteLocatorController.backFromWelcomeToMapView(),
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              ..._buildMapView(),
            ],
          ),
        ));
  }

  List<Widget> _buildMapView() {
    final isHideListPanel = siteLocatorController.isSiteInfoDialogOpened();
    return [
      SlidingUpPanel(
        controller: siteLocatorController.listViewPanelController,
        panelBuilder: _listViewBuilder,
        minHeight: isHideListPanel ? 0 : 120,
        maxHeight: MediaQuery.of(context).size.height,
        scrollController: listViewPanelScrollController,
        onPanelSlide: (position) {
          if (position < SLInternalText.listViewPanelSlidePosition) {
            siteLocatorController.isListViewOpenedFull(false);
          }
          if (position > SLInternalText.listViewPanelSlidePosition) {
            siteLocatorController.isListViewOpenedFull(true);
          }
        },
        body: _unauthSiteLocatorBody(context),
      ),
    ];
  }

  Widget _unauthSiteLocatorBody(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SLHeaderSection(),
            Expanded(
              child: Stack(
                children: [
                  _siteLocatorMapUI(),
                  _filtersAndLoader,
                  // SearchThisAreaButtonWithLoader(),
                  _mapActionButtons,
                  _helpAndMenuButton,
                ],
              ),
            ),
            Container(height: 120, color: Colors.white)
          ],
        ),
      ],
    );
  }

  Widget get _filtersAndLoader => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Column(
          children: [
            AuthSLTypeChoices(),
            SlMapLoader(),
          ],
        ),
      );

  Widget get _mapActionButtons => MapActionButtons(
        onGpsIconTap: siteLocatorController.onRecenterButtonTap,
      );

  Widget get _helpAndMenuButton => const HelpAndMenuButton();

  Widget _siteLocatorMapUI() => SiteLocatorMapUI(
        onCameraMove: siteLocatorController.onCameraMove,
        onCameraIdle: siteLocatorController.onCameraIdle,
      );

  Widget _listViewBuilder() {
    final keyVal = siteLocatorController.mapKeyValue() + 99;
    final resultKey = int.parse('${keyVal}009');
    return SLListPanelView(
      key: ValueKey<int>(resultKey),
      scrollController: listViewPanelScrollController,
    );
  }
}
