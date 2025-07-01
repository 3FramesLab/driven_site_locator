part of sl_list_module;

class RecentListView extends StatelessWidget {
  final ScrollController? scrollController;
  final siteLocatorController = Get.find<SLSiteLocatorController>();

  RecentListView({
    this.scrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: siteLocatorController.recentViewSiteLocations.length,
        padding: EdgeInsets.zero,
        controller: scrollController,
        itemBuilder: (context, index) {
          return SLCard(
            siteLocation: siteLocatorController.recentViewSiteLocations[index],
            index: index,
            showPrice: false,
          );
        },
      ),
    );
  }
}
