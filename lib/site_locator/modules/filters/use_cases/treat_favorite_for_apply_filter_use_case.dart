import 'package:driven_site_locator/data/use_cases/base_usecase.dart';
import 'package:driven_site_locator/site_locator/constants/site_filter_keys_constants.dart';
import 'package:driven_site_locator/site_locator/data/models/site_filter.dart';
import 'package:get/get.dart';

class TreatFavoriteForApplyFilterUseCase
    extends BaseUseCase<void, TreatFavoriteForApplyFilterUseCaseParams> {
  TreatFavoriteForApplyFilterUseCase();

  @override
  void execute(TreatFavoriteForApplyFilterUseCaseParams param) {
    final isFavOptionSelectedLastTime = param.isFavOptionSelectedLastTime;
    final isFavoriteFilterSelected = param.isFavoriteFilterSelected;
    final selectedSiteFilters = param.selectedSiteFilters;
    if (!isFavOptionSelectedLastTime) {
      if (!isFavoriteFilterSelected) {
        selectedSiteFilters
            .removeWhere((element) => element.key == QuickFilterKeys.favorites);
        selectedSiteFilters.refresh();
      }
    }
  }
}

class TreatFavoriteForApplyFilterUseCaseParams {
  final bool isFavOptionSelectedLastTime;
  final bool isFavoriteFilterSelected;
  final RxList<SiteFilter> selectedSiteFilters;

  TreatFavoriteForApplyFilterUseCaseParams({
    required this.isFavOptionSelectedLastTime,
    required this.isFavoriteFilterSelected,
    required this.selectedSiteFilters,
  });
}
