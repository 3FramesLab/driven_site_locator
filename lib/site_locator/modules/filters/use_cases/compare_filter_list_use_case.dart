part of filter_module;

class CompareFilterListUseCase
    extends BaseUseCase<bool, CompareFilterListParams> {
  CompareFilterListUseCase();

  @override
  bool execute(CompareFilterListParams param) {
    final selectedFilter = param.selectedFilter.map((e) => e.key).toList();
    final storedFilter = param.storedFilter.map((e) => e.key).toList();

    selectedFilter.sort();
    storedFilter.sort();

    return listEquals(selectedFilter, storedFilter);
  }
}

class CompareFilterListParams {
  final List<SiteFilter> selectedFilter;
  final List<SiteFilter> storedFilter;

  CompareFilterListParams({
    required this.selectedFilter,
    required this.storedFilter,
  });
}
