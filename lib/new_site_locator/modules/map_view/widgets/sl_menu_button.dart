part of map_view_module;

class SLMenuButton extends StatelessWidget {
  final SLSiteLocatorController siteLocatorController = Get.find();

  SLMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return !DrivenSiteLocator.instance.isUserAuthenticated
        ? Obx(
            () => siteLocatorController.menuButtonVisible()
                ? Container(
                    width: 50,
                    margin: const EdgeInsets.only(right: 10),
                    child: Semantics(
                      container: true,
                      label: SLSemanticStrings.gpsIconButton,
                      child: ElevatedButton(
                        onPressed:
                            DrivenSiteLocator.instance.onMapMenuButtonTap,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                          backgroundColor: Colors.white,
                        ),
                        child: const Icon(
                          Icons.menu,
                          color: DrivenColors.primary,
                          size: 26,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          )
        : const SizedBox.shrink();
  }
}
