part of sl_list_module;

class RecentSiteListView extends StatelessWidget {
  final siteLocatorController = Get.find<SiteLocatorController>();

  RecentSiteListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_recentViewedText, Expanded(child: RecentListView())],
    );
  }

  Widget get _recentViewedText => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: DrivenText(
          text: SLViewText.recentlyViewed,
          style: f18ExtraBoldBlack,
        ),
      );
}
