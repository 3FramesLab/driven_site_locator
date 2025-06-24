part of sl_widget_module;

class SLHeaderTopContent extends StatelessWidget {
  final SLSiteLocatorController siteLocatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;
    return Container(
      margin: EdgeInsets.zero,
      width: double.infinity,
      padding: EdgeInsets.only(top: paddingTop),
      color: DrivenColors.white.withOpacity(0.75),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: DcSiteLocatorUtils.isGuest
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          _backButton,
          const SizedBox(width: 12),
          Expanded(child: _slHeader),
        ],
      ),
    );
  }

  Widget get _slHeader => Align(
        alignment: DcSiteLocatorUtils.isGuest
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: SLHeader(
          padding: const EdgeInsets.only(top: 15, right: 16),
          fleetChangeCallback: _fleetChangeCallback,
          showAddCard: true,
        ),
      );

  Future<void> _fleetChangeCallback() async {
    siteLocatorController.recentViewSiteLocations.clear();
    await DcSiteLocatorUtils.callMerchSitesOnFilterChange();
  }

  Widget get _backButton => SiteLocatorMapViewBackButton(
        onBackButtonPressed: _onBackTap,
      );

  void _onBackTap() {
    try {
      siteLocatorController.isFirstLaunch = true;
      DcSiteLocatorUtils.resetData();
    } catch (_) {}
    Get.back();
  }
}
