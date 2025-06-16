// ignore_for_file: prefer_const_constructors_in_immutables

part of map_view_module;

class WelcomeMapView extends StatefulWidget {
  final AnalyticsScreenName? analyticsScreenName;

  WelcomeMapView({this.analyticsScreenName});

  @override
  State<WelcomeMapView> createState() => _WelcomeMapViewState();
}

class _WelcomeMapViewState extends State<WelcomeMapView> {
  final SiteLocatorController siteLocatorController = Get.find();
  final CardholderSignUpPanelController signUpPanelController = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 200),
          () async => _handleWelcomeMapViewData());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _resetMcQuickFilter();
    return InkWell(
      onTap: AppUtils.isDrivenConnect
          ? _welcomeMapTileClickEventHandler
          : _buildOnMapViewTap,
      child: AbsorbPointer(
        child: SizedBox(
          height: Get.height * 0.4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                _welcomeMapView(),
                _loadingIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _resetMcQuickFilter() {
    if (AppUtils.isComdata &&
        DrivenSessionManager().isUserAuthenticated &&
        AppUtils.isCardHolderLogin &&
        Get.find<WalletController>().walletService.updateWelcomeMapView) {
      siteLocatorController.resetMcFiltersOnCardChange();
      Get.find<WalletController>().walletService.updateWelcomeMapView = false;
    }
  }

  Future<void> _buildOnMapViewTap() async {
    _trackMapViewClickAction();
    if (siteLocatorController.isShowLoading()) {
      return;
    }
    await setDefaultLandingScreen();

    if (signUpPanelController.checkToShowCardholderPanel()) {
      await signUpPanelController.handleSignUpPanel();
    } else {
      await siteLocatorController.onMapViewTap();
    }
  }

  Future<void> setDefaultLandingScreen() async {
    if (!DrivenSessionManager().isUserAuthenticated) {
      await LocalStorageAdapter.setDefaultLandingScreen(
          SLInternalText.unAuthenticatedSiteLocator);
    }
  }

  Future<void> _welcomeMapTileClickEventHandler() async {
    _trackMapViewClickAction();
    if (siteLocatorController.isShowLoading()) {
      return;
    }
    await setDefaultLandingScreen();
    await Get.toNamed(Routes.unauthSiteLocator);
  }

  void _trackMapViewClickAction() {
    if (widget.analyticsScreenName != null) {
      trackAction(
        AnalyticsTrackActionName.mapClick,
        adobeCustomTag: AdobeTagProperties.welcome,
      );
    }
  }

  Widget _welcomeMapView() => WelcomeSiteLocatorMapUI();

  Widget _loadingIndicator() => Obx(() {
        return siteLocatorController.isShowLoading()
            ? const Center(
                child: CupertinoActivityIndicator(radius: 20),
              )
            : const SizedBox();
      });

  Future<void> _handleWelcomeMapViewData() async {
    if (isAuthenticatedView) {
      await _handleAuthenticatedWelcomeMapViewData();
    } else {
      await _handleUnAuthenticatedWelcomeMapViewData();
    }
    siteLocatorController.resetMarkerForWelcomeMapView = false;
  }

  bool get isAuthenticatedView =>
      siteLocatorController.isAuthenticatedWelcomeScreen;

  Future<void> _handleAuthenticatedWelcomeMapViewData() async {
    //when search text present
    if (siteLocatorController.selectedPlace != null &&
        DrivenSessionManager().isUserAuthenticated) {
      Future.delayed(
        const Duration(milliseconds: 50),
        () => siteLocatorController.welcomeGoogleMapController?.moveCamera(
          CameraUpdate.newLatLngBounds(
            siteLocatorController.searchedPlaceLatLngBounds(),
            siteLocatorController.mapPadding,
          ),
        ),
      );
    } else {
      siteLocatorController.isShowLoading(true);
      await siteLocatorController.initAuthenticatedMapView(
        mapController: siteLocatorController.welcomeGoogleMapController,
      );
      await siteLocatorController.getSiteLocationsData();
      siteLocatorController.isShowLoading(false);
    }
  }

  Future<void> _handleUnAuthenticatedWelcomeMapViewData() async {
    if (siteLocatorController.isFirstLaunch) {
      await siteLocatorController.getInitialPageLoadData(
        mapController: siteLocatorController.welcomeGoogleMapController,
      );
    } else {
      await siteLocatorController.onReCenterButtonClicked(
        mapController: siteLocatorController.welcomeGoogleMapController,
      );
    }
  }
}
