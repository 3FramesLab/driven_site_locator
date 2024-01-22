part of filter_module;

mixin EnhanceFilterState {
  final allEnhancedFilters = <EnhancedFilterModel>[].obs;
  final selectedSiteFilters = <SiteFilter>[].obs;
  final showMoreFuelBrands = false.obs;
  final fuelBrandTextController = TextEditingController();
  final storedSiteFilters = <SiteFilter>[];

  final _filterSessionManager = SiteFilterSessionManager();
  final siteLocatorController = Get.find<SiteLocatorController>();

  RxBool isFilterStatusChange = false.obs;
  RxBool isFuelBrandSearchTextEmpty = true.obs;
  final RxList<SiteFilter> storedNewlyAddedSiteFilters = <SiteFilter>[].obs;
  RxBool isFavOptionSelectedLastTime = false.obs;
  RxBool isFavoriteQuickFilterOptionSelected = false.obs;
  RxBool isApplyFilterButtonTapped = false.obs;
  final List<SiteFilter> _fuelBrandFilterList = [];
  bool isClearAllClick = false;

  late TreatFavoriteForApplyFilterUseCase treatFavoriteForApplyFilterUseCase;
  late TreatFavoriteForRemoveNewlyAddedFilterUseCase
      treatFavoriteForRemoveNewlyAddedFilterUseCase;
  late ChangeFilterStatusUseCase changeFilterStatusUseCase;
  late SaveFiltersInSPUseCase saveFiltersInSPUseCase;
  late RetrieveFiltersFromSPUseCase retrieveFiltersFromSPUseCase;
  late CompareFilterListUseCase compareFilterListUseCase;
  late ClearAllFiltersUseCase clearAllFiltersUseCase;
  late SyncEnhancedFilterUseCase syncEnhancedFilterUseCase;
  late IgnoreFavoritesInSelectedFiltersUseCase
      ignoreFavoritesInSelectedFiltersUseCase;
  late UpdateSelectedSiteFiltersWithFavoritesUseCase
      updateSelectedSiteFiltersWithFavoritesUseCase;
  late GetFuelTypeFiltersUseCase getFuelTypeFiltersUseCase;
  late CloneFuelBrandsUseCase _cloneFuelBrandsUseCase;
  late GetTopVisibleFuelBrandsUseCase _getTopVisibleFuelBrandsUseCase;
  late ShowOrHideFuelBrandsUseCase _showOrHideFuelBrandsUseCase;
  late SearchFuelBrandsUseCase _searchFuelBrandsUseCase;
}
