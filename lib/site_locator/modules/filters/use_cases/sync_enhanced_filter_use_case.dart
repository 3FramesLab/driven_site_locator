part of filter_module;

class SyncEnhancedFilterUseCase extends BaseFutureUseCase<
    SyncEnhancedFilterResponse, SyncEnhancedFilterParams> {
  @override
  Future<SyncEnhancedFilterResponse>? execute(
      SyncEnhancedFilterParams param) async {
    final selectedQuickFilter = param.selectedQuickFilter;
    final selectedFilters = param.selectedFilters;
    final allEnhancedFilters = param.allEnhancedFilters;
    final trackNewlyAddedFiltersFunction = param.trackNewlyAddedFiltersFunction;

    final allSiteFilters =
        allEnhancedFilters.expand((e) => e.filterItems).toList();

    final siteFilter = allSiteFilters
        .firstWhereOrNull((e) => e.key == selectedQuickFilter.key);

    _updateSelectedSiteFilters(
      selectedFilters: selectedFilters,
      selectedQuickFilter: selectedQuickFilter,
      siteFilter: siteFilter,
    );
    await trackNewlyAddedFiltersFunction.call();
    await saveEnhancedFiltersToLocalStorage(
      selectedFilters.map((filter) => filter.key).toList(),
    );

    return SyncEnhancedFilterResponse(
      allEnhancedFilters: allEnhancedFilters,
    );
  }

  void _updateSelectedSiteFilters({
    required List<SiteFilter> selectedFilters,
    required SiteFilter? siteFilter,
    required SiteFilter selectedQuickFilter,
  }) {
    if (selectedFilters.contains(selectedQuickFilter)) {
      /// Only Location Type filter's label text is
      /// different in quick filter(Fuel) and enhanced filter(Fuel Station)
      if (siteFilter?.serviceType == ServiceTypeEnum.locationType) {
        selectedFilters.remove(
          _getSiteFilterOfLocationType(selectedQuickFilter.key),
        );
      } else {
        selectedFilters.remove(selectedQuickFilter);
      }
      siteFilter?.isChecked = false;
    } else {
      if (siteFilter?.serviceType == ServiceTypeEnum.locationType) {
        selectedFilters.add(
          _getSiteFilterOfLocationType(selectedQuickFilter.key),
        );
      } else {
        selectedFilters.add(selectedQuickFilter);
      }
      siteFilter?.isChecked = true;
    }
  }

  SiteFilter _getSiteFilterOfLocationType(String selectedQuickFilterKey) {
    return SiteFilters.locationTypeList
        .firstWhere((e) => e.key == selectedQuickFilterKey);
  }

  Future<void> saveEnhancedFiltersToLocalStorage(
    List<String> selectedFilterKeys,
  ) async {
    await PreferenceUtils.setStringList(
      SiteLocatorStorageKeys.selectedSiteFilters,
      value: selectedFilterKeys,
    );
  }
}

class SyncEnhancedFilterParams {
  final SiteFilter selectedQuickFilter;
  final List<EnhancedFilterModel> allEnhancedFilters;
  final List<SiteFilter> selectedFilters;
  final Function trackNewlyAddedFiltersFunction;

  SyncEnhancedFilterParams({
    required this.selectedQuickFilter,
    required this.allEnhancedFilters,
    required this.selectedFilters,
    required this.trackNewlyAddedFiltersFunction,
  });
}

class SyncEnhancedFilterResponse {
  final List<EnhancedFilterModel> allEnhancedFilters;

  SyncEnhancedFilterResponse({
    required this.allEnhancedFilters,
  });
}
