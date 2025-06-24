part of sl_list_module;

class RecentListView extends StatelessWidget {
  final siteLocatorController = Get.find<SLSiteLocatorController>();

  RecentListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: siteLocatorController.recentViewSiteLocations.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return RecentListItem(
            siteLocation: siteLocatorController.recentViewSiteLocations[index],
            index: index,
          );
        },
      ),
    );
  }
}
