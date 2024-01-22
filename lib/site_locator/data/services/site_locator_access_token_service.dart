import 'package:dio/dio.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_api_constants.dart';
import 'package:driven_site_locator/site_locator/data/models/site_locator_access_token.dart';
import 'package:get/get.dart';

class SiteLocatorAccessTokenService extends GetxService {
  final apiClient = APIClient(
      options: BaseOptions(
    baseUrl: SiteLocatorApiConstants.siteLocatorAccessTokenBaseUrl,
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
