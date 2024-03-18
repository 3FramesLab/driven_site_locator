part of filter_module;

class FuelBrandFilterView extends StatelessWidget {
  final List<SiteFilter> siteFilters;

  const FuelBrandFilterView({
    required this.siteFilters,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _fuelBrandSearchField,
        _fuelBrandListView,
        _showOrHideText,
      ],
    );
  }

  Widget get _fuelBrandSearchField => const Padding(
        padding: EdgeInsets.symmetric(horizontal: DrivenDimensions.dp16),
        child: FuelBrandSearchField(),
      );

  Widget get _fuelBrandListView => siteFilters.isEmpty
      ? _searchCriteriaNotFound
      : ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          key: const PageStorageKey(SiteLocatorWidgetKeys.fuelBrandFilterList),
          children: _filterList,
        );

  Widget get _showOrHideText => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DrivenDimensions.dp16,
          vertical: DrivenDimensions.dp4,
        ),
        child: ShowMoreFuelBrands(),
      );

  List<Widget> get _filterList => siteFilters
      .map(
        (filter) => EnhancedFilterCheckbox(filter: filter),
      )
      .toList();

  Widget get _searchCriteriaNotFound => const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DrivenDimensions.dp16,
          vertical: DrivenDimensions.dp8,
        ),
        child: SearchCriteriaNotFound(),
      );
}
