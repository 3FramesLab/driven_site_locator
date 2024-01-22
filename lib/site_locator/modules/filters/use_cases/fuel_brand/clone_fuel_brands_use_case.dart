import 'package:driven_site_locator/data/use_cases/base_usecase.dart';
import 'package:driven_site_locator/site_locator/data/local/enhanced_filter/enhanced_filter_data.dart';
import 'package:driven_site_locator/site_locator/data/models/site_filter.dart';
import 'package:get/get.dart';

class CloneFuelBrandsUseCase extends BaseNoParamUseCase<List<SiteFilter>> {
  @override
  List<SiteFilter> execute() {
    return enhancedFilterData
            .firstWhereOrNull(
              (filter) => filter.serviceType == ServiceTypeEnum.fuelBrand,
            )
            ?.filterItems
            .toList() ??
        [];
  }
}
