import 'package:driven_site_locator/common/repositories/access_token_respository_impl.dart';
import 'package:driven_site_locator/constants/api_constants.dart';
import 'package:driven_site_locator/use_cases/base_future_usecase.dart';
import 'package:get/get.dart';

class GetJWTAccessTokenUseCase extends BaseNoParamFutureUseCase<String> {
  @override
  Future<String> execute() async {
    final AccessTokenRepositoryImpl accessTokenRepositoryImpl =
        Get.put(AccessTokenRepositoryImpl());

    final response = await accessTokenRepositoryImpl.getJWTAccessToken(
      jsonData: ApiConstants.jwtAccessTokenJson,
    );
    return response?.accessToken ?? '';
  }
}
