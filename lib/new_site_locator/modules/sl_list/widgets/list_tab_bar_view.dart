part of sl_list_module;

class ListTabBarView extends StatefulWidget {
  final ScrollController? scrollController;

  const ListTabBarView({
    this.scrollController,
    super.key,
  });

  @override
  State<ListTabBarView> createState() => _ListTabBarViewState();
}

class _ListTabBarViewState extends State<ListTabBarView>
    with TickerProviderStateMixin {
  late TabController tabController;
  final siteLocatorController = Get.find<SLSiteLocatorController>();
  final siteLocationListTabs = DcSiteLocatorUtils.siteLocationListTabs();
  static final entitlementRepository = SiteLocatorEntitlementUtils.instance;

  @override
  void initState() {
    tabController = TabController(
      length: siteLocationListTabs.length,
      vsync: this,
      initialIndex: siteLocatorController.selectedListTabIndex,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: siteLocationListTabs.length,
      child: Column(
        children: [
          _searchTextField(),
          _tabView,
          Expanded(child: _tabBarView),
        ],
      ),
    );
  }

  Widget get _tabView => TabBar(
        controller: tabController,
        labelStyle: f16SemiboldPrimary,
        unselectedLabelStyle: f16SemiBoldGrey,
        onTap: (value) {
          siteLocatorController.selectedListTabIndex = value;
          setState(() => tabController.animateTo(value));
          if (!siteLocatorController.isListViewOpenedFull()) {
            siteLocatorController.isListViewOpenedFull(true);
            siteLocatorController.listViewPanelController.open();
          }
        },
        indicator: const BoxDecoration(),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        tabs: _tabs(),
      );

  Widget get _tabBarView => TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: _tabViewChildren(),
      );

  Widget _searchTextField() => Obx(
        () => siteLocatorController.isListViewOpenedFull()
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SearchPlaceTextField(
                  currentLocation: _getLatLngAsString(),
                  hasShadow: false,
                ),
              )
            : const SizedBox(),
      );

  String _getLatLngAsString() => [
        siteLocatorController.currentLocation().latitude,
        siteLocatorController.currentLocation().longitude
      ].join(',');

  List<Widget> _tabs() {
    final List<Widget> tabs = [];
    for (int i = 0; i < siteLocationListTabs.length; i++) {
      tabs.add(Obx(
        () => _tabBar(
          label: siteLocationListTabs[i].title,
          position: i,
          siteLocations: DcSiteLocatorUtils.getSortedList(
            siteLocatorController: siteLocatorController,
            listViewSorting: siteLocationListTabs[i].sorting,
          ),
        ),
      ));
    }
    return tabs;
  }

  Widget _tabBar({
    required String label,
    required int position,
    required List<SiteLocation> siteLocations,
  }) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: tabController.index == position
                ? DrivenColors.primary
                : DrivenColors.disabledButtonTextColor,
            width: 3,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text('$label (${siteLocations.length})'),
    );
  }

  List<Widget> _tabViewChildren() {
    final List<Widget> tabViews = [];
    try {
      if (entitlementRepository.isCheapestTabEnabled) {
        tabViews.add(SortListView(
          listViewSorting: ListViewSorting.cheapest,
          scrollController: widget.scrollController,
        ));
      }
      if (entitlementRepository.isNearbyTabEnabled) {
        tabViews.add(SortListView(
          listViewSorting: ListViewSorting.nearby,
          scrollController: widget.scrollController,
        ));
      }
      if (entitlementRepository.isBestRatedTabEnabled) {
        tabViews.add(SortListView(
          listViewSorting: ListViewSorting.bestRated,
          scrollController: widget.scrollController,
        ));
      }
      if (entitlementRepository.isRecentTabEnabled) {
        tabViews.add(RecentSiteListView());
      }
    } catch (_) {}
    return tabViews;
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose(); // Then call super.dispose()
  }
}
