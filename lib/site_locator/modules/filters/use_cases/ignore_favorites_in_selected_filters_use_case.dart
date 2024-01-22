part of filter_module;

class IgnoreFavoritesInSelectedFiltersUseCase
    extends BaseUseCase<List<SiteFilter>, List<SiteFilter>> {
  @override
  List<SiteFilter> execute(List<SiteFilter> param) {
    param.removeWhere((e) => e.key == QuickFilterKeys.favorites);

    return param;
  }
}
