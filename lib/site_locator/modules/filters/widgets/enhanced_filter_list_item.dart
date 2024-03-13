part of filter_module;

class EnhancedFilterListItem extends StatelessWidget {
  final EnhancedFilterController _filterController = Get.find();
  final EnhancedFilterModel enhancedFilter;

  EnhancedFilterListItem({
    required this.enhancedFilter,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _themeData(context),
      child: _buildContainer(),
    );
  }

  Widget _buildContainer() {
    return kIsWeb
        ? Container(
            width: 375,
            child: _expansionTile(),
          )
        : _expansionTile();
  }

  ExpansionTile _expansionTile() {
    return ExpansionTile(
      key: PageStorageKey(enhancedFilter.filterHeader),
      maintainState: true,
      title: _titleText,
      onExpansionChanged: (value) => onExpansionChanged(isExpand: value),
      children: _buildExpansionContent,
    );
  }

  void onExpansionChanged({bool? isExpand}) {
    if (enhancedFilter.serviceType == ServiceTypeEnum.fuelBrand) {
      if (!(isExpand ?? true)) {
        _filterController.initFuelBrandData();
        SiteLocatorUtils.hideKeyboard();
      }
    } else if (isExpand ?? false) {
      SiteLocatorUtils.hideKeyboard();
    }
  }

  Widget get _titleText => kIsWeb
      ? Align(
          child: Text(
          enhancedFilter.filterHeader,
          style: f16SemiboldBlack,
        ))
      : Text(enhancedFilter.filterHeader);

  List<Widget> get _buildExpansionContent {
    if (enhancedFilter.serviceType == ServiceTypeEnum.fuelBrand) {
      return [FuelBrandFilterView(siteFilters: enhancedFilter.filterItems)];
    } else {
      return _children;
    }
  }

  List<Widget> get _children => enhancedFilter.filterItems
      .map(
        (filter) => EnhancedFilterCheckbox(filter: filter),
      )
      .toList();

  ThemeData _themeData(BuildContext context) => Theme.of(context).copyWith(
        dividerColor: SiteLocatorColors.transparent,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: SiteLocatorColors.black,
        ),
      );
}
