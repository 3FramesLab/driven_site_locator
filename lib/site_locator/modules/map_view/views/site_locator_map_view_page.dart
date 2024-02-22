// ignore_for_file: prefer_mixin
part of map_view_module;

class SiteLocatorMapViewPage extends StatefulWidget {
  const SiteLocatorMapViewPage({Key? key}) : super(key: key);

  @override
  State<SiteLocatorMapViewPage> createState() => _SiteLocatorMapViewPageState();
}

class _SiteLocatorMapViewPageState extends State<SiteLocatorMapViewPage>
    with WidgetsBindingObserver {
  final FuelGaugeProgressController fuelGaugeProgressController = Get.find();
  final SiteLocatorController siteLocatorController = Get.find();
  final SearchPlacesController searchPlacesController = Get.find();
  final SetUpWizardController setUpWizardController = Get.find();
  final FuelPriceDisclaimerController fuelPriceDisclaimerController =
      Get.find();
  static final _entitlementRepository = SiteLocatorEntitlementUtils.instance;

  @override
  void initState() {
    MapUtilities.onLocationSettingsEnableCounter();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!setUpWizardController.canShowSetUpWizard() &&
          fuelPriceDisclaimerController.isFuelPriceDisclaimerVisible()) {
        await _showFuelPriceDisclaimerDialog();
      }
      if ((siteLocatorController.siteLocations?.isEmpty ?? false) &&
          !siteLocatorController.isShowLoading()) {
        siteLocatorController.showNoLocationsErrorDialog(
            SiteLocatorConstants.noLocationsErrorText);
      }
      if (!siteLocatorController.canShowFloatingMapButtons()) {
        siteLocatorController.setFloatingButtonsVisibility(
            buttonsVisibility: true);
      }
      await siteLocatorController.updateCurrentMapZoomLevel();

      siteLocatorController.show2CTAButton(show2CTA: true);

      await Future.delayed(const Duration(milliseconds: 500), () async {
        await siteLocatorController.updateFullMapViewSitesData();
      });
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        siteLocatorController.onMapViewResume();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return _bodyContainer(context);
    } else {
      return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
          ),
          child: _bodyContainer(context),
        ),
      );
    }
  }

  Widget _bodyContainer(BuildContext context) {
    return Obx(
      () => Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          ..._buildSiteLocatorViewBody(),
          _buildMenuBody(),
        ],
      ),
    );
  }

  List<Widget> _buildSiteLocatorViewBody() {
    if (kIsWeb) {
      return _buildMapView();
    } else {
      return setUpWizardController.canShowSetUpWizard()
          ? _buildSetUpWizardView()
          : _buildMapView();
    }
  }

  List<Widget> _buildSetUpWizardView() {
    return [SetUpWizardSlidingPanel(body: _body(context))];
  }

  List<Widget> _buildMapView() {
    return [
      if (GetPlatform.isWeb)
        _body(context)
      else
        SiteInfoSlidingPanel(body: _body(context)),
      gpsIconButton(),
      filterListButtons(),
    ];
  }

  Widget gpsIconButton() => GpsIconButton(
        onGpsIconTap: _onRecenterButtonTap,
      );

  Future<void> _onRecenterButtonTap() async {
    trackAction(
      AnalyticsTrackActionName.recenterButtonClickedEvent,
    );
    siteLocatorController.canClearSearchTextField = true;
    siteLocatorController.clearSearchPlaceInput();
    await siteLocatorController.onReCenterButtonClicked();
  }

  Future<void> _showFuelPriceDisclaimerDialog() => Get.dialog(
        FuelPriceDisclaimerDialog(),
        barrierDismissible: false,
      );

  Widget _siteLocatorMapView() => SiteLocatorMapUI(
        siteLocatorController: siteLocatorController,
        onCameraMove: siteLocatorController.onCameraMove,
        onCameraIdle: siteLocatorController.onCameraIdle,
      );

  Widget _backButtonWidget() => siteLocatorController.isShowBackButton
      ? SiteLocatorMapViewBackButton(
          onBackButtonPressed: onMapViewBackButtonPressed,
        )
      : const SizedBox(height: DrivenDimensions.dp4);

  Future<void> onMapViewBackButtonPressed() async {
    siteLocatorController.backFromWelcomeToMapView(true);
    if (!siteLocatorController.isShowLoading()) {
      unawaited(_onRecenterButtonTap());
      siteLocatorController.resetMarkers(PinVariantStore.statusList);
      await siteLocatorController
          .moveCameraPosition(siteLocatorController.reCenterLatLngBounds);
      siteLocatorController.modifyCircleSize();
      siteLocatorController.show2CTAButton(show2CTA: true);

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.back();
    }
  }

  Widget _loadingIndicator() {
    if (!siteLocatorController.isShowLoading()) {
      siteLocatorController.resetFuelGaugeLoadingProgressValue();
    } else {
      siteLocatorController.toggleFuelGaugeIndicatorVisibility(visible: true);
    }
    return Container(
      margin: EdgeInsets.zero,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 100),
        switchInCurve: Curves.fastLinearToSlowEaseIn,
        switchOutCurve: Curves.fastLinearToSlowEaseIn,
        child: siteLocatorController.getHastoShowFuelGaugeIndicator()
            ? Center(
                child: FuelGuageProgressIndicator(),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Stack(
      children: [
        _siteLocatorMapView(),
        _headerColumn(topPadding),
        applyForFuelman(),
        _loadingIndicator(),
      ],
    );
  }

  Widget _headerColumn(double topPadding) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: isShowWalletHeader ? 5 : topPadding),
          if (!setUpWizardController.canShowSetUpWizard()) _backButtonWidget(),
          _comdataWalletHeader(),
          const SizedBox(height: 5),
          menuWithSearchBarContainer(),
          const SizedBox(height: 2),
          quickFiltersContainer(),
        ],
      );

  Widget _comdataWalletHeader() => isShowWalletHeader
      // ? WalletHeader(isFromSiteLocator: true)
      ? walletHeader
      : const SizedBox();

  Widget get walletHeader =>
      DrivenSiteLocator.instance.walletHeader ?? const SizedBox();

  bool get isShowWalletHeader {
    if (AppUtils.isComdata &&
        Globals().isCardHolderLogin &&
        siteLocatorController.isUserAuthenticated &&
        !setUpWizardController.canShowSetUpWizard()) {
      return DrivenSiteLocator.instance.hasCards();
    }
    return false;
  }

  Widget searchTextfieldContainer() => Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
        child: SearchPlaceTextField(
          currentLocation: _getCurrentLocationAsString(),
        ),
      );

  String _getCurrentLocationAsString() => SiteLocatorUtils().getCSVFromList([
        siteLocatorController.currentLocation().latitude,
        siteLocatorController.currentLocation().longitude
      ]);

  Widget quickFiltersContainer() => Container(
        height: SiteLocatorConstants.quickFiltersContainerHeight,
        width: Get.width,
        child: QuickFiltersList(),
      );

  Widget filterListButtons() {
    return !kIsWeb
        ? Obx(
            () => Positioned(
              left: DrivenDimensions.dp16,
              bottom: siteLocatorController.floatingButtonsBottomPosition(),
              child: FloatingMapButtonsContainer(),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget menuWithSearchBarContainer() => !kIsWeb
      ? Row(
          children: [
            Visibility(
              visible: _entitlementRepository.isDisplaySettingsEnabled,
              child: SiteLocatorMenuIcon(),
            ),
            SizedBox(
              width: _entitlementRepository.isDisplaySettingsEnabled
                  ? SiteLocatorDimensions.dp3
                  : SiteLocatorDimensions.dp10,
            ),
            Flexible(child: searchTextfieldContainer()),
          ],
        )
      : const SizedBox(height: 20);

  Widget _buildMenuBody() => SiteLocatorMenuPanel(
        body: const SizedBox(
          height: SiteLocatorDimensions.dp100,
        ),
      );

  Widget applyForFuelman() {
    return Positioned(
      right: 32,
      top: 28,
      child: SizedBox(
        width: 207,
        child: RoundedButtonWithChild(
          onPressed: () => SiteLocatorUtils.launchURL(
            SiteLocatorConstants.applyForFuelmanUrl,
            SiteLocatorConstants.openApplyForFuelmanError,
          ),
          backgroundColor: SiteLocatorColors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                SiteLocatorConstants.applyForFuelman,
                style: f16RegularWhite,
              ),
              const SizedBox(width: 20),
              Image.asset(
                SiteLocatorAssets.fuelmanBrandFilePath,
                height: SiteLocatorDimensions.dp24,
                width: SiteLocatorDimensions.dp24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
