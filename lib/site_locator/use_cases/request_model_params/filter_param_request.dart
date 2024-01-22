import 'package:driven_site_locator/site_locator/data/models/site_location.dart';

class FilterSiteParams {
  final List<SiteLocation>? locations;
  final List<String> quickFilters;
  final List<String> favoriteList;
  FilterSiteParams({
    required this.quickFilters,
    required this.locations,
    required this.favoriteList,
  });
}
