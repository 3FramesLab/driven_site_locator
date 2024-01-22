part of filter_module;

class ClearAllFiltersUseCase extends BaseNoParamFutureUseCase<bool> {
  ClearAllFiltersUseCase();

  @override
  Future<bool> execute() async {
    return PreferenceUtils.deleteByKey(
      SiteLocatorStorageKeys.selectedSiteFilters,
    );
  }
}
