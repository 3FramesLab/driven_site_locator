part of filter_module;

class QuickFilterButton extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();
  final EnhancedFilterController filterController = Get.find();
  final void Function(SiteFilter, bool) onFilterIconTapped;
  final SiteFilter siteFilter;

  QuickFilterButton({
    required this.onFilterIconTapped,
    required this.siteFilter,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quickFilterOptions = SiteLocatorConfig.quickFilterOptions;
    return Obx(
      () {
        return Semantics(
          container: true,
          label: SemanticStrings.quickFilterButton,
          child: Padding(
            padding: EdgeInsets.only(
              left: siteFilter == quickFilterOptions.first
                  ? DrivenDimensions.dp16
                  : 0,
              right: siteFilter == quickFilterOptions.last
                  ? DrivenDimensions.dp16
                  : 0,
            ),
            child: GestureDetector(
              onTap: () => onFilterIconTapped(
                siteFilter,
                siteLocatorController.isShowLoading(),
              ),
              child: _getQuickFilterButton(),
            ),
          ),
        );
      },
    );
  }

  Widget _getQuickFilterButton() => CustomCardWithShadow(
        child: Container(
          key: Key(siteFilter.key),
          height: SiteLocatorConstants.quickFilterButtonHeight,
          decoration: _getBoxDecoration(),
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
          child: filterButtonText(),
        ),
      );

  BoxDecoration _getBoxDecoration() => BoxDecoration(
        color: _boxBackgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(45),
        ),
      );

  Widget filterButtonText() => Center(
        child: Text(
          siteFilter.label,
          style: _getTextStyle,
        ),
      );

  TextStyle get _getTextStyle =>
      isSiteFilterSelected ? f16SemiBoldWhite : f16BoldBlackDark;

  Color get _boxBackgroundColor =>
      isSiteFilterSelected ? Colors.black : Colors.white;

  bool get isSiteFilterSelected =>
      filterController.selectedSiteFilters.contains(siteFilter);
}
