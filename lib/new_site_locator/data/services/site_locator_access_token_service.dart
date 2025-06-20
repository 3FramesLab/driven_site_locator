import 'package:dio/dio.dart';
import 'package:driven_site_locator/constants/api_constants.dart';
import 'package:driven_site_locator/data/data_sources/remote/api_client.dart';
import 'package:driven_site_locator/data/data_sources/remote/api_response.dart';
import 'package:driven_site_locator/data/data_sources/remote/api_route.dart';
import 'package:driven_site_locator/new_site_locator/models/site_locator_access_token.dart';
import 'package:get/get.dart';

class SiteLocatorAccessTokenService extends GetxService {
  final apiClient = APIClient(
      options: BaseOptions(
    baseUrl: ApiConstants.baseUrl,
  ));

  Future<SiteLocatorAccessToken?> getAccessToken(
      Map<String, dynamic> jsonData) async {
    final result = await apiClient.request(
      route: APIRoute(APIType.siteLocatorAccessToken),
      create: () => APIResponse<SiteLocatorAccessToken>(
          create: SiteLocatorAccessToken.new),
      data: jsonData,
    );

    final SiteLocatorAccessToken? tokenDetails = result.response?.data;
    return tokenDetails;
  }
}
