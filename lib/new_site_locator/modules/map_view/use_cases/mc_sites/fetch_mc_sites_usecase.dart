import 'package:driven/common/utilities/app_utils.dart';
import 'package:driven_site_locator/use_cases/base_future_usecase.dart';
import 'package:driven/new_site_locator/new_site_locator_module.dart';
import 'package:driven/site_locator/data/services/site_locations_service.dart';
import 'package:driven/site_locator/use_cases/access_token/get_access_token_for_sites_use_case.dart';
import 'package:get/get.dart';

class FetchMCSitesUseCase
    extends BaseFutureUseCase<List<SiteLocation>, FetchSitesUseCaseParams> {
  final SiteLocationsService siteLocationsService;
  final GetAccessTokenForSitesUseCase getAccessTokenForSitesUseCase =
      Get.put(GetAccessTokenForSitesUseCase());

  FetchMCSitesUseCase({required this.siteLocationsService});

  @override
  Future<List<SiteLocation>> execute(FetchSitesUseCaseParams param) async {
    if (AppUtils.isComdata) {
      final mcSiteLocations = await _getSitesFromAPI(param);
      return mcSiteLocations;
    }
    return [];
  }

  Future<List<SiteLocation>> _getSitesFromAPI(
      FetchSitesUseCaseParams param) async {
    final siteLocations = await siteLocationsService.getSiteLocationsData(
      param.payload,
      headerQueryParams: param.accessToken,
    );
    return siteLocations ?? [];
  }
}

class FetchSitesUseCaseParams {
  final bool isUserAuthenticated;
  final Map<String, dynamic> payload;
  final String accessToken;

  FetchSitesUseCaseParams(
    this.payload,
    this.accessToken, {
    this.isUserAuthenticated = false,
  });
}
