import 'package:driven_site_locator/data/use_cases/base_usecase.dart';
import 'package:driven_site_locator/site_locator/data/models/enhanced_filter_model.dart';
import 'package:driven_site_locator/site_locator/data/models/site_filter.dart';
import 'package:get/get.dart';

class GetTopVisibleFuelBrandsUseCase
    extends BaseUseCase<EnhancedFilterModel?, GetTopVisibleFuelBrandsParams> {
  @override
  EnhancedFilterModel? execute(GetTopVisibleFuelBrandsParams param) {
    final viewFuelBrand = param.allEnhancedFilters.firstWhereOrNull(
      (filter) => filter.serviceType == ServiceTypeEnum.fuelBrand,
    );

    final list = param.fuelBrandFilterList
        .map(SiteFilter.clone)
        .where((siteFilter) => siteFilter.isTopVisible)
        .toList();
    viewFuelBrand?.filterItems.clear();
    viewFuelBrand?.filterItems.addAll(list);

    return viewFuelBrand;
  }
}

class GetTopVisibleFuelBrandsParams {
  final List<EnhancedFilterModel> allEnhancedFilters;
  final List<SiteFilter> fuelBrandFilterList;

  GetTopVisibleFuelBrandsParams({
    required this.allEnhancedFilters,
    required this.fuelBrandFilterList,
  });
}
