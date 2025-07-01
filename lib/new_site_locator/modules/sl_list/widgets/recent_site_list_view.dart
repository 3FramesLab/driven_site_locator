part of sl_list_module;

class RecentSiteListView extends StatelessWidget {
  final ScrollController? scrollController;
  final siteLocatorController = Get.find<SLSiteLocatorController>();

  RecentSiteListView({
    this.scrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _recentViewedText,
        Expanded(
          child: RecentListView(
            scrollController: scrollController,
          ),
        ),
      ],
    );
  }

  Widget get _recentViewedText => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: DrivenText(
          text: SLViewText.recentlyViewed,
          style: f18ExtraBoldBlack,
        ),
      );
}
