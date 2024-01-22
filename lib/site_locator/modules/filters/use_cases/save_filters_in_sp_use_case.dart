part of filter_module;

class SaveFiltersInSPUseCase extends BaseFutureUseCase<bool, List<SiteFilter>> {
  SaveFiltersInSPUseCase();

  @override
  Future<bool>? execute(List<SiteFilter> param) {
    final selectedFilterKeys = param.map((filter) => filter.key).toList();

    return PreferenceUtils.setStringList(
      SiteLocatorStorageKeys.selectedSiteFilters,
      value: selectedFilterKeys,
    );
  }
}
