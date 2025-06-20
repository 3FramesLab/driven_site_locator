import 'package:driven_site_locator/new_site_locator/models/cardholder_account_details_response.dart';
import 'package:driven_site_locator/new_site_locator/models/dc_okta_authn_response.dart';
import 'package:driven_site_locator/new_site_locator/new_site_locator_module.dart';
import 'package:get/get.dart';

class SLSessionManager {
  static final SLSessionManager _singleton = SLSessionManager._internal();

  factory SLSessionManager() => _singleton;

  SLSessionManager._internal();

  DcOktaAuthnResponse? loginResponse;

  Rx<Cards> selectedCard = Cards.nullObject().obs;

  GetCardTypeForMerchSitesResponse? selectedCardType;

  bool isUserAuthenticated = false;
  String fcmToken = 'NA';
  String uuid = '';
  String jwtAccessToken = '';
  String latitude = '';
  String longitude = '';
  String siteLocation = '';
  String selectedCardToken = '';
  String selectedCardAccountCode = '';
  String selectedCardSysAccountId = '';
  String selectedCardNickname = '';
  String selectedCardTypeValue = '';
  String selectedCardLastFourDigits = '';
  bool isNetworkVerified = true;
  bool isCardRelationCreated = false;
  bool isCardholder = false;
  bool isAdminDashBoardLoaded = false;
  bool isMFAEnroll = false;
  RxString selectedFleetName = ''.obs;
  RxString selectedFleetId = ''.obs;
  RxString pwaAccessTokenForChangedCustomer = ''.obs; // PWA Token
  RxString rxFirstName = ''.obs;
  RxString rxLastName = ''.obs;
  RxString codeWordPassCode = ''.obs;

  String get userId => loginResponse?.user?.id ?? 'null';

  String get mddbUserId => loginResponse?.user?.mddbUserId ?? '';

  String get userName => loginResponse?.user?.profile?.login ?? ''; // Email

  String get role => loginResponse?.user?.role ?? '';

  int get roleId => loginResponse?.user?.roleId ?? 840; // Default role is Guest

  String get refreshToken => loginResponse?.refreshToken ?? '';

  String get defaultFleetId => loginResponse?.defaultProperties?.fleetId ?? '';

  String get defaultFleetName =>
      loginResponse?.defaultProperties?.fleetName ?? '';

  String get defaultSysAccountId =>
      loginResponse?.defaultProperties?.accountNumber ?? 'null';
}
