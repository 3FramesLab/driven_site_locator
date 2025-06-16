part of sl_widget_module;

class SlMapLoader extends StatelessWidget {
  final siteLocatorController = Get.find<SiteLocatorController>();
  final controller = Get.find<SitesLoadingProgressController>();

  SlMapLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Visibility(
          visible: Get.find<SiteLocatorController>().isShowLoading() ||
              Get.find<SiteLocatorController>().isShowLoading(),
          child: StarProgressIndicator(
            starColor: Colors.white,
            inactiveColor: Colors.white.withOpacity(0.7),
            starSize: 16,
            animationDuration: const Duration(milliseconds: 500),
          ),
        );
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Obx(
  //     () {
  //       return Visibility(
  //         visible: Get.find<SiteLocatorController>().isShowLoading() ||
  //             Get.find<SiteLocatorController>().isShowLoading(),
  //         child: Center(
  //           child: AnimatedContainer(
  //             key: const Key('loader'),
  //             duration: controller.buttonWidthAnimationDuration,
  //             width: controller.buttonHeight,
  //             height: controller.buttonHeight,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(30),
  //               color: controller.completeMapLoader.value
  //                   ? DrivenColors.primary
  //                   : Colors.white,
  //             ),
  //             alignment: Alignment.center,
  //             child: _progressLoader(),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _progressLoader() {
  //   return Obx(() {
  //     final bool isProgressValueGreaterThanMaxValue =
  //         controller.progressValue() >= 1;
  //     final progressValue =
  //         isProgressValueGreaterThanMaxValue ? 1.0 : controller.progressValue();
  //     return controller.completeMapLoader.value
  //         ? const Icon(
  //             Icons.check_rounded,
  //             color: DrivenColors.white,
  //             size: 30,
  //           )
  //         : SizedBox(
  //             width: controller.buttonHeight,
  //             height: controller.buttonHeight,
  //             child: CircularProgressIndicator(
  //               value: progressValue,
  //               valueColor:
  //                   const AlwaysStoppedAnimation<Color>(DrivenColors.primary),
  //               backgroundColor: Colors.transparent,
  //             ),
  //           );
  //   });
  // }
}
