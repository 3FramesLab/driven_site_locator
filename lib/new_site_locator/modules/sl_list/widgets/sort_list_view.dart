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
          return ListView.builder(
            key: const Key('best_rated_list_view'),
            itemCount: siteLocations.length,
            controller: widget.scrollController,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return SLCard(siteLocations[index], index);
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
}
