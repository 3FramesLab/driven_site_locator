import 'package:driven_site_locator/data/use_cases/base_usecase.dart';
import 'package:driven_site_locator/site_locator/data/models/site_filter.dart';

class SearchFuelBrandsUseCase
    extends BaseUseCase<List<SiteFilter>, SearchFuelBrandsParams> {
  @override
  List<SiteFilter> execute(SearchFuelBrandsParams param) {
    return param.fuelBrandFilterList
        .map(SiteFilter.clone)
        .where((siteFilter) =>
            siteFilter.label.toLowerCase().contains(param.searchQuery))
        .toList();
  }
}

class SearchFuelBrandsParams {
  final String searchQuery;
  final List<SiteFilter> fuelBrandFilterList;

  SearchFuelBrandsParams({
    required this.searchQuery,
    required this.fuelBrandFilterList,
  });
}
