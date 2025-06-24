part of map_view_module;

class SearchThisAreaButton extends StatelessWidget {
  final SLSiteLocatorController siteLocatorController = Get.find();

  SearchThisAreaButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return (siteLocatorController.showUIControls())
          ? Visibility(
              visible: siteLocatorController.isShowSearchThisArea() &&
                  siteLocatorController.isLatLngBoundsChanged(),
              child: Positioned(
                width: 175,
                height: 50,
                left: 132,
                bottom: 130,
                child: FloatingMapButton(
                  semanticsLabel: SLSemanticStrings.searchThisArea,
                  key: const Key(SLSemanticStrings.searchThisArea),
                  icon: Icons.pin_drop_outlined,
                  label: SLInternalText.searchThisArea,
                  onPressed: siteLocatorController.onSearchThisAreaButtonTap,
                ),
              ),
            )
          : const SizedBox.shrink();
    });
  }
}
