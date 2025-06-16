part of sl_list_module;

class SLListPanelView extends StatefulWidget {
  final ScrollController scrollController;

  const SLListPanelView({
    required this.scrollController,
    Key? key,
  }) : super(key: key);
  @override
  State<SLListPanelView> createState() => _SLListPanelViewState();
}

class _SLListPanelViewState extends State<SLListPanelView> {
  final SiteLocatorController siteLocatorController = Get.find();
  late ScrollController listScrollController;

  @override
  void initState() {
    super.initState();
    listScrollController = widget.scrollController
      ..addListener(listViewScrollEventListener);
  }

  void listViewScrollEventListener() =>
      siteLocatorController.listViewScrollHandler(listScrollController);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => siteLocatorController.isListViewOpenedFull()
          ? SLListViewPage(scrollController: listScrollController)
          : ListTabBarView(scrollController: listScrollController),
    );
  }
}
