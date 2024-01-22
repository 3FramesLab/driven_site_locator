part of filter_module;

class UpdateSelectedSiteFiltersWithFavoritesUseCase
    extends BaseUseCase<void, UpdateSelectedSiteFiltersWithFavoritesParams> {
  @override
  void execute(UpdateSelectedSiteFiltersWithFavoritesParams param) {
    final _filterSessionManager = SiteFilterSessionManager();
    final selectedSiteFilters = param.selectedSiteFilters;
    final favoritesSiteFilter = param.favoritesSiteFilter;

    if (selectedSiteFilters.contains(favoritesSiteFilter)) {
      selectedSiteFilters.remove(favoritesSiteFilter);
      _filterSessionManager.isFavoriteFilterSelected = false;
    } else {
      selectedSiteFilters.add(favoritesSiteFilter);
      _filterSessionManager.isFavoriteFilterSelected = true;
    }
  }
}

class UpdateSelectedSiteFiltersWithFavoritesParams {
  final List<SiteFilter> selectedSiteFilters;
  final SiteFilter favoritesSiteFilter;

  UpdateSelectedSiteFiltersWithFavoritesParams({
    required this.selectedSiteFilters,
    required this.favoritesSiteFilter,
  });
}
