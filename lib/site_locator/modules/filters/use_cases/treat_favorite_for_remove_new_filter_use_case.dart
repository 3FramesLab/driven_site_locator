import 'package:driven_site_locator/data/use_cases/base_usecase.dart';
import 'package:driven_site_locator/site_locator/data/models/site_filter.dart';

class TreatFavoriteForRemoveNewlyAddedFilterUseCase
    extends BaseUseCase<void, TreatFavoriteForRemoveNewlyAddedFilterParams> {
  TreatFavoriteForRemoveNewlyAddedFilterUseCase();

  @override
  void execute(TreatFavoriteForRemoveNewlyAddedFilterParams param) {
    final bool isFavoriteQuickFilterOptionSelected =
        param.isFavoriteQuickFilterOptionSelected;

    final favoriteQuickFilter = param.favoriteQuickFilter;
    final filtersToReset = param.filtersToReset;

    if (isFavoriteQuickFilterOptionSelected) {
      filtersToReset.add(favoriteQuickFilter);
    }
  }
}

class TreatFavoriteForRemoveNewlyAddedFilterParams {
  final bool isFavOptionSelectedLastTime;
  final bool isFavoriteQuickFilterOptionSelected;
  final SiteFilter favoriteQuickFilter;
  final List<SiteFilter> filtersToReset;

  TreatFavoriteForRemoveNewlyAddedFilterParams({
    required this.isFavOptionSelectedLastTime,
    required this.isFavoriteQuickFilterOptionSelected,
    required this.favoriteQuickFilter,
    required this.filtersToReset,
  });
}
