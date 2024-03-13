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
      crossAxisAlignment:
          kIsWeb ? CrossAxisAlignment.center : CrossAxisAlignment.stretch,
      children: [
        _fuelBrandSearchField,
        _buildFuelBrandListViewContainer(),
        _showOrHideText,
      ],
    );
  }

  Widget _buildFuelBrandListViewContainer() {
    return kIsWeb
        ? Container(
            width: 375,
            child: _fuelBrandListView,
          )
        : _fuelBrandListView;
  }

  Widget get _fuelBrandSearchField => kIsWeb
      ? Container(
          width: 350,
          child: _buildSearchFieldWithPadding(),
        )
      : _buildSearchFieldWithPadding();

  Padding _buildSearchFieldWithPadding() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: DrivenDimensions.dp16),
      child: FuelBrandSearchField(),
    );
  }

  Widget get _fuelBrandListView => siteFilters.isEmpty
      ? _searchCriteriaNotFound
      : ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          key: const PageStorageKey(SiteLocatorWidgetKeys.fuelBrandFilterList),
          children: _filterList,
        );

  Widget get _showOrHideText => _buildShowMoreContainer();

  Widget _buildShowMoreContainer() {
    return kIsWeb
        ? Container(
            width: 375,
            child: _buildShowMoreBrands(),
          )
        : _buildShowMoreBrands();
  }

  Padding _buildShowMoreBrands() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DrivenDimensions.dp16,
        vertical: DrivenDimensions.dp4,
      ),
      child: ShowMoreFuelBrands(),
    );
  }

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
