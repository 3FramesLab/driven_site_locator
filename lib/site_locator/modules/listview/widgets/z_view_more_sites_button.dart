part of list_view_module;

class ViewMoreSitesLoadingProgress extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: canShowViewMoreSitesLoadingProgress(),
      child: Obx(
        () => Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          color: Colors.white,
          child: siteLocatorController.isViewMoreLoading()
              ? _loadingProgress()
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  bool canShowViewMoreSitesLoadingProgress() =>
      siteLocatorController.getSiteLocationsForListView().length >
      siteLocatorController.presentPageIndex();

  Widget _loadingProgress() {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 20, bottom: 50),
        height: 90,
        child: const ViewMoreSitesShimmer(),
      ),
    );
  }
}
