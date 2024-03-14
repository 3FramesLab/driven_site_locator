part of filter_module;

class EnhancedFilterPage extends StatefulWidget {
  final Function()? onFilterBackButtonTap;

  const EnhancedFilterPage({
    this.onFilterBackButtonTap,
    Key? key,
  }) : super(key: key);

  @override
  State<EnhancedFilterPage> createState() => _EnhancedFilterPageState();
}

class _EnhancedFilterPageState extends State<EnhancedFilterPage> {
  final EnhancedFilterController filterController = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      filterController.initData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _popPage,
      child: SiteLocatorScaffold(
        backgroundColor: SiteLocatorColors.white,
        body: SafeArea(child: _bodyContent),
      ),
    );
  }

  Widget get _bodyContent => Column(
        crossAxisAlignment:
            kIsWeb ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          _scrollView,
          ApplyFilterButton(
              onFilterBackButtonTap: widget.onFilterBackButtonTap),
          ClearAllFilterButton(
              onFilterBackButtonTap: widget.onFilterBackButtonTap),
        ],
      );

  Widget get _scrollView => Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                kIsWeb ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              _backButton,
              BadgeView(),
              _filterList,
            ],
          ),
        ),
      );

  Widget get _backButton => Padding(
        padding: const EdgeInsets.all(16),
        child: DrivenBackButton(
          onPressed: _popPage,
          mainAxisSize: MainAxisSize.min,
        ),
      );

  Widget get _filterList => EnhancedFilterListView();

  Future<bool> _popPage() {
    trackAction(
      AnalyticsTrackActionName.enhancedFiltersBackLinkClickEvent,
      // // adobeCustomTag: AdobeTagProperties.enhancedFilters,
    );
    if (kIsWeb) {
      if (widget.onFilterBackButtonTap != null) {
        widget.onFilterBackButtonTap!();
      }
    } else {
      Get.back(
        result: {
          SiteLocatorRouteArguments.enhancedFilterClearStatus:
              filterController.isClearAllClick,
        },
      );
    }

    filterController.clearList();
    return Future.value(false);
  }
}
