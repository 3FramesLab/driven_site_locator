part of map_view_module;

void siteDetailPopup(
  SiteLocation selectedSiteLocation, {
  Color barrierColor = const Color(0x80000000),
}) {
  final siteLocatorController = Get.find<SLSiteLocatorController>();

  siteLocatorController.isSiteInfoDialogOpened(true);
  final milesData = siteLocatorController.displayMiles(selectedSiteLocation);
  Get.generalDialog(
    barrierLabel: siteLocatorController.selectedMapPinKey,
    barrierDismissible: true,
    barrierColor: barrierColor,
    transitionDuration: const Duration(milliseconds: 600),
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.only(bottom: 40, left: 12, right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SiteInfoPopupTopContent(selectedSiteLocation, milesData),
                  SiteInfoPopupMiddleContent(selectedSiteLocation),
                  SiteInfoPopupBottomContent(selectedSiteLocation),
                ],
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
            .animate(anim1),
        child: child,
      );
    },
  ).then((val) {
    siteLocatorController.siteInfoDrawerOnPanelClosedEventHandler();
    siteLocatorController.siteInfoDrawerOnPanelSlideEventHandler(0);
    siteLocatorController.isSiteInfoDialogOpened(false);
    return null;
  });
}
