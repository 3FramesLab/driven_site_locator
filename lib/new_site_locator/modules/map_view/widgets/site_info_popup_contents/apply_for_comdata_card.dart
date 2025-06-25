part of map_view_module;

class ApplyForComdataCard extends StatelessWidget {
  final SLSiteLocatorController siteLocatorController = Get.find();

  ApplyForComdataCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DcSiteLocatorUtils.isGuest
        ? GestureDetector(
            onTap: _onTap,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  SLViewText.applyForAComdataCard,
                  textAlign: TextAlign.left,
                  style: f16SemiBoldPrimary.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  void _onTap() {
    Get.back();
    // TODO(Smeet): get from super-app.
    // NavTo.dcWebView(
    //   title: SLViewText.ourFuelCards,
    //   url: DrivenConfiguration.applyCardUrl,
    // ).then((_) {
    //   if (siteLocatorController.isSiteInfoPanelOpenFromList) {
    //     if (siteLocatorController.previousSiteLocation != null) {
    //       siteDetailPopup(siteLocatorController.previousSiteLocation!);
    //     }
    //   } else {
    //     if (siteLocatorController.previousMarkerDetails != null) {
    //       siteLocatorController
    //           .onMarkerTap(siteLocatorController.previousMarkerDetails!);
    //     }
    //   }
    // });
  }
}
