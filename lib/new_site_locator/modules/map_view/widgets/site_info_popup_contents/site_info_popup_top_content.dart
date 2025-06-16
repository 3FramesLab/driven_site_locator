part of map_view_module;

class SiteInfoPopupTopContent extends StatelessWidget {
  SiteInfoPopupTopContent(this.selectedSiteLocation, this.milesData);

  final SiteLocatorController siteLocatorController = Get.find();
  final SiteLocation selectedSiteLocation;
  final String milesData;

  @override
  Widget build(BuildContext context) {
    return _popupTopContent(context);
  }

  Widget _popupTopContent(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SiteInfoPanelHeader(siteLocation: selectedSiteLocation),
        GallonPreferredSite(siteLocation: selectedSiteLocation),
        SiteMilesAway(siteLocation: selectedSiteLocation),
        SiteAddress(siteLocation: selectedSiteLocation),
      ],
    );
  }
}
