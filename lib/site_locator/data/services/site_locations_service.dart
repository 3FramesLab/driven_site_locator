import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_api_constants.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';
import 'package:driven_site_locator/site_locator/data/models/brand_logo_urls.dart';
import 'package:driven_site_locator/site_locator/data/models/distance_matrix.dart';
import 'package:driven_site_locator/site_locator/data/models/fuel_preferences.dart';
import 'package:driven_site_locator/site_locator/data/models/fuel_prices.dart';
import 'package:driven_site_locator/site_locator/data/models/google_geocoding_model.dart';
import 'package:driven_site_locator/site_locator/data/models/google_place_model.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SiteLocationsService extends GetxService {
  final apiClient = APIClient(
    options: BaseOptions(baseUrl: SiteLocatorApiConstants.siteLocationBaseUrl),
  );
  final fuelPricesApiClient = APIClient(
    options: BaseOptions(baseUrl: SiteLocatorApiConstants.fuelPricesBaseUrl),
  );

  Future<List<SiteLocation>?> getSiteLocationsData(
      Map<String, dynamic> jsonData,
      {String? headerQueryParams}) async {
    final result = await apiClient.request(
      route:
          APIRoute(APIType.siteLocations, headerQueryParams: headerQueryParams),
      create: () => APIResponse<List<SiteLocation>>(create: SiteLocation.new),
      data: jsonData,
    );

    final List<SiteLocation>? siteDetails = result.response?.data;
    return siteDetails;
  }

  Future<DistanceMatrix?>? fetchDistanceData(String? distanceMatrixUrl) async {
    final result = await apiClient.request(
      route: APIRoute(APIType.siteLocationsDistanceMatrix,
          directUrl:
              '$distanceMatrixUrl&key=${SiteLocatorApiConstants.googleAPIKey}'),
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
    const jsonPath = SiteLocatorAssets.backupBrandLogoUrlsPath;
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

  Future<List<FuelPrices>?> getFuelPrices(Map<String, dynamic> jsonData,
      {String? headerQueryParams}) async {
    final result = await fuelPricesApiClient.request(
      data: jsonData,
      route:
          APIRoute(APIType.getFuelPrices, headerQueryParams: headerQueryParams),
      create: () => APIResponse<List<FuelPrices>>(create: FuelPrices.new),
    );
    final responseData = result.response?.data;
    return responseData;
  }

  Future<List<FuelPreferences>?> getFuelPreferences(
      Map<String, dynamic> jsonData,
      {String? headerQueryParams}) async {
    final result = await fuelPricesApiClient.request(
      data: jsonData,
      route: APIRoute(
        APIType.getFuelPreferences,
        headerQueryParams: headerQueryParams,
      ),
      create: () =>
          APIResponse<List<FuelPreferences>>(create: FuelPreferences.new),
    );
    final responseData = result.response?.data;
    return responseData;
  }
}
