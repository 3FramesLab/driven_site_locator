// ignore_for_file: prefer_foreach

part of filter_module;

class EnhancedFilterController extends GetxController with EnhanceFilterState {
  @override
  void onInit() {
    super.onInit();
    _initUseCases();
    initData();
  }

  void _initUseCases() {
    treatFavoriteForApplyFilterUseCase =
        Get.put(TreatFavoriteForApplyFilterUseCase());
    treatFavoriteForRemoveNewlyAddedFilterUseCase =
        Get.put(TreatFavoriteForRemoveNewlyAddedFilterUseCase());
    changeFilterStatusUseCase = Get.put(ChangeFilterStatusUseCase());
    saveFiltersInSPUseCase = Get.put(SaveFiltersInSPUseCase());
    retrieveFiltersFromSPUseCase = Get.put(RetrieveFiltersFromSPUseCase());
    compareFilterListUseCase = Get.put(CompareFilterListUseCase());
    clearAllFiltersUseCase = Get.put(ClearAllFiltersUseCase());
    syncEnhancedFilterUseCase = Get.put(SyncEnhancedFilterUseCase());
    ignoreFavoritesInSelectedFiltersUseCase =
        Get.put(IgnoreFavoritesInSelectedFiltersUseCase());
    updateSelectedSiteFiltersWithFavoritesUseCase =
        Get.put(UpdateSelectedSiteFiltersWithFavoritesUseCase());
    getFuelTypeFiltersUseCase = Get.put(GetFuelTypeFiltersUseCase());
    _cloneFuelBrandsUseCase = Get.put(CloneFuelBrandsUseCase());
    _getTopVisibleFuelBrandsUseCase = Get.put(GetTopVisibleFuelBrandsUseCase());
    _showOrHideFuelBrandsUseCase = Get.put(ShowOrHideFuelBrandsUseCase());
    _searchFuelBrandsUseCase = Get.put(SearchFuelBrandsUseCase());
  }

  void initData() {
    _resetApplyAndClearButtonState();
    updateEnhancedFilterData();
    initFuelBrandData();
  }

  void initFuelBrandData() {
    _initFuelBrandFilterData();
    _clearFuelBrandSearchController();
    _showTopFuelBrands();
  }

  void _initFuelBrandFilterData() {
    _fuelBrandFilterList.clear();
    _fuelBrandFilterList.addAll(_cloneFuelBrandsUseCase.execute());
  }

  void _clearFuelBrandSearchController() {
    fuelBrandTextController.clear();
  }

  void _resetApplyAndClearButtonState() {
    isClearAllClick = false;
    isFilterStatusChange(false);
  }

  void updateEnhancedFilterData() {
    allEnhancedFilters.value = _cloneEnhancedFilterData;
    _getSavedFilters();
  }

  void _getSavedFilters() {
    _retrieveFiltersFromStorage();

    selectedSiteFilters.value = _cloneStoredFilters;
    _addFavoriteFilterToSelectedFilter();
    selectedSiteFilters.refresh();
  }

  List<SiteFilter> _fetchFiltersFromStorage() {
    final param = RetrieveFiltersFromSPParams(
      allEnhancedFilters: allEnhancedFilters,
    );
    return retrieveFiltersFromSPUseCase.execute(param);
  }

  void _retrieveFiltersFromStorage() {
    final param = RetrieveFiltersFromSPParams(
      allEnhancedFilters: allEnhancedFilters,
    );
    storedSiteFilters
        .clearAndAddAll(retrieveFiltersFromSPUseCase.execute(param));
  }

  void _addFavoriteFilterToSelectedFilter() {
    if (_filterSessionManager.isFavoriteFilterSelected) {
      selectedSiteFilters.add(favoriteQuickFilter);
    }
  }

  void onFilterCheckChange({
    required SiteFilter siteFilter,
    required bool isChecked,
  }) {
    allEnhancedFilters.value = changeFilterStatusUseCase.execute(
      ChangeFilterStatusParams(
        filterList: allEnhancedFilters(),
        siteFilter: siteFilter,
        isChecked: isChecked,
      ),
    );
    allEnhancedFilters.refresh();

    if (isChecked) {
      selectedSiteFilters.add(siteFilter);
    } else {
      selectedSiteFilters.remove(siteFilter);
    }
    selectedSiteFilters.refresh();

    _compareSelectedFilterWithSavedFilter();
  }

  void _compareSelectedFilterWithSavedFilter() {
    final isEqual = compareFilterListUseCase.execute(
      CompareFilterListParams(
        selectedFilter: selectedFiltersIgnoreFavorites,
        storedFilter: _cloneStoredFilters,
      ),
    );

    isFilterStatusChange(!isEqual);
  }

  void clearList() {
    initData();
  }

  void treatFavoriteOptionForApplyFilter() {
    final param = TreatFavoriteForApplyFilterUseCaseParams(
      isFavOptionSelectedLastTime: isFavOptionSelectedLastTime(),
      isFavoriteFilterSelected: _filterSessionManager.isFavoriteFilterSelected,
      selectedSiteFilters: selectedSiteFilters,
    );
    treatFavoriteForApplyFilterUseCase.execute(param);
  }

  void treatFavoriteOptionForRemoveNewlyAddedFilter(
      List<SiteFilter> filtersToReset) {
    final param = TreatFavoriteForRemoveNewlyAddedFilterParams(
      isFavOptionSelectedLastTime: isFavOptionSelectedLastTime(),
      isFavoriteQuickFilterOptionSelected:
          isFavoriteQuickFilterOptionSelected(),
      favoriteQuickFilter: favoriteQuickFilter,
      filtersToReset: filtersToReset,
    );
    treatFavoriteForRemoveNewlyAddedFilterUseCase.execute(param);
  }

  Future<void> onApplyFilterClick() async {
    isFavOptionSelectedLastTime(false);
    _validateMapPinsReGeneration();
    treatFavoriteOptionForApplyFilter();
    await trackNewlyAddedFilters();
    await saveFilterToLocalCache();

    _resetApplyAndClearButtonState();
    storedSiteFilters.clearAndAddAll(_cloneSelectedFiltersIgnoreFavorites);
    Get.back(result: {
      SiteLocatorRouteArguments.isEnhanceFilterApplied: true,
    });
    initData();

    applyFilter();
  }

  Future<void> saveFilterToLocalCache() async {
    await saveFiltersInSPUseCase.execute(selectedFiltersIgnoreFavorites);
  }

  Future<void> trackNewlyAddedFilters() async {
    final newlyAddedFilters = computeNewlyAddedFiltersOnUI();
    storedNewlyAddedSiteFilters(newlyAddedFilters);
  }

  Future<void> removeNewlyAddedFilter() async {
    final filtersToReset = resetExistingFilters();
    storedNewlyAddedSiteFilters([]);
    treatFavoriteOptionForRemoveNewlyAddedFilter(filtersToReset);
    await saveFiltersInSPUseCase.execute(filtersToReset);

    selectedSiteFilters(filtersToReset);
    selectedSiteFilters.refresh();
    storedSiteFilters.clearAndAddAll(_cloneSelectedFiltersIgnoreFavorites);

    initFuelBrandData();
    applyFilter();
    _compareSelectedFilterWithSavedFilter();
  }

  List<SiteFilter> resetExistingFilters() {
    final filtersFromStorage = _fetchFiltersFromStorage();
    final existingFiltersOnStorageData =
        List<SiteFilter>.from(filtersFromStorage);
    final newlyAdded = storedNewlyAddedSiteFilters();

    for (int i = existingFiltersOnStorageData.length; i >= 0; i--) {
      for (final SiteFilter element in newlyAdded) {
        existingFiltersOnStorageData.remove(element);
        onFilterCheckChange(siteFilter: element, isChecked: false);
      }
    }
    final computedFiltersToRemove =
        List<SiteFilter>.from(existingFiltersOnStorageData);
    return computedFiltersToRemove;
  }

  List<SiteFilter> computeNewlyAddedFiltersOnUI() {
    final filtersFromStorage = _fetchFiltersFromStorage();
    final existingFiltersOnStorageData =
        List<SiteFilter>.from(filtersFromStorage);
    final selectedFiltersToApply =
        List<SiteFilter>.from(selectedFiltersIgnoreFavorites);

    for (int i = selectedFiltersToApply.length; i >= 0; i--) {
      for (final SiteFilter element in existingFiltersOnStorageData) {
        selectedFiltersToApply.remove(element);
      }
    }
    final computedNewlyAddedFilters =
        List<SiteFilter>.from(selectedFiltersToApply);
    return computedNewlyAddedFilters;
  }

  void applyFilter() {
    try {
      siteLocatorController.selectedSiteFilters = _cloneSelectedFilters;
      siteLocatorController.filterSiteLocations();
      siteLocatorController.canShow2CTA(false);
      siteLocatorController.show2CTAButton(
          show2CTA: siteLocatorController.canShow2CTA());
    } catch (_) {}
  }

  void _validateMapPinsReGeneration() {
    siteLocatorController.isGenerateMapPinsOnFiltering =
        isFuelTypeFiltersPresent && isFuelTypeFiltersChanged;
  }

  bool get isFuelTypeFiltersPresent =>
      isSelectedSiteFilterHasFuelType || isStoredSiteFilterHasFuelType;

  bool get isSelectedSiteFilterHasFuelType => getFuelTypeFiltersUseCase
      .execute(GetFuelTypeFiltersParams(selectedSiteFilters))
      .isNotEmpty;

  bool get isStoredSiteFilterHasFuelType => getFuelTypeFiltersUseCase
      .execute(GetFuelTypeFiltersParams(storedSiteFilters))
      .isNotEmpty;

  bool get isFuelTypeFiltersChanged => !compareFilterListUseCase.execute(
        CompareFilterListParams(
          selectedFilter: getFuelTypeFiltersUseCase.execute(
            GetFuelTypeFiltersParams(selectedSiteFilters),
          ),
          storedFilter: getFuelTypeFiltersUseCase.execute(
            GetFuelTypeFiltersParams(storedSiteFilters),
          ),
        ),
      );

  Future<void> onClearAllClick() async {
    trackAction(
      AnalyticsTrackActionName.enhancedFiltersClearFiltersLinkClickEvent,
    );
    selectedSiteFilters.removeWhere((p) => p.key != QuickFilterKeys.favorites);
    selectedSiteFilters.refresh();
    _validateMapPinsReGenerationOnClearAll();
    await clearAllFiltersUseCase.execute();
    isFilterStatusChange(false);
    siteLocatorController.selectedSiteFilters
        .removeWhere((p) => p.key != QuickFilterKeys.favorites);
    storedSiteFilters.clearAndAddAll([]);
    clearList();
    isClearAllClick = true;
  }

  void _validateMapPinsReGenerationOnClearAll() {
    siteLocatorController.isGenerateMapPinsOnFiltering =
        getFuelTypeFiltersUseCase
            .execute(
              GetFuelTypeFiltersParams(storedSiteFilters),
            )
            .isNotEmpty;
  }

  Future<void> syncEnhancedFilter(SiteFilter siteFilter) async {
    if (siteFilter.key == QuickFilterKeys.favorites) {
      isApplyFilterButtonTapped(false);
      isFavoriteQuickFilterOptionSelected(
          !isFavoriteQuickFilterOptionSelected());
      isFavOptionSelectedLastTime(true);

      _handleFavoriteQuickFilter(siteFilter);
    } else {
      isFavOptionSelectedLastTime(false);
      final syncEnhancedFilterParams = SyncEnhancedFilterParams(
        selectedQuickFilter: siteFilter,
        allEnhancedFilters: allEnhancedFilters(),
        selectedFilters: selectedSiteFilters,
        trackNewlyAddedFiltersFunction: trackNewlyAddedFilters,
      );
      await syncEnhancedFilterUseCase.execute(syncEnhancedFilterParams);
      storedSiteFilters.clearAndAddAll(_cloneSelectedFiltersIgnoreFavorites);
    }
    applyFilter();
  }

  void _handleFavoriteQuickFilter(SiteFilter favoritesSiteFilter) {
    final params = UpdateSelectedSiteFiltersWithFavoritesParams(
      selectedSiteFilters: selectedSiteFilters,
      favoritesSiteFilter: favoritesSiteFilter,
    );

    updateSelectedSiteFiltersWithFavoritesUseCase.execute(params);
  }

  void applyFilterPreference() {
    initData();
    applyFilter();
  }

  void onFuelBrandSearchTextChanged(String? text) {
    final searchQuery = (text ?? '').trim().toLowerCase();

    final viewFuelBrand = allEnhancedFilters.firstWhereOrNull(
      (filter) => filter.serviceType == ServiceTypeEnum.fuelBrand,
    );

    viewFuelBrand?.filterItems.clear();
    isFuelBrandSearchTextEmpty(searchQuery.isEmpty);
    if (isFuelBrandSearchTextEmpty()) {
      _showTopFuelBrands();
      return;
    } else {
      viewFuelBrand?.filterItems.addAll(_searchFuelBrandsUseCase.execute(
        SearchFuelBrandsParams(
          searchQuery: searchQuery,
          fuelBrandFilterList: _fuelBrandFilterList,
        ),
      ));
    }
    _refreshFuelBrandFilter(viewFuelBrand);
  }

  void _showTopFuelBrands() {
    isFuelBrandSearchTextEmpty(true);
    showMoreFuelBrands(false);

    final viewFuelBrand = _getTopVisibleFuelBrandsUseCase.execute(
      GetTopVisibleFuelBrandsParams(
        allEnhancedFilters: allEnhancedFilters,
        fuelBrandFilterList: _fuelBrandFilterList,
      ),
    );
    _refreshFuelBrandFilter(viewFuelBrand);
  }

  void onFuelBrandClearSearchClick() {
    fuelBrandTextController.clear();
    _showTopFuelBrands();
  }

  void onShowHideFuelBrandClick() {
    showMoreFuelBrands(!showMoreFuelBrands());

    final viewFuelBrand =
        _showOrHideFuelBrandsUseCase.execute(ShowOrHideFuelBrandsParams(
      showMoreFuelBrands: showMoreFuelBrands(),
      allEnhancedFilters: allEnhancedFilters,
      fuelBrandFilterList: _fuelBrandFilterList,
    ));
    _refreshFuelBrandFilter(viewFuelBrand);
  }

  void _refreshFuelBrandFilter(EnhancedFilterModel? viewFuelBrand) {
    for (final siteFilter in viewFuelBrand?.filterItems ?? []) {
      if (selectedSiteFilters.contains(siteFilter)) {
        siteFilter.isChecked = true;
      }
    }
    allEnhancedFilters.refresh();
  }

  List<SiteFilter> get selectedFiltersIgnoreFavorites {
    return ignoreFavoritesInSelectedFiltersUseCase.execute(
      _cloneSelectedFilters,
    );
  }

  int get selectedFilterCount => selectedFiltersIgnoreFavorites.length;

  bool get showSelectedFilterInBadges => selectedFilterCount > 0;

  List<SiteFilter> get _cloneSelectedFilters =>
      selectedSiteFilters.map(SiteFilter.clone).toList();

  List<SiteFilter> get _cloneSelectedFiltersIgnoreFavorites =>
      selectedFiltersIgnoreFavorites.map(SiteFilter.clone).toList();

  List<SiteFilter> get _cloneStoredFilters =>
      storedSiteFilters.map(SiteFilter.clone).toList();

  List<EnhancedFilterModel> get _cloneEnhancedFilterData =>
      enhancedFilterData.map(EnhancedFilterModel.clone).toList();

  String get showOrHideFuelBrandLabel => showMoreFuelBrands()
      ? EnhancedFilterConstants.hideBrands
      : EnhancedFilterConstants.showMoreBrands;
}
