part of map_view_module;

class GpsIconButton extends StatelessWidget {
  final Function()? onGpsIconTap;
  GpsIconButton({Key? key, this.onGpsIconTap}) : super(key: key);

  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => (siteLocatorController.showUIControls())
        ? Visibility(
            visible: siteLocatorController.gpsIconButtonVisible(),
            child: Positioned(
              right: 6,
              bottom: 130,
              child: Container(
                width: 50,
                margin: const EdgeInsets.only(right: 10),
                child: Semantics(
                  container: true,
                  label: SLSemanticStrings.gpsIconButton,
                  child: ElevatedButton(
                    onPressed: onGpsTap,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                      backgroundColor: Colors.white,
                    ),
                    child: Image.asset(AdminAssets.currentLocationButtonIcon),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink());
  }

  void onGpsTap() {
    if (siteLocatorController.isShowLoading()) {
      return;
    }
    onGpsIconTap?.call();
  }
}
