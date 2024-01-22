import 'package:driven_site_locator/data/use_cases/base_usecase.dart';
import 'package:driven_site_locator/site_locator/data/models/enhanced_filter_model.dart';
import 'package:driven_site_locator/site_locator/data/models/site_filter.dart';
import 'package:get/get.dart';

class ShowOrHideFuelBrandsUseCase
    extends BaseUseCase<EnhancedFilterModel?, ShowOrHideFuelBrandsParams> {
  @override
  EnhancedFilterModel? execute(ShowOrHideFuelBrandsParams param) {
    final viewFuelBrand = param.allEnhancedFilters.firstWhereOrNull(
      (filter) => filter.serviceType == ServiceTypeEnum.fuelBrand,
    );

    viewFuelBrand?.filterItems.clear();

    if (param.showMoreFuelBrands) {
      viewFuelBrand?.filterItems.addAll(
        param.fuelBrandFilterList.map(SiteFilter.clone).toList(),
      );
    } else {
      final list = param.fuelBrandFilterList
          .map(SiteFilter.clone)
          .where((siteFilter) => siteFilter.isTopVisible)
          .toList();
      viewFuelBrand?.filterItems.addAll(list);
    }

    return viewFuelBrand;
  }
}

class ShowOrHideFuelBrandsParams {
  final bool showMoreFuelBrands;
  final List<EnhancedFilterModel> allEnhancedFilters;
  final List<SiteFilter> fuelBrandFilterList;

  ShowOrHideFuelBrandsParams({
    required this.showMoreFuelBrands,
    required this.allEnhancedFilters,
    required this.fuelBrandFilterList,
  });
}
