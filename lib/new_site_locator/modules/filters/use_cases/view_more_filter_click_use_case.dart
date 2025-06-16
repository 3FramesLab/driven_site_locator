part of sl_filter_module;

class ViewMoreFilterClickUseCase
    extends BaseUseCase<void, ViewMoreFilterClickParam> {
  @override
  void execute(ViewMoreFilterClickParam param) {
    final selectedFilterIsViewMoreClicked =
        param.selectedFilterIsViewMoreClicked;
    final filterDisplayList = param.filterDisplayList;
    final selectedFiltersAllFilters = param.selectedFiltersAllFilters;
    final selectedFilterViewMoreIndex = param.selectedFilterViewMoreIndex;

    if (selectedFilterIsViewMoreClicked) {
      filterDisplayList.clear();
      filterDisplayList().addAll(
        selectedFiltersAllFilters.sublist(0, selectedFilterViewMoreIndex + 1),
      );
    } else {
      filterDisplayList.value =
          selectedFiltersAllFilters.map(NewSiteFilter.clone).toList();
      final _viewMoreFilter =
          filterDisplayList.removeAt(selectedFilterViewMoreIndex);
      filterDisplayList.add(_viewMoreFilter);
    }
  }
}

class ViewMoreFilterClickParam {
  final bool selectedFilterIsViewMoreClicked;
  final RxList<NewSiteFilter> filterDisplayList;
  final List<NewSiteFilter> selectedFiltersAllFilters;
  final int selectedFilterViewMoreIndex;

  ViewMoreFilterClickParam({
    required this.selectedFilterIsViewMoreClicked,
    required this.filterDisplayList,
    required this.selectedFiltersAllFilters,
    required this.selectedFilterViewMoreIndex,
  });
}
