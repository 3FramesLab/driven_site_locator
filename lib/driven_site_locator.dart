// ignore_for_file: use_setters_to_change_properties, avoid_positional_boolean_parameters

import 'package:driven_site_locator/constants/app_strings.dart';
import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/data/model/entitlement_repository.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/driven_site_locator_platform_interface.dart';
import 'package:driven_site_locator/site_locator/configuration/site_locator_config.dart';

class DrivenSiteLocator {
  AppFlavor flavor = AppFlavor.none;
  String appVersionNumber = '';
  Future<Widget> Function()? logoutDialog;
  void Function()? navigateToLogin;
  bool? isInactivityWrapperActivated;
  void Function()? onInactivityTimeOut;
  double? bottomNavBarHeight;
  void Function(bool)? onTimerLogout;
  Future<void> Function(String value)? setLocatorMapAsPreferredHomeScreen;
  void Function()? navigateToCardholderSiteLocatorMap;
  Future<void> Function()? navigateToAdminLocatorTab;
  Map<String, String?> env = {};

  String? _fleetManagerAccessToken;
  String _appLoginUserType = '';
  bool _isWelcomeScreen = false;
  bool _isCardholderFullMapScreen = false;
  // bool _isPreviousScreenLogin = false;

  // Wallet module's data members
  bool _hasCards = false;
  List<String> _walletCardCustomerIds = [];
  String _accountCode = '';
  String _customerId = '';
  Widget? walletHeader;

  DrivenSiteLocator._internal();
  static final DrivenSiteLocator _instance = DrivenSiteLocator._internal();
  static DrivenSiteLocator get instance => _instance;

  Future<String?> getPlatformVersion() {
    return DrivenSiteLocatorPlatform.instance.getPlatformVersion();
  }

  Future<void> initSiteLocatorEntitlement({
    required SiteLocatorEntitlementRepository siteLocatorEntitlementRepository,
    Map<String, dynamic>? configDataJson,
    AppFlavor flavor = AppFlavor.none,
  }) async {
    await PreferenceUtils.init();
    setAppFlavor(flavor);
    SiteLocatorEntitlementUtils.instance.siteLocatorEntitlementRepository =
        siteLocatorEntitlementRepository;
    await SiteLocatorConfig.init(
      configDataJson: configDataJson,
    );
  }

  Future<void> init({
    // required SiteLocatorEntitlementRepository siteLocatorEntitlementRepository,
    required bool isInactivityWrapperActivated,
    AppFlavor flavor = AppFlavor.none,
    // Map<String, dynamic>? configDataJson,
    String appVersionNumber = '',
    Future<Widget> Function()? logoutDialog,
    void Function()? navigateToLogin,
    void Function(bool)? onTimerLogout,
    double? bottomNavBarHeight,
    Future<void> Function(String value)? setLocatorMapAsPreferredHomeScreen,
    void Function()? navigateToCardholderSiteLocatorMap,
    Future<void> Function()? navigateToAdminLocatorTab,
    Widget? walletHeader,
  }) async {
    setAppFlavor(flavor);
    setAppVersionNumber(appVersionNumber);
    setLogoutDialog(logoutDialog);
    setIsInactivityWrapperActivated(isInactivityWrapperActivated);
    setBottomNavBarHeight(bottomNavBarHeight);
    setOnTimerLogout(onTimerLogout);
    setNavigateToCardholderSiteLocatorMap(navigateToCardholderSiteLocatorMap);
    setNavigateToAdminLocatorTab(navigateToAdminLocatorTab);
    setNavigateToLogin(navigateToLogin);
    this.setLocatorMapAsPreferredHomeScreen =
        setLocatorMapAsPreferredHomeScreen;
    this.walletHeader = walletHeader;

    // entitlementRepository.siteLocatorEntitlementRepository =
    //     siteLocatorEntitlementRepository;

    // SiteLocatorEntitlementUtils.instance.siteLocatorEntitlementRepository =
    //     siteLocatorEntitlementRepository;
    // SiteFilters.init();
    // await SiteLocatorConfig.init(configDataJson: configDataJson);
  }

  void setLogoutDialog(Future<Widget> Function()? logoutDialog) {
    this.logoutDialog = logoutDialog;
  }

  void setNavigateToLogin(void Function()? navigateToLogin) {
    this.navigateToLogin = navigateToLogin;
  }

  void setAppVersionNumber(String appVersionNumber) {
    this.appVersionNumber = appVersionNumber;
  }

  void setIsInactivityWrapperActivated(bool isInactivityWrapperActivated) {
    this.isInactivityWrapperActivated = isInactivityWrapperActivated;
  }

  void setOnInactivityTimeOut(Function()? onInactivityTimeOut) {
    this.onInactivityTimeOut = onInactivityTimeOut;
  }

  void setBottomNavBarHeight(double? bottomNavBarHeight) {
    this.bottomNavBarHeight = bottomNavBarHeight;
  }

  void setOnTimerLogout(Function(bool)? onTimerLogout) {
    this.onTimerLogout = onTimerLogout;
  }

  void setNavigateToCardholderSiteLocatorMap(
    void Function()? navigateToCardholderSiteLocatorMap,
  ) {
    this.navigateToCardholderSiteLocatorMap =
        navigateToCardholderSiteLocatorMap;
  }

  void setNavigateToAdminLocatorTab(
      Future<void> Function()? navigateToAdminLocatorTab) {
    this.navigateToAdminLocatorTab = navigateToAdminLocatorTab;
  }

  double getBottomNavBarHeight() =>
      bottomNavBarHeight ?? AppStrings.bottomNavBarHeight;

  bool getIsInactivityWrapperActivated() =>
      isInactivityWrapperActivated ?? false;

  void setAppFlavor(AppFlavor flavor) {
    this.flavor = flavor;
  }

  void setFleetManagerAccessToken(String? fleetManagerAccessToken) {
    _fleetManagerAccessToken = fleetManagerAccessToken;
  }

  String getFleetManagerAccessToken() => _fleetManagerAccessToken ?? '';

  void setAppLoginUserType(String appLoginUserType) {
    _appLoginUserType = appLoginUserType;
  }

  String getAppLoginUserType() => _appLoginUserType;

  //TODO: Set this value in super app
  void setIsWelcomeScreen(bool isWelcomeScreen) {
    _isWelcomeScreen = isWelcomeScreen;
  }

  bool getIsWelcomeScreen() => _isWelcomeScreen;

  //TODO: Set this value in super app
  void setIsCardholderFullMapScreen(bool isCardholderFullMapScreen) {
    _isCardholderFullMapScreen = isCardholderFullMapScreen;
  }

  bool getIsCardholderFullMapScreen() => _isCardholderFullMapScreen;

  // /// TODO: call this method with value 'Get.previousRoute == Routes.login'
  // /// prior to siteLocatorController.initAuthenticatedMapView();
  // void setIsPreviousScreenLogin(bool isPreviousScreenLogin) {
  //   _isPreviousScreenLogin = isPreviousScreenLogin;
  // }

  // bool getIsPreviousScreenLogin() => _isPreviousScreenLogin;

  void setWalletData({
    required bool hasCards,
    required List<String> walletCardCustomerIds,
    required String accountCode,
    required String customerId,
  }) {
    _hasCards = hasCards;
    _walletCardCustomerIds = walletCardCustomerIds;
    _accountCode = accountCode;
    _customerId = customerId;
  }

  bool hasCards() => _hasCards;

  List<String> get walletCardCustomerIds => _walletCardCustomerIds;

  String get accountCode => _accountCode;

  String get customerId => _customerId;

  void setEnv(Map<String, String?> env) => this.env = env;
}
