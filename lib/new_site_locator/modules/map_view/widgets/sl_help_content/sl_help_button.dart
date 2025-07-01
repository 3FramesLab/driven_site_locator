part of map_view_module;

class SLHelpButton extends StatelessWidget {
  static final _entitlementRepository = SiteLocatorEntitlementUtils.instance;
  final SLSiteLocatorController siteLocatorController = Get.find();

  SLHelpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return _entitlementRepository.isSiteLocatorHelpButtonEnabled
        ? Obx(
            () => siteLocatorController.helpButtonVisible()
                ? Container(
                    width: 50,
                    margin: const EdgeInsets.only(right: 10),
                    child: Semantics(
                      container: true,
                      label: SLSemanticStrings.gpsIconButton,
                      child: ElevatedButton(
                        onPressed: DcSiteLocatorUtils.showSLHelpSheet,
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                          backgroundColor: Colors.white,
                        ),
                        child: const Icon(
                          Icons.question_mark,
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
