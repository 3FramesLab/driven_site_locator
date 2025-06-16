part of map_view_module;

class SearchThisAreaButtonWithLoader extends StatelessWidget {
  SearchThisAreaButtonWithLoader({super.key});

  final SiteLocatorController siteLocatorController = Get.find();
  final SitesLoadingProgressController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!siteLocatorController.firstTimeLoading()) {
        return Obx(
          () => (siteLocatorController.showUIControls())
              ? Visibility(
                  visible: controller.isMapPositionChanged() ||
                      (siteLocatorController.isShowSearchThisArea() &&
                          siteLocatorController.isLatLngBoundsChanged()),
                  child: Positioned(
                    left: 0,
                    right: 0,
                    bottom: 10,
                    child: SizedBox(
                      width: controller.buttonArea,
                      child: Center(
                        child: GestureDetector(
                          onTap: controller.onSearchThisAreaButtonTap,
                          child: Semantics(
                            container: true,
                            label: SLSemanticStrings.searchThisArea,
                            child: AnimatedContainer(
                              key: const Key(SLSemanticStrings.searchThisArea),
                              duration: controller.buttonWidthAnimationDuration,
                              curve: Curves.easeIn,
                              width: controller.buttonWidth.value,
                              height: controller.buttonHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: controller.completeMapLoader.value
                                    ? DrivenColors.primary
                                    : Colors.white,
                                border: controller.isLoading.value
                                    ? null
                                    : Border.all(
                                        color: DrivenColors.primary,
                                        width: 2,
                                      ),
                              ),
                              alignment: Alignment.center,
                              child: _buildChild(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        );
      } else {
        return const SizedBox.shrink();
      }
    });

    // return Obx(
    //   () => (siteLocatorController.showUIControls())
    //       ? Visibility(
    //           visible: controller.isMapPositionChanged() ||
    //               (siteLocatorController.isShowSearchThisArea() &&
    //                   siteLocatorController.isLatLngBoundsChanged()),
    //           child: Positioned(
    //             left: 0,
    //             right: 0,
    //             bottom: 130,
    //             child: SizedBox(
    //               width: controller.buttonArea,
    //               child: Center(
    //                 child: GestureDetector(
    //                   onTap: controller.onSearchThisAreaButtonTap,
    //                   child: Semantics(
    //                     container: true,
    //                     label: SemanticStrings.searchThisArea,
    //                     child: AnimatedContainer(
    //                       key: const Key(SemanticStrings.searchThisArea),
    //                       duration: controller.buttonWidthAnimationDuration,
    //                       curve: Curves.easeIn,
    //                       width: controller.buttonWidth.value,
    //                       height: controller.buttonHeight,
    //                       decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(30),
    //                         color: controller.isLoaderProgressCompleted.value
    //                             ? DrivenColors.primary
    //                             : Colors.white,
    //                         border: controller.isLoading.value
    //                             ? null
    //                             : Border.all(
    //                                 color: DrivenColors.primary,
    //                                 width: 2,
    //                               ),
    //                       ),
    //                       alignment: Alignment.center,
    //                       child: _buildChild(),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         )
    //       : const SizedBox.shrink(),
    // );
  }

  Widget _buildChild() {
    return controller.completeMapLoader.value
        ? _checkIcon()
        : controller.isLoading.value
            ? _progressLoader()
            : _searchThisAreaText();
  }

  Widget _progressLoader() {
    return Obx(() {
      final bool isProgressValueGreaterThanMaxValue =
          controller.progressValue() >= 1;
      final progressValue =
          isProgressValueGreaterThanMaxValue ? 1.0 : controller.progressValue();
      return SizedBox(
        width: controller.buttonHeight,
        height: controller.buttonHeight,
        child: CircularProgressIndicator(
          value: progressValue,
          valueColor: const AlwaysStoppedAnimation<Color>(DrivenColors.primary),
          backgroundColor: Colors.transparent,
        ),
      );
    });
  }

  Widget _checkIcon() {
    return const Icon(
      Icons.check_rounded,
      color: DrivenColors.white,
      size: 30,
    );
  }

  Widget _searchThisAreaText() {
    return const FittedBox(
      child: Text(
        SLInternalText.searchThisArea,
        style: TextStyle(
          color: DrivenColors.primary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
