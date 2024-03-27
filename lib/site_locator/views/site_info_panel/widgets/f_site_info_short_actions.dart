import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/semantic_strings.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/utilities/external_map_utils.dart';
import 'package:driven_site_locator/site_locator/utilities/site_locator_utils.dart';
import 'package:driven_site_locator/site_locator/widgets/bottom_sheet/site_info_bottom_sheet_view.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class SiteInfoShortActions extends StatelessWidget {
  SiteInfoShortActions(this.selectedSiteLocation);

  final SiteLocatorController siteLocatorController = Get.find();
  final SiteLocation selectedSiteLocation;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        directionsButton(context),
        const SizedBox(width: 30),
        if (kIsWeb) shareLocationButtonButton(context) else callButton(context),
      ],
    );
  }

  //Call link changes - start

  Widget callButton(BuildContext context) => Expanded(
        child: Semantics(
          container: true,
          label: SemanticStrings.siteInfoCallButton,
          child: OutlinedPrimaryButton(
            onPressed: _enableSiteInfoCallButton
                ? () => _onCallButtonTap(context)
                : null,
            text: SiteLocatorConstants.call,
          ),
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
      SiteLocatorConstants.cancel,
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
    selectedItem == SiteLocatorConstants.cancel
        ? _closeDialer()
        : await _openDialerApp();
  }

  double _getDialerBottomSheetHeight(List<String> dialerListItems) =>
      dialerListItems.length *
      SiteLocatorConstants.siteInfoBottomListItemHeight;

  Future<void> _closeDialer() async {
    siteLocatorController.isBottomModalSheetOpened(false);
    Get.back();
  }

  Future<void> _openDialerApp() async {
    siteLocatorController.isBottomModalSheetOpened(true);
    Get.back();
    siteLocatorController.isBottomModalSheetVisible = false;
    await SiteLocatorUtils.launchURL(
      '${SiteLocatorConstants.siteLocatorDialerAppOpen}${selectedSiteLocation.locationPhone}',
      SiteLocatorConstants.openDialerAppErrorMessage,
    );
  }

  //Call link changes - end

  //Directions link changes - start

  Widget directionsButton(BuildContext context) => Expanded(
        child: Semantics(
          container: true,
          label: SemanticStrings.siteInfoDirectionsButton,
          child: PrimaryButton(
            onPressed: () => _onDirectionsButtonTap(context),
            text: SiteLocatorConstants.directions,
          ),
        ),
      );

  void _onDirectionsButtonTap(BuildContext context) {
    siteLocatorController.getSiteInfoDrawerDirectionsButtonClickTrackAction();
    ExternalMapUtils(
      selectedSiteLocation.siteLatitude!,
      selectedSiteLocation.siteLongitude!,
    ).openExternalMapApp(context);
  }

  // Share location - start

  Widget shareLocationButtonButton(BuildContext context) => Expanded(
        child: Semantics(
          container: true,
          label: SemanticStrings.siteInfoShareLocationButton,
          child: OutlinedPrimaryButton(
            onPressed: () {},
            text: SiteLocatorConstants.shareLocation,
          ),
        ),
      );

  // Share location - end
}
