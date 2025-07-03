part of map_view_module;

class MapActionButtons extends StatelessWidget {
  final Function()? onGpsIconTap;
  final SLSiteLocatorController siteLocatorController = Get.find();

  MapActionButtons({
    this.onGpsIconTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return siteLocatorController.gpsIconButtonVisible()
          ? _content
          : const SizedBox.shrink();
    });
  }

  Widget get _content {
    return Positioned(
      right: 6,
      bottom: DrivenSiteLocator.instance.isUserAuthenticated
          ? (DrivenSiteLocator.instance.getBottomNavBarHeight() + 10)
          : 10,
      child: Column(
        children: [
          SearchIconButton(),
          const SizedBox(height: 8),
          NewGpsIconButton(onGpsIconTap: onGpsIconTap),
        ],
      ),
    );
  }
}
