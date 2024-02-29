part of filter_module;

class ChangeFilterStatusUseCase
    extends BaseUseCase<List<EnhancedFilterModel>, ChangeFilterStatusParams> {
  ChangeFilterStatusUseCase();

  @override
  List<EnhancedFilterModel> execute(ChangeFilterStatusParams param) {
    final filterList = param.filterList;
    final selectedFilterHeader = filterList.firstWhereOrNull(
      (filter) => filter.serviceType == param.siteFilter.serviceType,
    );

    if (selectedFilterHeader != null) {
      final selectedSiteFilter =
          selectedFilterHeader.filterItems.firstWhereOrNull(
        (filter) => filter.key == param.siteFilter.key,
      );
      if (selectedSiteFilter != null) {
        selectedSiteFilter.isChecked = param.isChecked;
        _handleServiceTruckStopFilters(param);
      }
    }
    return filterList;
  }

  void _handleServiceTruckStopFilters(ChangeFilterStatusParams param) {
    if (AppUtils.isComdata &&
        (param.siteFilter.key == LocationTypeFilterKeys.service ||
            param.siteFilter.key == LocationTypeFilterKeys.truckStop)) {
      final locationTypeSiteFilters = param.filterList
          .firstWhere((element) =>
              element.filterHeader == SiteLocatorConstants.locationTypeHeading)
          .filterItems;

      if (param.siteFilter.key == LocationTypeFilterKeys.truckStop) {
        final serviceFilter = locationTypeSiteFilters.firstWhere(
            (element) => element.key == LocationTypeFilterKeys.service);
        serviceFilter.isChecked = false;
        param.selectedFiltersList?.remove(serviceFilter);
      }

      if (param.siteFilter.key == LocationTypeFilterKeys.service) {
        final truckStopFilter = locationTypeSiteFilters.firstWhere(
            (element) => element.key == LocationTypeFilterKeys.truckStop);
        truckStopFilter.isChecked = false;
        param.selectedFiltersList?.remove(truckStopFilter);
      }
    }
  }
}

class ChangeFilterStatusParams {
  final List<EnhancedFilterModel> filterList;
  final SiteFilter siteFilter;
  final bool isChecked;
  final RxList<SiteFilter>? selectedFiltersList;

  ChangeFilterStatusParams({
    required this.filterList,
    required this.siteFilter,
    required this.isChecked,
    this.selectedFiltersList,
  });
}
