part of sl_list_module;

class SortListView extends StatefulWidget {
  final ScrollController? scrollController;
  final ListViewSorting listViewSorting;

  const SortListView({
    required this.listViewSorting,
    this.scrollController,
    super.key,
  });

  @override
  State<SortListView> createState() => _SortListViewState();
}

class _SortListViewState extends State<SortListView> {
  final SLSiteLocatorController siteLocatorController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => siteLocatorController.isListLoading()
          ? const ListViewCardShimmer()
          : _listView,
    );
  }

  Widget get _listView => Obx(
        () {
          final siteLocations = getSortedList();
          if (siteLocations.isEmpty) {
            return _noLocationFoundColumn;
          }
          return ListView.builder(
            key: const Key('best_rated_list_view'),
            itemCount: siteLocations.length,
            controller: widget.scrollController,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return SLCard(
                siteLocation: siteLocations[index],
                index: index,
              );
            },
          );
        },
      );

  List<SiteLocation> getSortedList() {
    return DcSiteLocatorUtils.getSortedList(
      siteLocatorController: siteLocatorController,
      listViewSorting: widget.listViewSorting,
    );
  }

  Widget get _noLocationFoundColumn => const Padding(
        padding: EdgeInsets.only(left: 16, right: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              SLViewText.noTruckStopFound,
              style: f16ExtraBoldBlack,
              textScaler: TextScaler.linear(1),
            ),
            Text(
              SLViewText.noTruckStopFoundDesc,
              style: f14SemiBoldBlack,
              textScaler: TextScaler.linear(1),
            )
          ],
        ),
      );
}
