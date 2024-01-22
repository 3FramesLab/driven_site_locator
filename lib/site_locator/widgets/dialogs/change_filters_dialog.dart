import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/map_view_module.dart';
import 'package:driven_site_locator/site_locator/widgets/dialogs/single_function_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeFiltersDialog extends StatelessWidget {
  final SiteLocatorController siteLocatorController = Get.find();
  ChangeFiltersDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleFunctionDialog(
      dialogTitle: SiteLocatorConstants.changeFiltersDialogText,
      buttonTitle: SiteLocatorConstants.changeFilters,
      onButtonTap: navToEnhancedFiltersPage,
      onCancelTap: onCancelTap,
    );
  }

  Future<void> navToEnhancedFiltersPage() async {
    Get.back();
    siteLocatorController.navigateToEnhancedFilter();
  }

  void onCancelTap() => Get.back();
}
