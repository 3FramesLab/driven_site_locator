import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:driven_site_locator/config/globals.dart';
import 'package:driven_site_locator/constants/api_constants.dart';
import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/new_site_locator/new_site_locator_module.dart';

class APIInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    _logOnDynatrace(options);
    final headersList = await getRequestHeadersList(options);
    options.headers.addAll(headersList);
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      Globals().dynatrace.logError(
            name: DynatraceError.accessTokenExpiredError,
            value: '${err.response?.realUri} - ${DrivenSessionManager().uuid}',
            reason: DynatraceError.accessTokenExpiredError,
          );
      // Refresh the token
      final getJWTAccessTokenUseCase = GetJWTAccessTokenUseCase();
      await AppUtils.refreshAmazonAccessToken(
        getJWTAccessTokenUseCase: getJWTAccessTokenUseCase,
      );
    }
    super.onError(err, handler);
  }

  void _logOnDynatrace(RequestOptions options) {
    Globals().dynatrace.tagEvent(
          '${options.uri} - ${AppUtils.actualDeviceId}',
        );
  }

  Future<String?> _getUUID() async => HiveDBUtil.getUUID();

  Future<String> _getAccessToken() async {
    await _handleAccessToken();
    return 'Bearer ${DrivenSessionManager().jwtAccessToken}';
  }

  Future<void> _handleAccessToken() async {
    if (DrivenSessionManager().jwtAccessToken.isNullEmptyOrWhitespace ||
        AppUtils.isTokenExpired(DrivenSessionManager().jwtAccessToken)) {
      final getJWTAccessTokenUseCase = GetJWTAccessTokenUseCase();
      await AppUtils.refreshAmazonAccessToken(
        getJWTAccessTokenUseCase: getJWTAccessTokenUseCase,
      );
    }
  }

  Future<Map<String, dynamic>> getRequestHeadersList(
      RequestOptions options) async {
    try {
      final headersList = {
        ApiConstants.deviceId: await _getUUID(),
        ApiConstants.versionName: AppUtils.versionNumber,
        ApiConstants.versionNumber: AppUtils.versionNumber,
        ApiConstants.versionCode: AppUtils.buildNumber,
        ApiConstants.flavor: AppUtils.flavor,
        ApiConstants.applicationName: AppUtils.driven,
        ApiConstants.userId: DrivenSessionManager().userId,
        ApiConstants.sysAccId: DrivenSessionManager().defaultSysAccountId,
        ApiConstants.userName: DrivenSessionManager().mddbUserId,
      };
      // TODO(Smeet): Remove the check for location stg url .

      if (AppUtils.isQADebugMode) {
        log('\nAPI Headers list: $headersList');
      }
      return headersList;
    } catch (_) {
      return options.headers;
    }
  }
}
