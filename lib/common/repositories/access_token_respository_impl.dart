import 'package:dio/dio.dart';
import 'package:driven_site_locator/common/repositories/access_token_repository.dart';
import 'package:driven_site_locator/constants/api_constants.dart';
import 'package:driven_site_locator/data/data_sources/remote/api_client.dart';
import 'package:driven_site_locator/data/data_sources/remote/api_response.dart';
import 'package:driven_site_locator/data/data_sources/remote/api_route.dart';
import 'package:driven_site_locator/data/model/access_token.dart';

class AccessTokenRepositoryImpl extends AccessTokenRepository {
  final APIClient apiClient = APIClient(
    options: BaseOptions(baseUrl: ApiConstants.mwBaseUrl),
  );

  @override
  Future<AccessToken?> getIFrameAccessToken(
      {Map<String, dynamic>? jsonData}) async {
    final result = await apiClient.request(
      route: APIRoute(APIType.iframeAccessToken),
      create: () => APIResponse<AccessToken>(create: AccessToken.new),
      data: jsonData,
    );

    final AccessToken? tokenDetails = result.response?.data;
    return tokenDetails;
  }

  @override
  Future<AccessToken?> getJWTAccessToken(
      {Map<String, dynamic>? jsonData}) async {
    final result = await apiClient.request(
      route: APIRoute(APIType.jwtAccessToken),
      create: () => APIResponse<AccessToken>(create: AccessToken.new),
      data: jsonData,
    );

    final AccessToken? tokenDetails = result.response?.data;
    return tokenDetails;
  }
}
