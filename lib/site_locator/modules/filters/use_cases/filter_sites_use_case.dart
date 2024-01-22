part of filter_module;

class FilterSitesUseCase
    extends BaseUseCase<List<SiteLocation>, FilterSiteParams> {
  @override
  List<SiteLocation> execute(FilterSiteParams param) {
    final List<SiteLocation> filteredList = param.locations ?? [];
    if (param.quickFilters.isNotEmpty) {
      for (final filterType in param.quickFilters) {
        switch (filterType) {
          case QuickFilters.fuel:
            return filteredList
                .where((site) => site.locationType?.fuelStation == Status.Y)
                .toList();
          case QuickFilters.service:
            return filteredList
                .where(
                    (site) => site.locationType?.maintenanceService == Status.Y)
                .toList();
          case QuickFilters.discounts:
            return filteredList
                .where(
                    (site) => site.locationType?.fmDiscountNetwork == Status.Y)
                .toList();
          case QuickFilters.gallonUp:
            return filteredList
                .where((site) => site.locationType?.gallonUp == Status.Y)
                .toList();
          case QuickFilters.favorites:
            return filteredList
                .where((site) =>
                    param.favoriteList.contains(site.siteIdentifier.toString()))
                .toList();
        }
      }
    }
    return filteredList;
  }
}
