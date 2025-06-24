// ignore_for_file: unnecessary_lambdas

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:driven_site_locator/constants/api_constants.dart';
import 'package:driven_site_locator/data/data_sources/remote/api_client.dart';
import 'package:driven_site_locator/data/data_sources/remote/api_direct.dart';
import 'package:driven_site_locator/data/data_sources/remote/api_response.dart';
import 'package:driven_site_locator/data/data_sources/remote/api_route.dart';
import 'package:driven_site_locator/new_site_locator/models/brand_logo_urls.dart';
import 'package:driven_site_locator/new_site_locator/models/distance_matrix.dart';
import 'package:driven_site_locator/new_site_locator/models/google_geocoding_model.dart';
import 'package:driven_site_locator/new_site_locator/models/google_place_model.dart';
import 'package:driven_site_locator/new_site_locator/new_site_locator_module.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SLSiteLocationsService extends GetxService {
  final apiClient = APIClient(
    options: BaseOptions(
      baseUrl: ApiConstants.baseUrl,
    ),
  );

  final apiDirect = APIDirect();

  Future<DistanceMatrix?>? fetchDistanceData(String? distanceMatrixUrl) async {
    final result = await apiClient.request(
      route: APIRoute(APIType.siteLocationsDistanceMatrix,
          directUrl: '$distanceMatrixUrl&key=${ApiConstants.googleAPIKey}'),
      create: () => APIResponse<DistanceMatrix>(create: DistanceMatrix.new),
    );
    return result.response?.data ?? DistanceMatrix();
  }

  Future<GooglePlacesModel>? fetchPlacesData(
      String? placesApiUrl, String searchText,
      {String? currentLocation}) async {
    final result = await apiClient.request(
      route: APIRoute(
        APIType.siteLocationsPlacesAutoComplete,
        directUrl: '$placesApiUrl&location=$currentLocation&input=$searchText',
      ),
      create: () =>
          APIResponse<GooglePlacesModel>(create: GooglePlacesModel.new),
    );
    return result.response?.data ?? GooglePlacesModel();
  }

  Future<GoogleGeoCodingModel>? fetchPlaceLatLngByPlaceId(
    String? geocodingUrl,
    String placeId,
  ) async {
    final result = await apiClient.request(
      route: APIRoute(
        APIType.siteLocationsPlacesAutoComplete,
        directUrl: '$geocodingUrl&place_id=$placeId',
      ),
      create: () =>
          APIResponse<GoogleGeoCodingModel>(create: GoogleGeoCodingModel.new),
    );
    return result.response?.data ?? GoogleGeoCodingModel();
  }

  Future<List<dynamic>> getBackupBrandLogoUrlsFromAssets() async {
    const jsonPath = SLAssets.backupBrandLogoUrlsPath;
    final jsonEncode = await rootBundle.load(jsonPath);
    return json.decode(utf8.decode(jsonEncode.buffer.asUint8List()));
  }

  Future<List<dynamic>?> fetchBrandLogoUrls({String? headerQueryParams}) async {
    final result = await apiClient.request(
      route: APIRoute(APIType.sitesBrandLogoUrls,
          headerQueryParams: headerQueryParams),
      create: () => APIResponse<List<BrandLogoUrls>>(create: BrandLogoUrls.new),
    );

    final responseData = result.response?.data;
    final brandLogoUrlList =
        (responseData != null && (responseData[0].list?.isNotEmpty ?? false))
            ? responseData[0].list
            : await getBackupBrandLogoUrlsFromAssets();
    return brandLogoUrlList;
  }

  Future<MerchSiteResponse?> getMerchSiteLocation(Map<String, dynamic> jsonData,
      {String? headerQueryParams}) async {
    final result = await apiClient.request(
      data: jsonData,
      route: APIRoute(
        APIType.merchSiteLocations,
        headerQueryParams: headerQueryParams,
      ),
      create: () => APIResponse<MerchSiteResponse>(
        create: MerchSiteResponse.new,
      ),
    );

    final responseData = result.response?.data;
    return responseData;
  }

  Future<List<FuelPrices>?> getFuelPrices(Map<String, dynamic> jsonData,
      {String? headerQueryParams}) async {
    final result = await apiClient.request(
      data: jsonData,
      route:
          APIRoute(APIType.getFuelPrices, headerQueryParams: headerQueryParams),
      create: () => APIResponse<List<FuelPrices>>(create: FuelPrices.new),
    );
    final responseData = result.response?.data;
    return responseData;
  }

  Future<PlacesEntity?>? fetchPlaceIDByAddress(String queryPlace) async {
    final result = await apiDirect.request(
      route: APIRoute(
        APIType.placesSearch,
        directUrl: ApiConstants.googlePlacesSearchUrl,
      ),
      create: () => APIResponse<PlacesEntity>(create: PlacesEntity.new),
      data: {'textQuery': queryPlace},
    );
    return result.response?.data ?? PlacesEntity();
  }

  Future<PlaceRatingEntity?>? fetchSiteRating(String placeID) async {
    final result = await apiDirect.request(
      route: APIRoute(
        APIType.placeRating,
        directUrl: '${ApiConstants.googlePlaceDetailsUrl}/$placeID',
      ),
      create: () =>
          APIResponse<PlaceRatingEntity>(create: PlaceRatingEntity.new),
    );
    return result.response?.data ?? PlaceRatingEntity();
  }
}
