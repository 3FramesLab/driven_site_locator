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
      }
    }
    return filterList;
  }
}

class ChangeFilterStatusParams {
  final List<EnhancedFilterModel> filterList;
  final SiteFilter siteFilter;
  final bool isChecked;

  ChangeFilterStatusParams({
    required this.filterList,
    required this.siteFilter,
    required this.isChecked,
  });
}
