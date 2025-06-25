part of map_view_module;

class ApplyForComdataCard extends StatelessWidget {
  final SLSiteLocatorController siteLocatorController = Get.find();

  ApplyForComdataCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DcSiteLocatorUtils.isGuest
        ? Padding(
            padding: const EdgeInsets.only(top: 24),
            child: PrimaryButton(
              text: SLViewText.applyForAComdataCard,
              onPressed: _onTap,
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
