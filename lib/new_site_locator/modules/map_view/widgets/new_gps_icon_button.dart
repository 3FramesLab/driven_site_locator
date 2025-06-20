part of map_view_module;

class NewGpsIconButton extends StatelessWidget {
  final Function()? onGpsIconTap;
  final SiteLocatorController siteLocatorController = Get.find();

  NewGpsIconButton({
    this.onGpsIconTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return siteLocatorController.gpsIconButtonVisible()
            ? Container(
                width: 50,
                margin: const EdgeInsets.only(right: 10),
                child: Semantics(
                  container: true,
                  label: SLSemanticStrings.gpsIconButton,
                  child: ElevatedButton(
                    onPressed: _onGpsTap,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                      backgroundColor: Colors.white,
                    ),
                    child: Image.asset(SLAssets.currentLocationButtonIcon),
                  ),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }

  void _onGpsTap() {
    if (siteLocatorController.isShowLoading()) {
      return;
    }
    onGpsIconTap?.call();
  }
}
