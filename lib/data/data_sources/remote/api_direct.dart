import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:driven_site_locator/analytics/analytics.dart';
import 'package:driven_site_locator/config/globals.dart';
import 'package:driven_site_locator/data/data_sources/remote/api_client.dart';
import 'package:driven_site_locator/data/data_sources/remote/api_response.dart';
import 'package:driven_site_locator/data/data_sources/remote/api_route.dart';
import 'package:driven_site_locator/data/data_sources/remote/decodable.dart';
import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/new_site_locator/new_site_locator_module.dart';

class APIDirect {
  late Dio? _dio;

  APIDirect({Dio? dio}) {
    _dio = dio ?? Dio();
  }

  Future<ResponseWrapper<T>> request<T extends Decodable<dynamic>>({
    required APIRouteConfigurable route,
    required Create<T> create,
    dynamic data,
    AnalyticsScreenName? analyticsScreenName = AnalyticsScreenName.noTracking,
    bool isDeviceTokenFromHeaderRequired = false,
  }) async {
    final config = route.getConfig();
    if (config == null) {
      throw ErrorResponse(errorSummary: SLInternalText.requestFailed);
    }

    if (data != null) {
      config.method == APIMethod.get
          ? config.queryParameters = data
          : config.data = data;
    }
    try {
      if (AppUtils.isQADebugMode) {
        log('\n API Direct URL: ${config.baseUrl} \nEndpoint: ${config.path} \nMethodType: ${config.method} \nRequestBody: ${config.data} \nHeaders:${config.headers} \nQueryParams: ${config.queryParameters}');
      }

      final response = await _callHttp(config);

      if (AppUtils.isQADebugMode) {
        log('\nDirect HttpResponseStatusCode:\n${response.statusCode}\nResponse:\n${response.data}');
      }
      return ResponseWrapper.init(create: create, data: response.data);
    } on DioException catch (error) {
      Globals().dynatrace.logError(
            name: 'API Direct Call Error - ${config.uri}',
            value: error.message.toString(),
            reason: error.toString(),
          );
      final errorResponse =
          ErrorResponse(errorSummary: SLViewText.somethingWentWrong);
      errorResponse.headers = error.response?.headers;
      errorResponse.statusCode = error.response?.statusCode;

      throw errorResponse;
    } on Exception catch (error) {
      Globals().dynatrace.logError(
            name: 'API Direct Call Exception: - ${config.uri}',
            value: error.toString(),
            reason: error.toString(),
          );
      throw ErrorResponse(errorSummary: SLViewText.somethingWentWrong);
    }
  }

  Future<Response<T>> _callHttp<T>(RequestOptions requestOptions) async {
    final headersX = _getHeaderX(requestOptions);

    switch (requestOptions.method) {
      case APIMethod.post:
        return _dio!.post(
          requestOptions.path,
          data: requestOptions.data,
          options: Options(headers: headersX),
        );

      case APIMethod.get:
        return _dio!.get(
          requestOptions.path,
          options: Options(headers: headersX),
        );

      default:
        return Response(requestOptions: RequestOptions());
    }
  }

  Map<String, dynamic>? _getHeaderX(RequestOptions requestOptions) {
    final headersX = requestOptions.headers;

    headersX.putIfAbsent('x-request-id', APIClient().generateReqId);
    return headersX;
  }
}
