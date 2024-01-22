part of map_view_module;

class WelcomeMapView extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();

  WelcomeMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: siteLocatorController.onMapViewTap,
      child: AbsorbPointer(
        child: SizedBox(
          height: Get.height * 0.4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Obx(() {
              return Stack(
                children: [
                  _welcomeMapView(),
                  _loadingIndicator(),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _welcomeMapView() =>
      SiteLocatorMapUI(siteLocatorController: siteLocatorController);

  Widget _loadingIndicator() => siteLocatorController.isShowLoading()
      ? const Center(
          child: CupertinoActivityIndicator(radius: 20),
        )
      : const SizedBox();
}
