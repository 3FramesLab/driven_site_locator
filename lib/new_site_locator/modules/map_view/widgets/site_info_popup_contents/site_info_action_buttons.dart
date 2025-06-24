part of map_view_module;

class SiteInfoActionButtons extends StatelessWidget {
  SiteInfoActionButtons(this.selectedSiteLocation);

  final SLSiteLocatorController siteLocatorController = Get.find();
  final SiteLocation selectedSiteLocation;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        directionsButton(context),
        if (SiteInfoUtils.canShowPhoneNumber(selectedSiteLocation))
          const SizedBox(width: 15),
        if (SiteInfoUtils.canShowPhoneNumber(selectedSiteLocation))
          callButton(context),
      ],
    );
  }

  Widget _outlinedButtonWithTextAndIcon(
      String text, IconData icon, VoidCallback onPressed) {
    return Container(
      width: 150,
      height: 40,
      child: OutlinedButton.icon(
        icon: Icon(
          icon,
          color: DrivenColors.primary,
          size: 24,
        ),
        label: SubTitleText(
          title: text,
          color: DrivenColors.primary,
          fontWeight: semiBold,
        ),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: const BorderSide(color: DrivenColors.primary, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget callButton(BuildContext context) => Expanded(
        child: Semantics(
          container: true,
          label: SLSemanticStrings.siteInfoCallButton,
          child: _outlinedButtonWithTextAndIcon(
              SLViewText.call,
              Icons.call_outlined,
              () =>
                  _enableSiteInfoCallButton ? _onCallButtonTap(context) : null),
        ),
      );

  bool get _enableSiteInfoCallButton =>
      selectedSiteLocation.locationPhone?.isNotEmpty ?? false;

  Future<void> _showBottomModalSheet(
    BuildContext context,
    Widget builderWidget,
  ) async {
    final Future<void> futureModalSheet = showModalBottomSheet(
      enableDrag: false,
      context: context,
      builder: (_) => builderWidget,
    ).whenComplete(() => closeModalBottomSheet);
    await futureModalSheet.then((_) => closeModalBottomSheet());
  }

  void closeModalBottomSheet() {
    siteLocatorController.isBottomModalSheetOpened(false);
  }

  Future<void> _onCallButtonTap(BuildContext context) async {
    siteLocatorController.getSiteInfoDrawerCallButtonClickTrackAction();
    siteLocatorController.isBottomModalSheetVisible = true;
    await _showBottomModalSheet(context, _dialerBottomSheet());
  }

  Widget _dialerBottomSheet() {
    final dialerListItems = [
      formatPhone('+1 ${selectedSiteLocation.locationPhone}'),
      SLInternalText.cancel,
    ];
    return SizedBox(
      height: _getDialerBottomSheetHeight(dialerListItems),
      child: _dialerSiteInfoListView(dialerListItems),
    );
  }

  Widget _dialerSiteInfoListView(List<String> dialerListItems) =>
      SiteInfoBottomSheetView(
        itemList: dialerListItems,
        onItemTapped: (selectedItem) async => _onDialerItemTapped(selectedItem),
      );

  Future<void> _onDialerItemTapped(String selectedItem) async {
    selectedItem == SLInternalText.cancel
        ? _closeDialer()
        : await _openDialerApp();
  }

  double _getDialerBottomSheetHeight(List<String> dialerListItems) =>
      dialerListItems.length * SLInternalText.siteInfoBottomListItemHeight;

  Future<void> _closeDialer() async {
    siteLocatorController.isBottomModalSheetOpened(false);
    Get.back();
  }

  Future<void> _openDialerApp() async {
    siteLocatorController.isBottomModalSheetOpened(true);
    Get.back();
    siteLocatorController.isBottomModalSheetVisible = false;
    await DcSiteLocatorUtils.launchURL(
      '${SLInternalText.siteLocatorDialerAppOpen}${selectedSiteLocation.locationPhone}',
      SLInternalText.openDialerAppErrorMessage,
    );
  }

  Widget directionsButton(BuildContext context) => Expanded(
        child: Semantics(
          container: true,
          label: SLSemanticStrings.siteInfoDirectionsButton,
          child: _outlinedButtonWithTextAndIcon(SLViewText.directions,
              Icons.map_outlined, () => _onDirectionsButtonTap(context)),
        ),
      );

  Future<void> _onDirectionsButtonTap(BuildContext context) async {
    final isLocationEnabled = await MapUtilities.getLocationPermissionStatus();
    if (isLocationEnabled) {
      siteLocatorController.getSiteInfoDrawerDirectionsButtonClickTrackAction();
      await ExternalMapUtils(
        selectedSiteLocation.siteLatitude!,
        selectedSiteLocation.siteLongitude!,
      ).openExternalMapApp(context);
    } else {
      unawaited(Get.dialog(const ShareMyLocationDialog()));
      // Navigator.of(context, rootNavigator: true)
      //     .pop(siteLocatorController.selectedMapPinKey);
      // await openAppSettings();
    }
  }
}
