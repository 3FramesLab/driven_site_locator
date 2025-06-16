part of sl_filter_module;

class FilterOptionClickUseCase
    extends BaseUseCase<void, FilterOptionClickParam> {
  @override
  void execute(FilterOptionClickParam param) {
    final isRadioButton = param.isRadioButton;
    final selectedFilterKeysBeforeApplying =
        param.selectedFilterKeysBeforeApplying;
    final siteFilter = param.siteFilter;
    final equality = param.equality;

    if (isRadioButton) {
      // single check in a group.
      selectedFilterKeysBeforeApplying.clear();
      selectedFilterKeysBeforeApplying.add(siteFilter.keys);
    } else {
      // multiple check in a group.
      if (selectedFilterKeysBeforeApplying
          .any((list) => equality.equals(list, siteFilter.keys))) {
        selectedFilterKeysBeforeApplying
            .removeWhere((list) => equality.equals(list, siteFilter.keys));
      } else {
        selectedFilterKeysBeforeApplying.add(siteFilter.keys);
      }
    }
  }
}

class FilterOptionClickParam {
  final bool isRadioButton;
  final RxList<List<String>> selectedFilterKeysBeforeApplying;
  final NewSiteFilter siteFilter;
  final DeepCollectionEquality equality;

  FilterOptionClickParam({
    required this.isRadioButton,
    required this.selectedFilterKeysBeforeApplying,
    required this.siteFilter,
    required this.equality,
  });
}
