import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:driven_site_locator/analytics/analytics.dart';
import 'package:driven_site_locator/config/globals.dart';
import 'package:driven_site_locator/constants/api_constants.dart';
import 'package:driven_site_locator/data/data_sources/interceptors/api_interceptor.dart';
import 'package:driven_site_locator/data/data_sources/remote/api_response.dart';
import 'package:driven_site_locator/data/data_sources/remote/api_route.dart';
import 'package:driven_site_locator/data/data_sources/remote/decodable.dart';
import 'package:driven_site_locator/data/data_sources/remote/dynatrace_logs_tracking.dart';
import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/extensions/extensions_module.dart';
import 'package:driven_site_locator/new_site_locator/new_site_locator_module.dart';

class APIClient {
  late BaseOptions options;
  late Dio instance;

  APIClient({BaseOptions? options}) {
    this.options = options ?? BaseOptions(baseUrl: ApiConstants.baseUrl);
    instance = Dio(options);
    final customInterceptors = [
      APIInterceptor(),
    ];
    instance.interceptors.addAll(customInterceptors);
  }

  // ignore: long-parameter-list
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
    config.baseUrl = options.baseUrl;
    if (data != null) {
      config.method == APIMethod.get
          ? config.queryParameters = data
          : config.data = data;
    }
    try {
      bool isFPApi = false;
      isFPApi = route.getApiType() == APIType.getFuelPrices;

      if (AppUtils.isQADebugMode) {
        log('\nAPI URL: ${config.baseUrl} \nEndpoint: ${config.path} \nMethodType: ${config.method} \nRequestBody: ${config.data} \nHeaders:${config.headers} \nQueryParams: ${config.queryParameters}');
      }

      final response = await _httpCall(config, isFPApi: isFPApi);
      if (isDeviceTokenFromHeaderRequired && isDeviceTokenAvailable(response)) {
        response.data[SLInternalText.xDeviceToken] =
            response.headers.map[SLInternalText.xDeviceTokenHeader]?.first;
      }
      if (AppUtils.isQADebugMode) {
        log('\nHttpResponseStatusCode:\n${response.statusCode}\nResponse:\n${response.data}');
      }
      return ResponseWrapper.init(create: create, data: response.data);
    } on DioException catch (error) {
      Globals().dynatrace.logError(
            name: 'API Call Error - ${config.uri}',
            value: error.message.toString(),
            reason: error.toString(),
          );
      var errorResponse =
          ErrorResponse(errorSummary: SLViewText.somethingWentWrong);
      errorResponse.headers = error.response?.headers;
      errorResponse.statusCode = error.response?.statusCode;

      try {
        if (error.error is SocketException) {
          errorResponse.statusCode = SLInternalText.socketError;
        } else if (error.response?.data != null) {
          errorResponse = ErrorResponse.fromJson(error.response?.data);
          if (errorResponse.errorSummary == SLInternalText.unableToParseJSON ||
              errorResponse.statusCode == 404) {
            errorResponse.errorSummary = SLInternalText.internalServerError;
          }
        }
      } catch (error) {
        Globals().dynatrace.logError(
              name: 'API Call Parsing Error - ${config.uri}',
              value: error.toString(),
              reason: error.toString(),
            );
        throw errorResponse;
      }
      if (AppUtils.isQADebugMode) {
        log('\nErrorResponse: \n'
            'StatusCode: ${errorResponse.statusCode}, '
            'ErrorCode: ${errorResponse.errorCode}, '
            'ErrorSummary: ${errorResponse.errorSummary}, '
            'ErrorMessage: ${errorResponse.errorMessage}, '
            'StatusMessage: ${errorResponse.statusMessage}, '
            'StatusCodeOkta: ${errorResponse.statusCodeOkta}, '
            'Error: ${errorResponse.error}, '
            'ResponseCode: ${errorResponse.responseCode}');
      }
      throw errorResponse;
    } on Exception catch (error) {
      Globals().dynatrace.logError(
            name: 'API Call Exception: - ${config.uri}',
            value: error.toString(),
            reason: error.toString(),
          );
      throw ErrorResponse(errorSummary: SLViewText.somethingWentWrong);
    }
  }

  String getRandom(int length) {
    const ch = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final math.Random r = math.Random();
    return String.fromCharCodes(
        Iterable.generate(length, (_) => ch.codeUnitAt(r.nextInt(ch.length))));
  }

  String generateReqId() {
    final chars9 = getRandom(9);
    final String last3chars = AppUtils.isAndroid ? 'and' : 'ios';
    final last12 = chars9 + last3chars;

    final xRequestId =
        '${getRandom(8)}-dfcM-${getRandom(4)}-${getRandom(8)}-$last12';
    return xRequestId;
  }

  Map<String, dynamic>? _getHeaderX(
      bool isFPApi, RequestOptions requestOptions) {
    // TODO(Shailendra): Enable it if you want to debug
    // if (isFPApi) {
    //   debugPrint(
    //       'FPLOGS request body JSON from http call = ${requestOptions.data.toString()}');
    // }
    final headersX = requestOptions.headers;

    headersX.putIfAbsent('x-request-id', generateReqId);
    return headersX;
  }

  void _writeOnDynatrace(
      bool isFPApi, Map<String, dynamic>? headersX, RequestOptions reqOpts) {
    if (isFPApi) {
      final DateTime nowX = DateTime.now();
      final ts = '${nowX.hour}:${nowX.minute}:${nowX.second}';
      fireDynatraceFuelPriceAPILogs(
          'Locations API request Id: ${headersX?['x-request-id']} ts=$ts');

      fireDynatraceFuelPriceAPILogs(
          'Locations API request body: ${reqOpts.data.toString()}');
    }
  }

  Future<Response<T>> _httpCall<T>(RequestOptions requestOptions,
      {bool isFPApi = false}) async {
    final url = '${requestOptions.baseUrl}${requestOptions.path}';

    final headersX = _getHeaderX(isFPApi, requestOptions);

    _writeOnDynatrace(isFPApi, headersX, requestOptions);
    switch (requestOptions.method) {
      case APIMethod.post:
        if (requestOptions.extra['directUrl'] ?? false) {
          return instance.post(
            requestOptions.path,
            data: requestOptions.data,
            options: Options(headers: headersX),
          );
        } else {
          return instance.post(
            url,
            data: requestOptions.data,
            options: Options(headers: headersX),
          );
        }
      case APIMethod.put:
        return instance.put(
          url,
          data: requestOptions.data,
        );
      case APIMethod.patch:
        return instance.patch(
          url,
          data: requestOptions.data,
        );
      case APIMethod.delete:
        return instance.delete(
          url,
          data: requestOptions.data,
        );
      case APIMethod.get:
        if (requestOptions.extra['directUrl'] ?? false) {
          return instance.get(
            requestOptions.path,
            options: Options(headers: headersX),
          );
        } else {
          if (headersX?.entries.isNotEmpty ?? false) {
            return instance.get(
              url,
              queryParameters: requestOptions.queryParameters,
              options: Options(headers: headersX),
            );
          } else {
            return instance.get(
              url,
              queryParameters: requestOptions.queryParameters,
            );
          }
        }

      default:
        return Response(requestOptions: RequestOptions());
    }
  }

  bool isDeviceTokenAvailable(Response<dynamic> response) =>
      response.headers.map
          .toString()
          .toLowerCase()
          .contains(SLInternalText.xDeviceTokenHeader.toLowerCase());
}
