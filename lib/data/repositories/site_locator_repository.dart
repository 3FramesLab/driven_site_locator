// ignore_for_file: one_member_abstracts

import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/use_cases/request_model_params/site_location_params.dart';

abstract class SiteLocatorRepository {
  Future<List<SiteLocation>?> getSiteLocationsData(SiteLocationParams params);
}
