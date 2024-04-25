import 'package:dio/dio.dart';
import 'package:driven_common/data/data_module.dart';
import 'package:driven_common/globals.dart';

enum APIType {
  siteLocatorAccessToken,
  siteLocations,
  siteLocationsDistanceMatrix,
  siteLocationsPlacesAutoComplete,
  siteLocationsGeoCoding,
  getFuelPrices,
  getFuelPreferences,
  sitesBrandLogoUrls,
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

  static const String adminSiteLocationsPath = '/site/locations/summary';
  static const String cardholderSiteLocationsPath =
      '/site/locations/comdata/summary';

  final headers = {
    'Access-Control-Allow-Origin': '*',
    'accept': 'application/json',
    'content-type': 'application/json'
  };

  final apiKeySecurityHeaders = {
    'X-Android-Package': Globals().packageId,
    'X-Android-Cert': Globals().androidCertSignature,
    'x-ios-bundle-identifier': Globals().packageId,
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
      case APIType.siteLocatorAccessToken:
        return siteLocatorAccessToken();
      case APIType.siteLocations:
        return siteLocations();
      case APIType.siteLocationsDistanceMatrix:
        return siteLocationsDistanceMatrix(directUrl);
      case APIType.siteLocationsPlacesAutoComplete:
        return siteLocationsPlacesAutoComplete(directUrl);
      case APIType.siteLocationsGeoCoding:
        return siteLocationsGeoCoding(directUrl);
      case APIType.getFuelPrices:
        return getFuelPrices();
      case APIType.getFuelPreferences:
        return getFuelPreferences();
      case APIType.sitesBrandLogoUrls:
        return sitesBrandLogoUrls();
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

  RequestOptions siteLocatorAccessToken() {
    return RequestOptions(
      path: '/app/token',
      method: APIMethod.post,
    );
  }

  RequestOptions siteLocations() {
    headers.addAll(headerQueryParams != null
        ? {
            'Authorization': 'Bearer $headerQueryParams',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': '*',
            'Access-Control-Allow-Methods': '*'
          }
        : {'Authorization': ''});
    return RequestOptions(
      path: Globals().isComdata
          ? cardholderSiteLocationsPath
          : adminSiteLocationsPath,
      method: APIMethod.post,
      // headers: headerQueryParams != null
      //     ? {'Authorization': 'Bearer $headerQueryParams'}
      //     : {'Authorization': ''},
      headers: headers,
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

  RequestOptions sitesBrandLogoUrls() {
    headers.addAll(headerQueryParams != null
        ? {
            'Authorization': 'Bearer $headerQueryParams',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': '*',
            'Access-Control-Allow-Methods': '*'
          }
        : {'Authorization': ''});
    return RequestOptions(
      path: '/SLS/brand-logos',
      method: APIMethod.get,
      // headers: headerQueryParams != null
      //     ? {'Authorization': 'Bearer $headerQueryParams'}
      //     : {'Authorization': ''},
      headers: headers,
    );
  }

  RequestOptions getFuelPrices() {
    return RequestOptions(
      path: '/fleets/fuel-price',
      method: APIMethod.post,
      headers: headerQueryParams != null
          ? {'Authorization': 'Bearer $headerQueryParams'}
          : {'Authorization': ''},
    );
  }

  RequestOptions getFuelPreferences() {
    return RequestOptions(
      path: '/fleets/fuel-preference',
      method: APIMethod.post,
      headers: headerQueryParams != null
          ? {'Authorization': 'Bearer $headerQueryParams'}
          : {'Authorization': ''},
    );
  }

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
}
