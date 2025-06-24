import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:driven_site_locator/constants/api_constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum APIType {
  token,
  siteLocatorAccessToken,
  merchSiteLocations,
  siteLocationsDistanceMatrix,
  siteLocationsPlacesAutoComplete,
  siteLocationsGeoCoding,
  sitesBrandLogoUrls,
  oktaAuthn,
  oktaAuthorize,
  oktaToken,
  oktaGetUserDetails,
  oktaGetUserGroup,
  oktaChangePassword,
  oktaSearchUser,
  oktaResetPassword,
  oktaRevokeAccessToken,
  oktaRevokeRefreshToken,
  oktaCreateUser,
  oktaMfaSendOtp,
  oktaMfaCreateFactor,
  oktaMfaCreateSMSFactor,
  oktaMfaActivateSMSFactor,
  oktaMfaVerifySMSOtp,
  oktaMfaSendEmailCode,
  oktaMfaVerifyEmailCode,
  updateExpiredPassword,
  oktaMfaResendSMSCode,
  resetMFAUserFactor,
  enrollSmsFactorWithoutToken,
  getFactor,
  activateSmsFactorWithoutToken,
  clearPendingStatusPrevious,
  oktaMfaAuthnSkip,
  getFuelPrices,
  getFuelPreferences,
  oktaMfaResetPasswordSMSFactor,
  oktaMfaResetPasswordCodeVerify,
  oktaResetNewPassword,
  addCardInfoForUnauthLocator,
  iframeAccessToken,
  jwtAccessToken,
  // DrivenConnect
  createProfile,
  updateProfile,
  updatePasscode,
  getExpressCheckSettings,
  updateExpressCheckSettings,
  authenticate,
  biometricLogin,
  verifyOtp,
  sendOtp,
  mfaVerifyOtp,
  mfaSendOtp,
  enrollSmsFactor,
  activateSmsFactor,
  resetFactor,
  adminAccountDetails,
  adminAccountSummary,
  changePassword,
  getCustomerIdList,
  changeCustomer,
  setDefaultProperties,
  getFundDetails,
  getDynamicMenu,
  getProductDynamicMenu,
  getProductSsoLink,
  setCardholderOnboardStatus,
  cancelCardholderRequest,
  // Places
  placesSearch,
  placeRating,

  // Amazon
  oneClickStatus,
  addCardRelation,
  deleteCardRelation,
  relationStatus,
  unlockCard,

  deleteUserProfile,

  //cardholder
  getCardholderAccountDetails,
  unlockCardholderCard,
  getTransactionHistory,
  changeNickname,
  peerToPeerReview,
  sendMoney,
  setAsFavorite,
  resetPin,
  removeCard,
  dcForgotPassword,
  forgotPasswordSendOtp,
  forgotPasswordVerifyOtp,
  dcCreateNewPassword,
  getCardType,
  addPropCard,
  generatePin,
  setToPrimary,
  cardholderOnboardStatus,
  addOnroadCard,
  addCard,
  shareFeedback,
  getCards,
  validateInvitationCode,
  getBankAccount,
  addNewBankAccount,
  validateBankAccount,
  getExpressCheckBalance,
  registerComCheckDraft,
  moveExpressCheckBalanceToCard,
  bankTransfer,
  getAlertSetting,
  updateAlertSetting,
  cardToCardTransfer,
  cipCheckV2,
  getCipStatus,

  // Below for test coverage
  get,
  noPath,
  post,
  put,
  patch,
  delete,
}

class APIRoute implements APIRouteConfigurable {
  final APIType type;
  final String? routeParams;
  final String? headerQueryParams;
  bool headerQueryParameters;
  final String? directUrl;
  final Map<String, dynamic>? headerQueryParamsMap;

  static String loginUrl(String endpoint) {
    return '/login/$endpoint';
  }

  static String locationsUrl(String endpoint) {
    // return '/locations/$endpoint';
    return '/$endpoint';
  }

  static String cardUrl(String endpoint) {
    return '/card/$endpoint';
  }

  static String amazonUrl(String endpoint) {
    return '/amazon/$endpoint';
  }

  final headers = {
    'accept': 'application/json',
    'content-type': 'application/json',
  };

  final apiKeySecurityHeaders = {
    'X-Android-Package': ApiConstants.packageId,
    'X-Android-Cert': ApiConstants.androidSignature,
    'x-ios-bundle-identifier': ApiConstants.packageId,
  };

  final placesSearchHeaders = {
    'Content-Type': 'application/json',
    'X-Goog-FieldMask': 'places.id',
    'X-Goog-Api-Key': dotenv.env['GOOGLE_PLACES_API_KEY']!,
  };

  final placeDetailsHeaders = {
    'Content-Type': 'application/json',
    'X-Goog-FieldMask': 'rating',
    'X-Goog-Api-Key': dotenv.env['GOOGLE_PLACES_API_KEY']!,
  };

  final cardHeader = {
    'device_id': 'abc123',
    'version_number': '0.0.1',
    'application_name': 'DrivenConnect',
    'sys_account_id': 'null',
    'user_id': '00ubu7oha4nciraGQ1d7',
  };

  APIRoute(
    this.type, {
    this.routeParams,
    this.headerQueryParams,
    this.headerQueryParameters = false,
    this.directUrl,
    this.headerQueryParamsMap,
  });

  /// Return config of api (method, url, header)
  @override
  // ignore: long-method
  RequestOptions? getConfig() {
    switch (type) {
      case APIType.token:
        return token();
      case APIType.siteLocatorAccessToken:
        return siteLocatorAccessToken();
      case APIType.merchSiteLocations:
        return merchSiteLocations();
      case APIType.siteLocationsDistanceMatrix:
        return siteLocationsDistanceMatrix(directUrl);
      case APIType.siteLocationsPlacesAutoComplete:
        return siteLocationsPlacesAutoComplete(directUrl);
      case APIType.siteLocationsGeoCoding:
        return siteLocationsGeoCoding(directUrl);
      case APIType.placesSearch:
        return placesSearch(directUrl);
      case APIType.placeRating:
        return placeRating(directUrl);
      case APIType.sitesBrandLogoUrls:
        return sitesBrandLogoUrls();
      case APIType.oktaAuthn:
        return oktaAuthn();
      case APIType.createProfile:
        return createProfile();
      case APIType.updateProfile:
        return updateProfile();
      case APIType.updatePasscode:
        return updatePasscode();
      case APIType.getExpressCheckSettings:
        return getExpressCheckSettings();
      case APIType.updateExpressCheckSettings:
        return updateExpressCheckSettings();
      case APIType.authenticate:
        return authenticate();
      case APIType.biometricLogin:
        return biometricLogin();
      case APIType.adminAccountDetails:
        return adminAccountDetails();
      case APIType.adminAccountSummary:
        return adminAccountSummary();
      case APIType.changePassword:
        return changePassword();
      case APIType.getCustomerIdList:
        return getCustomerIdList();
      case APIType.changeCustomer:
        return changeCustomer();
      case APIType.setDefaultProperties:
        return setDefaultProperties();
      case APIType.getFundDetails:
        return getFundDetails();
      case APIType.getDynamicMenu:
        return getDynamicMenu();
      case APIType.getProductDynamicMenu:
        return getProductDynamicMenu();
      case APIType.getProductSsoLink:
        return getProductSsoLink();
      case APIType.setCardholderOnboardStatus:
        return setCardholderOnboardStatus();
      case APIType.cancelCardholderRequest:
        return cancelCardholderRequest();
      case APIType.resetFactor:
        return resetFactor();
      case APIType.verifyOtp:
        return verifyOtp();
      case APIType.sendOtp:
        return sendOtp();
      case APIType.mfaVerifyOtp:
        return mfaVerifyOtp();
      case APIType.mfaSendOtp:
        return mfaSendOtp();
      case APIType.enrollSmsFactor:
        return enrollSmsFactor();
      case APIType.activateSmsFactor:
        return activateSmsFactor();
      case APIType.oktaAuthorize:
        return oktaAuthorize();
      case APIType.oktaToken:
        return oktaToken();
      case APIType.oktaGetUserDetails:
        return oktaGetUserDetails();
      case APIType.oktaGetUserGroup:
        return oktaGetUserGroup();
      case APIType.oktaResetPassword:
        return oktaResetPassword();
      case APIType.oktaSearchUser:
        return oktaSearchUser();
      case APIType.oktaRevokeAccessToken:
        return oktaRevokeToken();
      case APIType.oktaChangePassword:
        return oktaChangePassword();
      case APIType.oktaRevokeRefreshToken:
        return oktaRevokeToken();
      case APIType.oktaCreateUser:
        return oktaCreateUser();
      case APIType.oktaMfaSendOtp:
        return oktaMfaSendOtp();
      case APIType.oktaMfaCreateFactor:
        return oktaMfaCreateFactor();
      case APIType.oktaMfaCreateSMSFactor:
        return oktaMfaCreateSMSFactor();
      case APIType.oktaMfaActivateSMSFactor:
        return oktaMfaActivateSMSFactor();
      case APIType.oktaMfaVerifySMSOtp:
        return oktaMfaVerifySMSOtp();
      case APIType.oktaMfaSendEmailCode:
        return oktaMfaSendEmailCode();
      case APIType.oktaMfaVerifyEmailCode:
        return oktaMfaVerifyEmailCode();
      case APIType.updateExpiredPassword:
        return updateExpiredPassword();
      case APIType.oktaMfaResendSMSCode:
        return oktaMfaResendSMSCode();
      case APIType.resetMFAUserFactor:
        return resetMfaUserFactor();
      case APIType.enrollSmsFactorWithoutToken:
        return enrollSmsFactorWithoutToken();
      case APIType.getFactor:
        return getFactor();
      case APIType.activateSmsFactorWithoutToken:
        return activateSmsFactorWithoutToken();
      case APIType.clearPendingStatusPrevious:
        return clearPendingStatusPrevious();
      case APIType.oktaMfaAuthnSkip:
        return oktaMfaAuthnSkip();
      case APIType.getFuelPrices:
        return getFuelPrices();
      case APIType.getFuelPreferences:
        return getFuelPreferences();
      case APIType.oktaMfaResetPasswordSMSFactor:
        return oktaMfaResetPasswordSMSFactor();
      case APIType.oktaMfaResetPasswordCodeVerify:
        return oktaMfaResetPasswordCodeVerify();
      case APIType.oktaResetNewPassword:
        return oktaResetNewPassword();
      case APIType.addCardInfoForUnauthLocator:
        return addCardInfoForUnauthLocator();

      case APIType.iframeAccessToken:
        return iframeAccessToken();

      case APIType.jwtAccessToken:
        return jwtAccessToken();

      // cardholder
      case APIType.getCardholderAccountDetails:
        return getCardholderAccountDetails();
      case APIType.getCards:
        return getCards();
      case APIType.validateInvitationCode:
        return validateInvitationCode();
      case APIType.unlockCardholderCard:
        return unlockCardholderCard();
      case APIType.getTransactionHistory:
        return getTransactionHistory();
      case APIType.changeNickname:
        return changeNickname();
      case APIType.peerToPeerReview:
        return peerToPeerReview();
      case APIType.sendMoney:
        return sendMoney();
      case APIType.setAsFavorite:
        return setAsFavorite();
      case APIType.resetPin:
        return resetPin();
      case APIType.removeCard:
        return removeCard();
      case APIType.getBankAccount:
        return getBankAccount();
      case APIType.addNewBankAccount:
        return addNewBankAccount();
      case APIType.validateBankAccount:
        return validateBankAccount();
      case APIType.bankTransfer:
        return bankTransfer();
      case APIType.getCardType:
        return getCardType();
      case APIType.addPropCard:
        return addPropCard();
      case APIType.addOnroadCard:
        return addOnroadCard();
      case APIType.addCard:
        return addCard();
      case APIType.shareFeedback:
        return shareFeedback();
      case APIType.generatePin:
        return generatePin();
      case APIType.setToPrimary:
        return setToPrimary();
      case APIType.cardholderOnboardStatus:
        return cardholderOnboardStatus();
      case APIType.getExpressCheckBalance:
        return getExpressCheckBalance();
      case APIType.registerComCheckDraft:
        return registerComCheckDraft();
      case APIType.getAlertSetting:
        return getAlertSetting();
      case APIType.updateAlertSetting:
        return updateAlertSetting();
      case APIType.moveExpressCheckBalanceToCard:
        return moveExpressCheckBalanceToCard();
      case APIType.cardToCardTransfer:
        return cardToCardTransfer();
      case APIType.cipCheckV2:
        return cipCheckV2();
      case APIType.getCipStatus:
        return getCipStatus();

      // amazon
      case APIType.oneClickStatus:
        return oneClickStatus();
      case APIType.addCardRelation:
        return addCardRelation();
      case APIType.deleteCardRelation:
        return deleteCardRelation();
      case APIType.relationStatus:
        return relationStatus();
      case APIType.unlockCard:
        return unlockCard();
      case APIType.deleteUserProfile:
        return deleteUserProfile();
      case APIType.dcForgotPassword:
        return dcForgotPassword();
      case APIType.forgotPasswordSendOtp:
        return forgotPasswordSendOtp();
      case APIType.forgotPasswordVerifyOtp:
        return forgotPasswordVerifyOtp();
      case APIType.dcCreateNewPassword:
        return dcCreateNewPassword();

      case APIType.get:
        return get();
      case APIType.post:
        return post();
      case APIType.put:
        return put();
      case APIType.patch:
        return patch();
      case APIType.delete:
        return delete();

      default:
        return null;
    }
  }

// =========== Cardholder APIs start ==============

  RequestOptions oktaMfaAuthnSkip() {
    return RequestOptions(
      path: '/api/v2/authn/skip',
      method: APIMethod.post,
    );
  }

  RequestOptions createPassword() {
    return RequestOptions(
      path: '/okta/users/credentials/forgot_password',
      method: APIMethod.post,
    );
  }

  RequestOptions usersVerifyCode() {
    return RequestOptions(
      path: '/users/factors/verify',
      method: APIMethod.post,
    );
  }

  RequestOptions usersSendCode() {
    return RequestOptions(
      path: '/users/factors/send',
      method: APIMethod.post,
    );
  }

  RequestOptions verifyCode() {
    return RequestOptions(
      path: routeParams != null
          ? '/authn/factors/verify?$routeParams'
          : '/authn/factors/verify',
      method: APIMethod.post,
      headers: headerQueryParameters
          ? {'x-device-token': '$headerQueryParams'}
          : {'x-device-token': ''},
    );
  }

  RequestOptions sendCode() {
    return RequestOptions(
      path: '/authn/factors/send',
      method: APIMethod.post,
    );
  }

  RequestOptions securityQuestion() {
    return RequestOptions(
      path: '/okta/users/$routeParams/factors/questions',
      method: APIMethod.get,
    );
  }

  RequestOptions token() {
    return RequestOptions(
      path: '/token',
      method: APIMethod.post,
    );
  }

  RequestOptions resetMFAFactors() {
    return RequestOptions(
      path: '/okta/users/lifecycle/reset_factors',
      method: APIMethod.post,
    );
  }

  RequestOptions user() {
    return RequestOptions(
      path: '/okta/users=$routeParams',
      method: APIMethod.get,
    );
  }

  RequestOptions mfaLogs() {
    return RequestOptions(
      path: '/okta/mfalogs/$routeParams',
      method: APIMethod.get,
    );
  }

  RequestOptions factors() {
    return RequestOptions(
      path: '/okta/users/$routeParams/factors',
      method: APIMethod.get,
    );
  }

  RequestOptions loginAuth() {
    return RequestOptions(
      path: '/okta/authenticate',
      method: APIMethod.post,
      headers: headerQueryParams != null
          ? {'x-device-token': '$headerQueryParams'}
          : {'x-device-token': ''},
    );
  }

  RequestOptions sendCodeForMFASetup() {
    return RequestOptions(
      path: '/users/factors',
      method: APIMethod.post,
    );
  }

  RequestOptions activateMFASetup() {
    return RequestOptions(
      path: '/users/factors/lifecycle/activate',
      method: APIMethod.post,
    );
  }

  RequestOptions createNewPassword() {
    return RequestOptions(
      path: '/okta/users/credentials/change_password',
      method: APIMethod.post,
      headers: headerQueryParams != null
          ? {'sysaccountid': '$headerQueryParams'}
          : {'sysaccountid': ''},
    );
  }

  RequestOptions setupSecurityQuestion() {
    return RequestOptions(
      path: '/users/user/security_question',
      method: APIMethod.put,
    );
  }

  RequestOptions acceptTermsOfService() {
    return RequestOptions(
      path: '/ua/insert',
      method: APIMethod.post,
      headers: headerQueryParamsMap ?? {'Authorization': ''},
    );
  }

  RequestOptions checkTermsOfServiceStatus() {
    return RequestOptions(
      path: '/ua/retrieve',
      method: APIMethod.post,
      headers: headerQueryParamsMap ?? {'Authorization': ''},
    );
  }

  RequestOptions getRewardsUrl() {
    return RequestOptions(
      path: '/saml/sso',
      method: APIMethod.post,
    );
  }

  RequestOptions oktaAuthn() {
    return RequestOptions(
      path: '/api/v2/authn',
      method: APIMethod.post,
    );
  }

  RequestOptions oktaAuthorize() {
    return RequestOptions(
      path: '/api/v2/authorize',
      method: APIMethod.get,
    );
  }

  RequestOptions oktaToken() {
    return RequestOptions(
        path: '/api/v2/token',
        method: APIMethod.post,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'});
  }

  RequestOptions oktaGetUserDetails() {
    return RequestOptions(
      path: '/api/v2/idp-user/users/$routeParams',
      method: APIMethod.get,
    );
  }

  RequestOptions oktaGetUserGroup() {
    return RequestOptions(
      path: '/api/v2/idp-user/users/$routeParams/groups',
      method: APIMethod.get,
    );
  }

  RequestOptions oktaSearchUser() {
    return RequestOptions(
      path: '/api/v2/idp-user/users?search=$routeParams',
      method: APIMethod.get,
    );
  }

  RequestOptions oktaResetPassword() {
    return RequestOptions(
      path: '/api/v2/idp-user/users/$routeParams/reset-password?sendEmail=true',
      method: APIMethod.post,
    );
  }

  RequestOptions oktaRevokeToken() {
    return RequestOptions(
        path: '/api/v2/revoke-token',
        method: APIMethod.post,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'});
  }

  RequestOptions oktaCreateUser() {
    return RequestOptions(
      path: '/api/v2/idp-user/user?$routeParams',
      method: APIMethod.post,
    );
  }

  RequestOptions oktaChangePassword() {
    final userId = routeParams?.split('/')[0];
    final authToken = routeParams?.split('/')[1];
    return RequestOptions(
        path: '/api/v2/idp-user/users/$userId/change-password',
        method: APIMethod.post,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-jwt': '$authToken'
        });
  }

  RequestOptions oktaMfaSendOtp() {
    return RequestOptions(
      path: '/api/v2/authn/factors/$routeParams/verify',
      method: APIMethod.post,
    );
  }

  RequestOptions oktaMfaCreateFactor() {
    return RequestOptions(
      path: '/api/v2/idp-user/users/$routeParams/factors',
      method: APIMethod.post,
    );
  }

  RequestOptions oktaMfaCreateSMSFactor() {
    return RequestOptions(
      path: '/api/v2/authn/factors',
      method: APIMethod.post,
    );
  }

  RequestOptions oktaMfaActivateSMSFactor() {
    return RequestOptions(
      path: '/api/v2/authn/factors/$routeParams/activate',
      method: APIMethod.post,
    );
  }

  RequestOptions oktaMfaVerifySMSOtp() {
    final factorId = routeParams?.split('/')[0];
    final rememberDevice = routeParams?.split('/')[1];
    return RequestOptions(
      path:
          '/api/v2/authn/factors/$factorId/verify?rememberDevice=$rememberDevice',
      method: APIMethod.post,
    );
  }

  RequestOptions oktaMfaSendEmailCode() {
    final userId = routeParams?.split('/')[0];
    final factorId = routeParams?.split('/')[1];
    return RequestOptions(
      path: '/api/v2/idp-user/users/$userId/factors/$factorId/verify',
      method: APIMethod.post,
    );
  }

  RequestOptions oktaMfaResendSMSCode() {
    return RequestOptions(
      path: '/api/v2/authn/factors/$routeParams/resend',
      method: APIMethod.post,
    );
  }

  RequestOptions oktaMfaVerifyEmailCode() {
    final userId = routeParams?.split('/')[0];
    final factorId = routeParams?.split('/')[1];
    return RequestOptions(
      path: '/api/v2/idp-user/users/$userId/factors/$factorId/verify',
      method: APIMethod.post,
    );
  }

  RequestOptions updateExpiredPassword() {
    return RequestOptions(
      path: '/api/v2/idp-user/user/change-expired-password',
      method: APIMethod.post,
    );
  }

  RequestOptions resetMfaUserFactor() {
    final userId = routeParams?.split('/')[0];
    final factorId = routeParams?.split('/')[1];
    return RequestOptions(
      path:
          '/api/v2/idp-user/users/$userId/factors/$factorId?removeRecoveryEnrollment=false',
      method: APIMethod.delete,
    );
  }

  RequestOptions enrollSmsFactorWithoutToken() {
    return RequestOptions(
      path: '/api/v2/idp-user/users/$routeParams/factors',
      method: APIMethod.post,
    );
  }

  RequestOptions activateSmsFactorWithoutToken() {
    final userId = routeParams?.split('/')[0];
    final factorId = routeParams?.split('/')[1];
    return RequestOptions(
      path: '/api/v2/idp-user/users/$userId/factors/$factorId/activate',
      method: APIMethod.post,
    );
  }

  RequestOptions oktaMfaResetPasswordSMSFactor() {
    return RequestOptions(
      path: '/api/v2/authn/recovery/password',
      method: APIMethod.post,
    );
  }

  RequestOptions oktaMfaResetPasswordCodeVerify() {
    return RequestOptions(
      path: '/api/v2/authn/recovery/verify',
      method: APIMethod.post,
    );
  }

  RequestOptions oktaResetNewPassword() {
    return RequestOptions(
      path: '/api/v2/authn/credentials/resetPassword',
      method: APIMethod.post,
    );
  }

  RequestOptions addCardInfoForUnauthLocator() {
    final username = dotenv.env['BASIC_AUTH_CLIENT_ID'];
    final password = ApiConstants.basicAuthSecret;

    return RequestOptions(
        extra: {'BasicAuth': true},
        path: 'cards/siteLocator',
        method: APIMethod.post,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$username:$password'))}',
        });
  }

  RequestOptions getFactor() {
    return RequestOptions(
      path: '/api/v2/idp-user/users/$routeParams/factors',
      method: APIMethod.get,
    );
  }

  RequestOptions clearPendingStatusPrevious() {
    return RequestOptions(
      path: '/api/v2/authn/previous',
      method: APIMethod.post,
    );
  }
  // =========== Cardholder APIs end ==============

// =========== New MW APIs integrations Start ============================

// =========== Location APIs Start =========

  RequestOptions siteLocatorAccessToken() {
    return RequestOptions(
      path: locationsUrl('v1/token'),
      method: APIMethod.post,
    );
  }

  RequestOptions siteLocations() {
    return RequestOptions(
      path: locationsUrl('v1/locations/summary'),
      method: APIMethod.post,
      headers: headerQueryParams != null
          ? {'Authorization': 'Bearer $headerQueryParams'}
          : {'Authorization': ''},
    );
  }

  RequestOptions merchSiteLocations() {
    return RequestOptions(
      path: locationsUrl('v1/locations/merchSites'),
      method: APIMethod.get,
      headers: headerQueryParams != null
          ? {'Authorization': 'Bearer $headerQueryParams'}
          : {'Authorization': ''},
    );
  }

  RequestOptions getFuelPrices() {
    return RequestOptions(
      path: locationsUrl('v1/locations/fuel-price'),
      method: APIMethod.post,
      headers: headerQueryParams != null
          ? {'Authorization': 'Bearer $headerQueryParams'}
          : {'Authorization': ''},
    );
  }

  RequestOptions getFuelPreferences() {
    return RequestOptions(
      path: locationsUrl('v1/prices/fuel-preference'),
      method: APIMethod.post,
      headers: headerQueryParams != null
          ? {'Authorization': 'Bearer $headerQueryParams'}
          : {'Authorization': ''},
    );
  }

  RequestOptions siteLocationsDistanceMatrix(String? directUrl) {
    return RequestOptions(
      path: '$directUrl',
      method: APIMethod.get,
      extra: {'directUrl': true},
      headers: apiKeySecurityHeaders,
    );
  }

  RequestOptions siteLocationsPlacesAutoComplete(String? directUrl) {
    return RequestOptions(
      path: '$directUrl',
      method: APIMethod.get,
      extra: {'directUrl': true},
      headers: apiKeySecurityHeaders,
    );
  }

  RequestOptions siteLocationsGeoCoding(String? directUrl) {
    return RequestOptions(
      path: '$directUrl',
      method: APIMethod.get,
      extra: {'directUrl': true},
      headers: apiKeySecurityHeaders,
    );
  }

  RequestOptions placesSearch(String? directUrl) {
    return RequestOptions(
      path: '$directUrl',
      method: APIMethod.post,
      extra: {'directUrl': true},
      headers: placesSearchHeaders,
    );
  }

  RequestOptions placeRating(String? directUrl) {
    return RequestOptions(
      path: '$directUrl',
      method: APIMethod.get,
      extra: {'directUrl': true},
      headers: placeDetailsHeaders,
    );
  }

  RequestOptions sitesBrandLogoUrls() {
    return RequestOptions(
      path: locationsUrl('v1/brand-logos'),
      method: APIMethod.get,
      headers: headerQueryParams != null
          ? {'Authorization': 'Bearer $headerQueryParams'}
          : {'Authorization': ''},
    );
  }

// =========== Location APIs End =========

// =========== Login APIs Start =========
  RequestOptions iframeAccessToken() {
    return RequestOptions(
      path: loginUrl('v1/token'),
      method: APIMethod.post,
    );
  }

  RequestOptions createProfile() {
    return RequestOptions(
      path: loginUrl('v1/users/create-profile'),
      method: APIMethod.post,
    );
  }

  RequestOptions updateProfile() {
    return RequestOptions(
      path: loginUrl('v1/users/update-profile'),
      method: APIMethod.put,
    );
  }

  RequestOptions updatePasscode() {
    return RequestOptions(
      path: loginUrl('v1/users/account/updatePassCode'),
      method: APIMethod.post,
    );
  }

  RequestOptions getExpressCheckSettings() {
    return RequestOptions(
      path: loginUrl('v1/users/account/getExpressCheckSettings'),
      method: APIMethod.post,
    );
  }

  RequestOptions updateExpressCheckSettings() {
    return RequestOptions(
      path: loginUrl('v1/users/account/updateExpressCheckSettings'),
      method: APIMethod.post,
    );
  }

  RequestOptions authenticate() {
    return RequestOptions(
      path: loginUrl('v1/users/authenticate'),
      method: APIMethod.post,
    );
  }

  RequestOptions biometricLogin() {
    return RequestOptions(
      path: loginUrl('v1/users/biometric'),
      method: APIMethod.post,
    );
  }

  RequestOptions adminAccountDetails() {
    return RequestOptions(
      path: loginUrl('v1/users/account/details'),
      method: APIMethod.post,
    );
  }

  RequestOptions adminAccountSummary() {
    return RequestOptions(
      path: loginUrl('v1/users/account/summary'),
      method: APIMethod.post,
    );
  }

  RequestOptions changePassword() {
    return RequestOptions(
      path: loginUrl('v1/users/changePassword'),
      method: APIMethod.post,
    );
  }

  RequestOptions getCustomerIdList() {
    return RequestOptions(
      path: loginUrl('v1/users/account/customerIdList'),
      method: APIMethod.post,
    );
  }

  RequestOptions changeCustomer() {
    return RequestOptions(
      path: loginUrl('v1/users/account/changeCustomer'),
      method: APIMethod.post,
    );
  }

  RequestOptions setDefaultProperties() {
    return RequestOptions(
      path: loginUrl('v1/users/account/defaultProperties'),
      method: APIMethod.post,
    );
  }

  RequestOptions getFundDetails() {
    return RequestOptions(
      path: loginUrl('v1/users/account/fundDetails'),
      method: APIMethod.post,
    );
  }

  RequestOptions getDynamicMenu() {
    return RequestOptions(
      path: loginUrl('v1/menu/filtered'),
      method: APIMethod.post,
    );
  }

  RequestOptions getProductDynamicMenu() {
    return RequestOptions(
      path: loginUrl('v1/menu/products'),
      method: APIMethod.post,
    );
  }

  RequestOptions getProductSsoLink() {
    return RequestOptions(
      path: loginUrl('v1/users/account/sso/link'),
      method: APIMethod.post,
    );
  }

  RequestOptions setCardholderOnboardStatus() {
    return RequestOptions(
      path: cardUrl('v1/cards/onboardStatus'),
      method: APIMethod.put,
    );
  }

  RequestOptions cancelCardholderRequest() {
    return RequestOptions(
      path: cardUrl('v1/cards/suspendCard'),
      method: APIMethod.put,
    );
  }

  RequestOptions resetFactor() {
    return RequestOptions(
      path: loginUrl('v1/users/factors/reset'),
      method: APIMethod.post,
    );
  }

  RequestOptions verifyOtp() {
    return RequestOptions(
      path: loginUrl('v1/users/factors/verify'),
      method: APIMethod.post,
    );
  }

  RequestOptions sendOtp() {
    return RequestOptions(
      path: loginUrl('v1/users/factors/send'),
      method: APIMethod.post,
    );
  }

  RequestOptions mfaVerifyOtp() {
    return RequestOptions(
      path: loginUrl('v1/users/factors/mfa/verifyOtp'),
      method: APIMethod.post,
    );
  }

  RequestOptions mfaSendOtp() {
    return RequestOptions(
      path: loginUrl('v1/users/factors/mfa/sendOtp'),
      method: APIMethod.post,
    );
  }

  RequestOptions enrollSmsFactor() {
    return RequestOptions(
      path: loginUrl('v1/users/factors/enroll'),
      method: APIMethod.post,
    );
  }

  RequestOptions activateSmsFactor() {
    return RequestOptions(
      path: loginUrl('v1/users/factors/activate'),
      method: APIMethod.post,
    );
  }
  // =========== Login APIs End ================

  // ================= Cardholder APIs start =================
  RequestOptions getCardholderAccountDetails() {
    return RequestOptions(
      path: cardUrl('v1/cards/refreshWalletV2'),
      method: APIMethod.get,
    );
  }

  RequestOptions getCards() {
    return RequestOptions(
      path: cardUrl('v1/mapi/cards/getCards'),
      method: APIMethod.post,
    );
  }

  RequestOptions validateInvitationCode() {
    return RequestOptions(
      path: cardUrl('v1/mapi/cards/validateAuthCode'),
      method: APIMethod.post,
    );
  }

  RequestOptions unlockCardholderCard() {
    return RequestOptions(
      path: cardUrl('v1/cards/autoLockUnlock'),
      method: APIMethod.post,
    );
  }

  RequestOptions getTransactionHistory() {
    return RequestOptions(
      path: cardUrl('v1/cards/transactionHistory'),
      method: APIMethod.post,
    );
  }

  RequestOptions changeNickname() {
    return RequestOptions(
      path: cardUrl('v1/cards/updateNickName'),
      method: APIMethod.put,
    );
  }

  RequestOptions setAsFavorite() {
    return RequestOptions(
      path: cardUrl('v1/cards/updateFavorite'),
      method: APIMethod.put,
    );
  }

  RequestOptions resetPin() {
    return RequestOptions(
      path: cardUrl('v1/cards/resetPin'),
      method: APIMethod.post,
    );
  }

  RequestOptions peerToPeerReview() {
    return RequestOptions(
      // path: cardUrl('v1/cards/validateSendMoney'),
      path: cardUrl('v1/cards/peerToPeer'),
      method: APIMethod.post,
    );
  }

  RequestOptions sendMoney() {
    return RequestOptions(
      path: cardUrl('v1/cards/sendMoney'),
      method: APIMethod.post,
    );
  }

  RequestOptions removeCard() {
    return RequestOptions(
      path: cardUrl('v1/cards/deleteCard'),
      method: APIMethod.delete,
    );
  }

  RequestOptions getBankAccount() {
    return RequestOptions(
      path: cardUrl('v1/bankManagement/getBankAccount'),
      method: APIMethod.post,
    );
  }

  RequestOptions addNewBankAccount() {
    return RequestOptions(
      path: cardUrl('v1/bankManagement/addBankAccount'),
      method: APIMethod.post,
    );
  }

  RequestOptions bankTransfer() {
    return RequestOptions(
      path: cardUrl('v1/bankManagement/transferToBank'),
      method: APIMethod.post,
    );
  }

  RequestOptions validateBankAccount() {
    return RequestOptions(
      path: cardUrl('v1/bankManagement/validateBankName'),
      method: APIMethod.post,
    );
  }

  RequestOptions getCardType() {
    return RequestOptions(
      // path: cardUrl('v1/cards/cardTypeV2'),
      path: cardUrl('v1/mapi/cards/cardType'),
      method: APIMethod.post,
    );
  }

  RequestOptions addPropCard() {
    return RequestOptions(
      path: cardUrl('v1/cards/addPropCardWalletV03'),
      method: APIMethod.post,
    );
  }

  RequestOptions addOnroadCard() {
    return RequestOptions(
      path: cardUrl('v1/cards/addCardToWalletV3'),
      method: APIMethod.post,
    );
  }

  RequestOptions addCard() {
    return RequestOptions(
      path: cardUrl('v1/mapi/cards/add'),
      method: APIMethod.post,
    );
  }

  RequestOptions shareFeedback() {
    return RequestOptions(
      path: loginUrl('v1/user-settings/shareFeedback'),
      method: APIMethod.post,
    );
  }

  RequestOptions generatePin() {
    return RequestOptions(
      path: cardUrl('v1/cards/generatePINKey'),
      method: APIMethod.post,
    );
  }

  RequestOptions setToPrimary() {
    return RequestOptions(
      path: cardUrl('v1/cards/updateUserToNewCard'),
      method: APIMethod.post,
    );
  }

  RequestOptions cardholderOnboardStatus() {
    return RequestOptions(
      path: cardUrl('v1/cards/onboardStatus'),
      method: APIMethod.post,
    );
  }

  RequestOptions getExpressCheckBalance() {
    return RequestOptions(
      path: cardUrl('v1/cards/getExpressCheckBalance'),
      method: APIMethod.post,
    );
  }

  RequestOptions registerComCheckDraft() {
    return RequestOptions(
      path: cardUrl('v1/cards/registerComchekDraft'),
      method: APIMethod.post,
    );
  }

  RequestOptions getAlertSetting() {
    return RequestOptions(
      path: cardUrl('v1/alerts/alertSetting'),
      method: APIMethod.post,
    );
  }

  RequestOptions updateAlertSetting() {
    return RequestOptions(
      path: cardUrl('v1/alerts/updateAlertSetting'),
      method: APIMethod.patch,
    );
  }

  RequestOptions moveExpressCheckBalanceToCard() {
    return RequestOptions(
      path: cardUrl('v1/cards/moveExpressCheckBalanceToCard'),
      method: APIMethod.post,
    );
  }

  RequestOptions cardToCardTransfer() {
    return RequestOptions(
      path: cardUrl('v1/cards/cardToCardTransfer'),
      method: APIMethod.post,
    );
  }

  RequestOptions cipCheckV2() {
    return RequestOptions(
      path: cardUrl('v1/cip/cipCheckV02'),
      method: APIMethod.post,
    );
  }

  RequestOptions getCipStatus() {
    return RequestOptions(
      path: cardUrl('v1/cards/cipStatus'),
      method: APIMethod.post,
    );
  }

  RequestOptions deleteUserProfile() {
    return RequestOptions(
      path: loginUrl('v1/users/deleteUserProfile'),
      method: APIMethod.post,
    );
  }

  RequestOptions dcForgotPassword() {
    return RequestOptions(
      path: loginUrl('v1/users/forgotPassword'),
      method: APIMethod.post,
    );
  }

  RequestOptions forgotPasswordSendOtp() {
    return RequestOptions(
      path: loginUrl('v1/users/factors/forgotPassword/sendOtp'),
      method: APIMethod.post,
    );
  }

  RequestOptions forgotPasswordVerifyOtp() {
    return RequestOptions(
      path: loginUrl('v1/users/factors/forgotPassword/verifyOtp'),
      method: APIMethod.post,
    );
  }

  RequestOptions dcCreateNewPassword() {
    return RequestOptions(
      path: loginUrl('v1/users/factors/forgotPassword/resetPassword'),
      method: APIMethod.post,
    );
  }

  RequestOptions jwtAccessToken() {
    return RequestOptions(
      // path: locationsUrl('v1/token'),
      path: locationsUrl('v1/token'),
      method: APIMethod.post,
    );
  }
  // ================= Cardholder APIs End =================

  // ================= Amazon APIs Start =================
  RequestOptions oneClickStatus() {
    return RequestOptions(
      path: amazonUrl('v1/cards/oneclick/status'),
      method: APIMethod.post,
    );
  }

  RequestOptions addCardRelation() {
    return RequestOptions(
      path: amazonUrl('v1/relation/add'),
      method: APIMethod.post,
    );
  }

  RequestOptions relationStatus() {
    return RequestOptions(
      path: amazonUrl('v1/relation/status'),
      method: APIMethod.post,
    );
  }

  RequestOptions deleteCardRelation() {
    return RequestOptions(
      path: amazonUrl('v1/relation/delete'),
      method: APIMethod.post,
    );
  }

  RequestOptions unlockCard() {
    return RequestOptions(
      path: amazonUrl('v1/cards/oneclick/unlock'),
      method: APIMethod.post,
    );
  }

  // ================= Amazon APIs End =================

// =========== New MW APIs integrations End============================

  // Common APIs
  RequestOptions post() {
    return RequestOptions(
      path: '/post',
      method: APIMethod.post,
    );
  }

  RequestOptions get() {
    return RequestOptions(
      path: '/get',
      method: APIMethod.get,
    );
  }

  RequestOptions put() {
    return RequestOptions(
      path: '/put',
      method: APIMethod.put,
    );
  }

  RequestOptions patch() {
    return RequestOptions(
      path: '/patch',
      method: APIMethod.patch,
    );
  }

  RequestOptions delete() {
    return RequestOptions(
      path: '/delete',
      method: APIMethod.delete,
    );
  }

  @override
  APIType getApiType() {
    return type;
  }
}

// ignore: one_member_abstracts
abstract class APIRouteConfigurable {
  RequestOptions? getConfig();

  APIType getApiType();
}

class APIMethod {
  static const get = 'GET';
  static const post = 'POST';
  static const put = 'PUT';
  static const patch = 'PATCH';
  static const delete = 'DELETE';
}
