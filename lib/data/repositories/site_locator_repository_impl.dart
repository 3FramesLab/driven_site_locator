import 'package:driven_site_locator/data/repositories/site_locator_repository.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/data/services/site_locations_service.dart';
import 'package:driven_site_locator/site_locator/use_cases/request_model_params/site_location_params.dart';

class SiteLocatorRepositoryImpl implements SiteLocatorRepository {
  final SiteLocationsService siteLocationsService;
  SiteLocatorRepositoryImpl({
    required this.siteLocationsService,
  });

  @override
  Future<List<SiteLocation>?> getSiteLocationsData(
          SiteLocationParams params) async =>
      siteLocationsService.getSiteLocationsData(
        params.jsonData,
        headerQueryParams: params.token,
      );
}
