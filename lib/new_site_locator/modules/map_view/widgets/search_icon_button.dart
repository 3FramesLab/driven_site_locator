part of map_view_module;

class SearchIconButton extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();
  static final _entitlementRepository = SiteLocatorEntitlementUtils.instance;

  SearchIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return _entitlementRepository.isSearchSitesEnabled
        ? Obx(
            () => siteLocatorController.searchIconButtonVisible()
                ? Container(
                    width: 50,
                    margin: const EdgeInsets.only(right: 10),
                    child: Semantics(
                      container: true,
                      label: SLSemanticStrings.gpsIconButton,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO(Smeet): need superapp.
                          // NavTo.searchPlace(
                          //   arguments: {
                          //     RouteArguments.fromScreen:
                          //         Routes.unauthSiteLocator,
                          //   },
                          // );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                          backgroundColor: Colors.white,
                        ),
                        child: const Icon(
                          Icons.search,
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
