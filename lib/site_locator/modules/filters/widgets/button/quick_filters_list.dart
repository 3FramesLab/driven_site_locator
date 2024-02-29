part of filter_module;

class QuickFiltersList extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();
  final EnhancedFilterController filterController = Get.find();

  QuickFiltersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quickFilterOptions = SiteLocatorConfig.quickFilterOptions;
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: quickFilterOptions.length,
      separatorBuilder: (_, __) => _divider,
      itemBuilder: (context, index) =>
          _quickFilterListItem(quickFilterOptions, index),
    );
  }

  Widget _quickFilterListItem(quickFilterOptions, index) {
    return QuickFilterButton(
      onFilterIconTapped: _onQuickFilterTapped,
      siteFilter: quickFilterOptions[index],
    );
  }

  Future<void> _onQuickFilterTapped(
      SiteFilter siteFilter, bool isLoading) async {
    trackAction(
      _getTrackActionName(siteFilter),
      // // adobeCustomTag: AdobeTagProperties.mapView,
    );
    siteLocatorController.resetMapViewScreen();
    await filterController.trackNewlyAddedFilters();
    await siteLocatorController.setListViewInitializers();

    if (!isLoading) {
      siteLocatorController.canShow2CTA(false);
      siteLocatorController.clearSearchPlaceInput();
      await filterController.syncEnhancedFilter(siteFilter);
    }
  }

  Widget get _divider => const SizedBox(width: 8);

  String _getTrackActionName(SiteFilter siteFilter) =>
      'map view screen : ${siteFilter.label.toLowerCase()} filter enabled/applied click';
}
