part of sl_list_module;

class SLListViewPage extends StatelessWidget {
  final SLSiteLocatorController siteLocatorController = Get.find();
  final ScrollController? scrollController;

  SLListViewPage({
    this.scrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DrivenScaffold(
        backgroundColor: DrivenColors.white,
        appBar: siteLocatorController.isListViewOpenedFull() ? _appBar : null,
        body: ListTabBarView(scrollController: scrollController),
      ),
    );
  }

  PreferredSizeWidget get _appBar => DrivenAppBar(
        backgroundColor: DrivenColors.white,
        leading: DrivenBackButton(
          onPressed: () {
            siteLocatorController.isListViewOpenedFull(false);
            siteLocatorController.listViewPanelController.close();
          },
        ),
        title: Align(
          alignment: _appBarTitleAlignment,
          child: SLHeader(
            padding: const EdgeInsets.only(right: 6),
            fleetChangeCallback: _fleetChangeCallback,
          ),
        ),
        actions: [if (DcSiteLocatorUtils.isGuest) AddCard()],
      );

  AlignmentGeometry get _appBarTitleAlignment {
    return DcSiteLocatorUtils.isGuest
        ? Alignment.centerLeft
        : Alignment.centerRight;
  }

  Future<void> _fleetChangeCallback() async {
    siteLocatorController.recentViewSiteLocations.clear();
    siteLocatorController.isListViewOpenedFull(false);
    await siteLocatorController.listViewPanelController.close();
    await DcSiteLocatorUtils.callMerchSitesOnFilterChange();
  }
}
