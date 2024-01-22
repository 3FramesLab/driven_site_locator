part of list_view_module;

class ViewMoreSitesButton extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: canShowViewMoreSitesButton(),
      child: Obx(
        () => Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          color: Colors.white,
          child: siteLocatorController.isViewMoreLoading()
              ? _loadingProgress()
              : _viewMoreSitesButton(),
        ),
      ),
    );
  }

  Widget _viewMoreSitesButton() {
    return TextButton(
      onPressed: siteLocatorController.listViewShowMoreHandler,
      child: const Text(
        SiteLocatorConstants.viewMoreSitesButtonLabel,
        style: f16SemiboldBlack2Underline,
      ),
    );
  }

  bool canShowViewMoreSitesButton() =>
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
