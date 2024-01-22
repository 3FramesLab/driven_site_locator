part of map_view_module;

class GpsIconButton extends StatelessWidget {
  final Function()? onGpsIconTap;
  GpsIconButton({Key? key, this.onGpsIconTap}) : super(key: key);

  final SiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: siteLocatorController.gpsIconButtonVisible(),
          child: Positioned(
            right: DrivenDimensions.dp16,
            bottom: siteLocatorController.floatingButtonsBottomPosition(),
            child: Semantics(
              container: true,
              label: SemanticStrings.gpsIconButton,
              child: GestureDetector(
                onTap: onGpsIconTap,
                child: Image.asset(SiteLocatorAssets.gpsIcon),
              ),
            ),
          ),
        ));
  }
}
