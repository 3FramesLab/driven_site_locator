import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/modules/filters/filter_module.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:get/get.dart';

class EnhancedNoLocationDialog extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();
  final EnhancedFilterController enhancedFilterController = Get.find();

  @override
  Widget build(BuildContext context) {
    return DrivenDialog(
      text: _message(),
      primaryButton: _primaryButton(context),
      has3CTAButtons: canShow3CTAButtons(),
      secondaryLeftButtonText: SiteLocatorConstants.removeNewFilters,
      secondaryRightButtonText: SiteLocatorConstants.cancel,
      isDynamicAlert: true,
      secondaryLeftButtonOnPressed: _onRemoveNewFiltersButtonTap,
      secondaryRightButtonOnPressed: _onCancelButtonTap,
    );
  }

  void _onCancelButtonTap() {
    siteLocatorController.getNoLocationModalCancelClickTrackAction();
    Get.back();
    siteLocatorController.resetExpandRadiusButtonTapCount();
  }

  Future<void> _onRemoveNewFiltersButtonTap() async {
    siteLocatorController.getNoLocationModalClearNewFilterClickTrackAction();
    Get.back();
    siteLocatorController.resetExpandRadiusButtonTapCount();
    await enhancedFilterController.removeNewlyAddedFilter();
    // Check if filter list is empty to invoke 2 CTA modal
    final isFilterListEmpty =
        siteLocatorController.filteredSiteLocationsList.isEmpty;
    siteLocatorController.canShow2CTA(isFilterListEmpty);
    siteLocatorController.show2CTAButton(
        show2CTA: siteLocatorController.canShow2CTA());
    enhancedFilterController.isFavOptionSelectedLastTime(false);
  }

  List<TextSpan> _message() => [
        const TextSpan(
          text: SiteLocatorConstants.noMatchingLocationDialogTitle,
        )
      ];

  Widget _primaryButton(BuildContext context) => PrimaryButton(
        onPressed: siteLocatorController.expandSearchRadius,
        text: SiteLocatorConstants.noMatchingLocationDialogButtonText,
      );

  bool canShow3CTAButtons() {
    if (enhancedFilterController.isFavoriteQuickFilterOptionSelected() &&
        enhancedFilterController.isFavOptionSelectedLastTime()) {
      return false;
    }
    return !siteLocatorController.canShow2CTA();
  }
}
