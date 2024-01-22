part of list_view_module;

class SiteLocationsListViewPage extends StatelessWidget {
  final SiteLocatorController controller = Get.find();
  final SearchPlacesController searchPlacesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: SiteLocatorScaffold(
          backgroundColor: Colors.white,
          body: Obx(
            () {
              return controller.isInitialListLoading()
                  ? const ListViewCardShimmer()
                  : _displaySiteLocationCardList();
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget get _appBar => DrivenAppBar(
        backgroundColor: Colors.white,
        leading: BackToMapButton(onPressed: _popPage),
      );

  Widget _displaySiteLocationCardList() {
    final int present = controller.presentPageIndex();
    final originalItems = controller.siteLocations ?? [];
    final items = controller.listViewItems();
    final itemCount =
        (present <= originalItems.length) ? items.length + 1 : items.length;
    return Stack(
      children: [
        Column(
          children: [
            _appBar,
            _filterSearchTextField(),
            const SizedBox(height: 12),
            Expanded(child: _siteLocationCards(items, itemCount)),
            const SizedBox(height: 32),
          ],
        ),
        SiteInfoSlidingPanel(showExtraData: true),
      ],
    );
  }

  Widget _filterSearchTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
      child: Row(
        children: [
          Expanded(child: _searchPlaceTextField),
          const SizedBox(width: 8),
          SitesListFilterButton(),
        ],
      ),
    );
  }

  Widget get _searchPlaceTextField => const SearchPlaceTextField();

  Widget _siteLocationCards(List<SiteLocation> items, int itemCount) {
    if (items.isEmpty) {
      return NoLocationsFound();
    } else {
      return ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return (index == items.length)
              ? ViewMoreSitesButton()
              : SiteLocationInfoCard(items[index], index);
        },
      );
    }
  }

  Future<bool> _onWillPop() async {
    _popPage();
    return Future.value(false);
  }

  void _popPage() {
    if (controller.locationPanelController.isPanelOpen) {
      controller.locationPanelController.close();
    } else {
      Get.back();
    }
  }
}
