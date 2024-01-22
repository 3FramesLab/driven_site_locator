part of filter_module;

class RetrieveFiltersFromSPUseCase
    extends BaseUseCase<List<SiteFilter>, RetrieveFiltersFromSPParams> {
  RetrieveFiltersFromSPUseCase();

  @override
  List<SiteFilter> execute(RetrieveFiltersFromSPParams param) {
    final allSiteFilter =
        param.allEnhancedFilters.expand((e) => e.filterItems).toList();
    final requireFavorites = param.requireFavorites;
    final selectedSiteFilter = <SiteFilter>[];

    final selectedFilterKeys = PreferenceUtils.getStringList(
      SiteLocatorStorageKeys.selectedSiteFilters,
    );

    if (selectedFilterKeys != null && selectedFilterKeys.isNotEmpty) {
      for (final selectedFilterKey in selectedFilterKeys) {
        selectedSiteFilter.addAll(
          allSiteFilter
              .where(
            (e) => e.key == selectedFilterKey,
          )
              .map(
            (e) {
              e.isChecked = true;
              return e;
            },
          ).toList(),
        );
      }
    }

    if (requireFavorites) {
      selectedSiteFilter.add(favoriteQuickFilter);
    }

    return selectedSiteFilter;
  }
}

class RetrieveFiltersFromSPParams {
  final List<EnhancedFilterModel> allEnhancedFilters;
  final bool requireFavorites;

  RetrieveFiltersFromSPParams({
    required this.allEnhancedFilters,
    this.requireFavorites = false,
  });
}
